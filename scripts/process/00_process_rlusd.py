# -*- coding: utf-8 -*-
"""
Processes RLUSD attestation PDFs and extracts reserve information.
Each PDF contains two report dates - both are extracted as separate rows.
Reads from data/raw/rlusd/, saves to data/processed/rlusd/rlusd_reserves.csv

Usage:
    python scripts/process/00_process_rlusd.py
"""

import re
import pdfplumber
import pandas as pd
from pathlib import Path

RAW_DIR = Path(__file__).parent.parent.parent / "data" / "raw" / "rlusd"
OUT_DIR = Path(__file__).parent.parent.parent / "data" / "processed" / "rlusd"
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


def parse_report(pdf_path):
    with pdfplumber.open(pdf_path) as pdf:
        pages = [page.extract_text() or "" for page in pdf.pages]
    full_text = "\n".join(pages)

    rows = []

    # --- Extract report dates ---
    # Format: "as of [Month DD, YYYY], and as of [Month DD, YYYY]"
    # Or: "as of [Month DD, YYYY] and [Month DD, YYYY]"
    date_pattern = re.compile(
        r"as of ([A-Za-z]+ \d{1,2},? \d{4}),? and(?:,? as of)? ([A-Za-z]+ \d{1,2},? \d{4})",
        re.IGNORECASE
    )
    date_match = date_pattern.search(full_text)
    report_dates = []
    if date_match:
        report_dates = [date_match.group(1).strip(), date_match.group(2).strip()]

    # --- Extract RLUSD outstanding (two values) ---
    # "Total RLUSD outstanding  123,456,789  234,567,890"
    outstanding_match = re.search(
        r"[Tt]otal RLUSD outstanding\s+([\d,]+(?:\.\d+)?)\s+([\d,]+(?:\.\d+)?)",
        full_text
    )
    outstanding_values = []
    if outstanding_match:
        outstanding_values = [
            clean_number(outstanding_match.group(1)),
            clean_number(outstanding_match.group(2)),
        ]

    # --- Extract total market value of reserves (two values) ---
    # "Total market value of Reserves  123,456,789  234,567,890"
    reserves_match = re.search(
        r"[Tt]otal market value of (?:the )?[Rr]eserves\s+([\d,]+(?:\.\d+)?)\s+([\d,]+(?:\.\d+)?)",
        full_text
    )
    reserve_values = []
    if reserves_match:
        reserve_values = [
            clean_number(reserves_match.group(1)),
            clean_number(reserves_match.group(2)),
        ]

    # --- Extract reserve breakdown by asset class (two columns each) ---
    # U.S. Treasury Bills
    tbills_match = re.search(
        r"U\.S\. Treasury [Bb]ills?\s+([\d,]+(?:\.\d+)?)\s+([\d,]+(?:\.\d+)?)",
        full_text
    )
    tbills = []
    if tbills_match:
        tbills = [clean_number(tbills_match.group(1)), clean_number(tbills_match.group(2))]

    # Government money market funds
    mmf_match = re.search(
        r"[Gg]overnment (?:money[- ]market|money market) funds?\s+([\d,]+(?:\.\d+)?)\s+([\d,]+(?:\.\d+)?)",
        full_text
    )
    mmf = []
    if mmf_match:
        mmf = [clean_number(mmf_match.group(1)), clean_number(mmf_match.group(2))]

    # Cash / bank deposits
    cash_match = re.search(
        r"[Cc]ash(?: and cash equivalents)?(?: at| held at| in)? (?:bank|depository|insured)\s+([\d,]+(?:\.\d+)?)\s+([\d,]+(?:\.\d+)?)",
        full_text
    )
    cash = []
    if cash_match:
        cash = [clean_number(cash_match.group(1)), clean_number(cash_match.group(2))]

    # Auditor
    auditor = None
    for firm in ["BPM", "Deloitte", "Grant Thornton", "KPMG", "PwC", "Ernst & Young", "Moore"]:
        if firm.lower() in full_text.lower():
            auditor = firm
            break

    n = max(len(report_dates), len(outstanding_values), 1)
    for idx in range(n):
        rows.append({
            "file":              pdf_path.name,
            "report_date":       report_dates[idx]     if idx < len(report_dates)     else None,
            "rlusd_outstanding": outstanding_values[idx] if idx < len(outstanding_values) else None,
            "total_reserves":    reserve_values[idx]   if idx < len(reserve_values)   else None,
            "tbills":            tbills[idx]            if idx < len(tbills)           else None,
            "money_mkt_funds":   mmf[idx]               if idx < len(mmf)              else None,
            "cash":              cash[idx]              if idx < len(cash)             else None,
            "auditor":           auditor,
        })

    return rows


def process_all():
    pdfs = sorted(RAW_DIR.glob("rlusd_*.pdf"))
    if not pdfs:
        print("No PDFs found in {}. Run 00_fetch_rlusd.py first.".format(RAW_DIR))
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
    out_path = OUT_DIR / "rlusd_reserves.csv"
    df.to_csv(out_path, index=False)
    print("\nSaved {} rows to {}".format(len(df), out_path))
    print(df.to_string())


if __name__ == "__main__":
    process_all()
