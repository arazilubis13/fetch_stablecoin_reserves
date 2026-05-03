# -*- coding: utf-8 -*-
"""
Processes USDT (Tether) quarterly BDO attestation PDFs and extracts key figures.
Reports are quarterly with a single report date.

Key fields extracted:
  - Report date
  - USD₮ in circulation (= liabilities, in USD)
  - Total assets (in USD)
  - Equity / excess reserves (in USD)
  - Reserve composition: US Treasuries, reverse repos, cash, Bitcoin, gold, other

Reads from data/raw/usdt/, saves to data/processed/usdt/usdt_reserves.csv

Usage:
    python scripts/process/00_process_usdt.py
"""

import re
import pdfplumber
import pandas as pd
from pathlib import Path

RAW_DIR = Path(__file__).parent.parent.parent / "data" / "raw" / "usdt"
OUT_DIR = Path(__file__).parent.parent.parent / "data" / "processed" / "usdt"
OUT_DIR.mkdir(parents=True, exist_ok=True)


def clean_number(text):
    """Parse a number, handling parentheses for negatives and USD millions label."""
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


def parse_report(pdf_path):
    with pdfplumber.open(pdf_path) as pdf:
        pages = [page.extract_text() or "" for page in pdf.pages]
    full_text = "\n".join(pages)

    # --- Report date ---
    # "as at 30 June 2025" or "as of 30 June 2025" or "31 December 2024"
    date_match = re.search(
        r"as (?:at|of) (\d{1,2} [A-Za-z]+ \d{4})",
        full_text
    )
    # Also try "30 June 2025" at start of key figures table
    if not date_match:
        date_match = re.search(r"(\d{1,2} [A-Za-z]+ \d{4})", full_text)
    report_date = date_match.group(1).strip() if date_match else None

    # --- Key financial figures (in USD millions) ---
    # Pattern from table: "Tether International... [assets] ([liabilities]) [equity]"
    # Assets, Liabilities (negative, in parens), Equity - all in USD millions
    kff_match = re.search(
        r"Tether (?:International|Holdings|Limited)[^\n]*?\s+([\d,]+)\s+\(([\d,]+)\)\s+([\d,]+)",
        full_text
    )
    assets_musd = clean_number(kff_match.group(1)) if kff_match else None
    liabilities_musd = clean_number(kff_match.group(2)) if kff_match else None  # USD₮ in circulation
    equity_musd = clean_number(kff_match.group(3)) if kff_match else None

    # Convert from USD millions to USD
    usdt_in_circulation = liabilities_musd * 1e6 if liabilities_musd is not None else None
    total_assets = assets_musd * 1e6 if assets_musd is not None else None
    excess_reserves = equity_musd * 1e6 if equity_musd is not None else None

    # --- Reserve composition (also in USD millions) ---
    # US Treasury Bills
    tbills_match = re.search(
        r"U\.S\. Treasury (?:Bills?|Securities|T-Bills?)[^\n]*?\s+([\d,]+(?:\.\d+)?)",
        full_text, re.IGNORECASE
    )
    tbills = clean_number(tbills_match.group(1)) * 1e6 if tbills_match else None

    # Reverse repurchase agreements / Repos
    repo_match = re.search(
        r"[Rr]everse [Rr]epo(?:rchase)?(?: [Aa]greements?)?\s+([\d,]+(?:\.\d+)?)",
        full_text
    )
    repos = clean_number(repo_match.group(1)) * 1e6 if repo_match else None

    # Money market funds
    mmf_match = re.search(
        r"[Mm]oney [Mm]arket [Ff]unds?\s+([\d,]+(?:\.\d+)?)",
        full_text
    )
    mmf = clean_number(mmf_match.group(1)) * 1e6 if mmf_match else None

    # Bitcoin
    btc_match = re.search(
        r"Bitcoin\s+([\d,]+(?:\.\d+)?)",
        full_text
    )
    bitcoin = clean_number(btc_match.group(1)) * 1e6 if btc_match else None

    # Gold / Precious metals
    gold_match = re.search(
        r"(?:Gold|Precious [Mm]etals?)\s+([\d,]+(?:\.\d+)?)",
        full_text
    )
    gold = clean_number(gold_match.group(1)) * 1e6 if gold_match else None

    # Secured loans
    loans_match = re.search(
        r"[Ss]ecured [Ll]oans?\s+([\d,]+(?:\.\d+)?)",
        full_text
    )
    secured_loans = clean_number(loans_match.group(1)) * 1e6 if loans_match else None

    # Auditor
    auditor = None
    for firm in ["BDO", "Deloitte", "Grant Thornton", "KPMG", "PwC", "Ernst & Young"]:
        if firm.lower() in full_text.lower():
            auditor = firm
            break

    return [{
        "file":               pdf_path.name,
        "report_date":        report_date,
        "usdt_in_circulation": usdt_in_circulation,
        "total_assets":       total_assets,
        "excess_reserves":    excess_reserves,
        "us_treasuries":      tbills,
        "reverse_repos":      repos,
        "money_mkt_funds":    mmf,
        "bitcoin":            bitcoin,
        "gold":               gold,
        "secured_loans":      secured_loans,
        "auditor":            auditor,
    }]


def process_all():
    pdfs = sorted(RAW_DIR.glob("usdt_*.pdf"))
    if not pdfs:
        print("No PDFs found in {}. Run 00_fetch_usdt.py first.".format(RAW_DIR))
        return

    print("Processing {} PDFs...\n".format(len(pdfs)))
    all_rows = []
    for pdf in pdfs:
        print("  {}...".format(pdf.name))
        try:
            rows = parse_report(pdf)
            all_rows.extend(rows)
        except Exception as e:
            print("    Error: {}".format(e))

    df = pd.DataFrame(all_rows)
    cols = ["file", "report_date", "usdt_in_circulation", "total_assets", "excess_reserves",
            "us_treasuries", "reverse_repos", "money_mkt_funds", "bitcoin", "gold",
            "secured_loans", "auditor"]
    df = df[[c for c in cols if c in df.columns]]
    out_path = OUT_DIR / "usdt_reserves.csv"
    df.to_csv(out_path, index=False)
    print("\nSaved {} rows to {}".format(len(df), out_path))
    print(df.to_string())


if __name__ == "__main__":
    process_all()
