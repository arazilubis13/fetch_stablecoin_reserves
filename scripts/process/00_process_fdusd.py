# -*- coding: utf-8 -*-
"""
Processes FDUSD attestation PDFs and extracts reserve information.
Single report date per PDF. Circulating supply stated explicitly across chains.

Reads from data/raw/fdusd/, saves to data/processed/fdusd/fdusd_reserves.csv

Note: From Jul 2025 two PDFs exist per month (_reserves and _isae3000).
      This script processes all files but deduplicates to one row per month-end date.

Usage:
    python scripts/process/00_process_fdusd.py
"""

import re
import pdfplumber
import pandas as pd
from pathlib import Path

RAW_DIR = Path(__file__).parent.parent.parent / "data" / "raw" / "fdusd"
OUT_DIR = Path(__file__).parent.parent.parent / "data" / "processed" / "fdusd"
OUT_DIR.mkdir(parents=True, exist_ok=True)


def clean_number(text):
    if not text:
        return None
    text = text.strip().replace(",", "")
    negative = text.startswith("(") and text.endswith(")")
    text = re.sub(r"[()$\s]", "", text)
    try:
        val = float(text)
        return -val if negative else val
    except ValueError:
        return None


def sum_notnone(*vals):
    nums = [v for v in vals if v is not None]
    return sum(nums) if nums else None


def parse_report(pdf_path):
    with pdfplumber.open(pdf_path) as pdf:
        pages = [page.extract_text() or "" for page in pdf.pages]
    full_text = "\n".join(pages)

    # --- Report date ---
    # "January 31, 2025" or "as of January 31, 2025" or "As of 28 February 2026" (day-first)
    date_match = re.search(
        r"(?:as of |Report Date[^\n]*?)\b([A-Za-z]+ \d{1,2},? \d{4})",
        full_text
    )
    if date_match:
        report_date = date_match.group(1).strip()
    else:
        # Day-first format: "As of 28 February 2026"
        day_first_match = re.search(
            r"[Aa]s of (\d{1,2}) ([A-Za-z]+) (\d{4})",
            full_text
        )
        if day_first_match:
            report_date = "{} {}, {}".format(
                day_first_match.group(2),
                day_first_match.group(1),
                day_first_match.group(3)
            )
        else:
            report_date = None

    # --- Total FDUSD supply (sum across all chains) ---
    # Newer format: "total supply of First Digital USD tokens ... is X FDUSD"
    # Older format: numbers per chain listed explicitly

    # Try: extract per-chain values and sum
    # Pattern: "is X FDUSD (being A in BSC and B in Ethereum)"
    eth_bsc_match = re.search(
        r"is ([\d,]+(?:\.\d+)?) FDUSD \(being ([\d,]+(?:\.\d+)?) in BSC and ([\d,]+(?:\.\d+)?) in Ethereum\)",
        full_text
    )
    # SUI supply
    sui_match = re.search(
        r"is ([\d,]+(?:\.\d+)?) FDUSD in SUI",
        full_text
    )
    # SOL supply
    sol_match = re.search(
        r"is ([\d,]+(?:\.\d+)?) FDUSD in SOL",
        full_text
    )

    eth_bsc_total = clean_number(eth_bsc_match.group(1)) if eth_bsc_match else None
    sui_supply = clean_number(sui_match.group(1)) if sui_match else None
    sol_supply = clean_number(sol_match.group(1)) if sol_match else None

    fdusd_in_circulation = sum_notnone(eth_bsc_total, sui_supply, sol_supply)

    # Fallback: look for a standalone total supply figure
    if fdusd_in_circulation is None:
        total_match = re.search(
            r"total (?:circulating )?supply[^\n]*?([\d,]+(?:\.\d+)?)\s*FDUSD",
            full_text, re.IGNORECASE
        )
        if total_match:
            fdusd_in_circulation = clean_number(total_match.group(1))

    # Fallback: new format "tokens issued and in circulation\n(Notes ...) X FDUSD"
    if fdusd_in_circulation is None:
        issued_match = re.search(
            r"tokens issued and in circulation\s*\n\(Notes[^\)]+\)\s*([\d,]+(?:\.\d+)?)\s*FDUSD",
            full_text
        )
        if issued_match:
            fdusd_in_circulation = clean_number(issued_match.group(1))

    # --- Reserve composition ---
    # US Treasury Bills/Bonds
    tbills_match = re.search(
        r"U\.S\. Treasury (?:Bills?|Bonds?|Securities|Debt|Notes?)[^\n]*?\$([\d,]+(?:\.\d+)?)",
        full_text, re.IGNORECASE
    )
    if tbills_match:
        tbills = clean_number(tbills_match.group(1))
    else:
        # New format: "(A) Sub-total: X"
        a_match = re.search(r"\(A\) Sub-total:\s*([\d,]+(?:\.\d+)?)", full_text)
        tbills = clean_number(a_match.group(1)) if a_match else None

    # Overnight reverse repo / overnight deposits / fixed deposits
    repo_match = re.search(
        r"[Oo]vernight(?: [Rr]everse)? [Rr]epo(?:rchase)?(?:[^\n]*?)\$([\d,]+(?:\.\d+)?)",
        full_text
    )
    if repo_match:
        repo = clean_number(repo_match.group(1))
    else:
        # New format: "(B) Sub-total: X" (fixed deposits)
        b_match = re.search(r"\(B\) Sub-total:\s*([\d,]+(?:\.\d+)?)", full_text)
        repo = clean_number(b_match.group(1)) if b_match else None

    # Cash / bank deposits
    cash_match = re.search(
        r"(?:[Cc]ash(?: [Dd]eposits?)?|[Bb]ank [Dd]eposits?)[^\n]*?\$([\d,]+(?:\.\d+)?)",
        full_text
    )
    if cash_match:
        cash = clean_number(cash_match.group(1))
    else:
        # New format: "(C) US$ held in custody accounts: X"
        c_match = re.search(r"\(C\) US\$ held in custody accounts:\s*([\d,]+(?:\.\d+)?)", full_text)
        cash = clean_number(c_match.group(1)) if c_match else None

    # Total reserves
    total_match = re.search(
        r"[Tt]otal(?: [Rr]eserve [Aa]ccount[s]?| [Aa]ssets)[^\n]*?\$([\d,]+(?:\.\d+)?)",
        full_text
    )
    if total_match:
        total_reserves = clean_number(total_match.group(1))
    else:
        # New format: "(A) + (B) + (C) Total assets held in Reserve Accounts: US$X"
        abc_match = re.search(
            r"\(A\) \+ \(B\) \+ \(C\) Total assets held in Reserve Accounts:\s*US\$([\d,]+(?:\.\d+)?)",
            full_text
        )
        total_reserves = clean_number(abc_match.group(1)) if abc_match else None

    # Auditor
    auditor = None
    for firm in ["Ko Chi Kwong", "IAPA", "Prism", "Deloitte", "Grant Thornton",
                 "KPMG", "PwC", "Ernst & Young", "Moore", "BDO"]:
        if firm.lower() in full_text.lower():
            auditor = firm
            break

    return {
        "file":                  pdf_path.name,
        "report_date":           report_date,
        "fdusd_in_circulation":  fdusd_in_circulation,
        "eth_bsc_supply":        eth_bsc_total,
        "sui_supply":            sui_supply,
        "sol_supply":            sol_supply,
        "us_treasuries":         tbills,
        "overnight_repo":        repo,
        "cash":                  cash,
        "total_reserves":        total_reserves,
        "auditor":               auditor,
    }


def process_all():
    # Process all PDFs but prefer _isae3000 > _reserves > base for deduplication
    pdfs = sorted(RAW_DIR.glob("fdusd_*.pdf"))
    if not pdfs:
        print("No PDFs found in {}. Run 00_fetch_fdusd.py first.".format(RAW_DIR))
        return

    print("Processing {} PDFs...\n".format(len(pdfs)))
    all_rows = []
    for pdf in pdfs:
        print("  {}...".format(pdf.name))
        try:
            row = parse_report(pdf)
            all_rows.append(row)
        except Exception as e:
            print("    Error: {}".format(e))

    df = pd.DataFrame(all_rows)

    # Dedup: for months with multiple files, keep the row with most non-null values
    df["_nonnull"] = df.notna().sum(axis=1)
    df = df.sort_values("_nonnull", ascending=False).drop_duplicates(
        subset=["report_date"], keep="first"
    ).drop(columns="_nonnull").sort_values("report_date")

    cols = ["file", "report_date", "fdusd_in_circulation", "eth_bsc_supply",
            "sui_supply", "sol_supply", "us_treasuries", "overnight_repo",
            "cash", "total_reserves", "auditor"]
    df = df[[c for c in cols if c in df.columns]]
    out_path = OUT_DIR / "fdusd_reserves.csv"
    df.to_csv(out_path, index=False)
    print("\nSaved {} rows to {}".format(len(df), out_path))
    print(df.to_string())


if __name__ == "__main__":
    process_all()
