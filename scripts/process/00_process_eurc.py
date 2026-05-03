# -*- coding: utf-8 -*-
"""
Processes EURC attestation PDFs and extracts reserve information.
Each PDF contains two report dates - both are extracted as separate rows.
Reads from data/raw/eurc/, saves to data/processed/eurc/eurc_reserves.csv

Requires pdfplumber:
    pip install pdfplumber

Usage:
    python scripts/process/00_process_eurc.py
"""

import re
import pdfplumber
import pandas as pd
from pathlib import Path

RAW_DIR = Path(__file__).parent.parent.parent / "data" / "raw" / "eurc"
OUT_DIR = Path(__file__).parent.parent.parent / "data" / "processed" / "eurc"
OUT_DIR.mkdir(parents=True, exist_ok=True)


def clean_number(text):
    if not text:
        return None
    text = text.strip()
    negative = text.startswith("(") and text.endswith(")")
    cleaned = re.sub(r"[EUReuro$(),\s]", "", text).replace(",", "")
    try:
        val = float(cleaned)
        return -val if negative else val
    except ValueError:
        return None


def parse_report(pdf_path):
    with pdfplumber.open(pdf_path) as pdf:
        pages = [page.extract_text() or "" for page in pdf.pages]
    full_text = "\n".join(pages)

    rows = []

    # --- Extract EURC in Circulation (two values on one line) ---
    circ_match = re.search(r"EURC in Circulation\s+([\d,]+)\s+([\d,]+)", full_text)
    circ_values = []
    if circ_match:
        circ_values = [clean_number(circ_match.group(1)), clean_number(circ_match.group(2))]

    # --- Extract Fair Value of Reserves (two values) ---
    fv_match = re.search(
        r"Fair Value of Assets Held in EURC Reserve\s+.{0,3}([\d,]+)\s+.{0,3}([\d,]+)",
        full_text
    )
    fv_values = []
    if fv_match:
        fv_values = [clean_number(fv_match.group(1)), clean_number(fv_match.group(2))]

    # --- Extract Report Dates ---
    date_match = re.search(
        r"Report Dates\s+([A-Za-z]+ \d{1,2},? \d{4})\s+([A-Za-z]+ \d{1,2},? \d{4})",
        full_text
    )
    report_dates = []
    if date_match:
        report_dates = [date_match.group(1).strip(), date_match.group(2).strip()]

    # --- Extract reserve sections (avoid matching TOTAL lines) ---
    # Use \nEURC RESERVE ASSETS AS OF to avoid matching TOTAL EURC RESERVE ASSETS AS OF
    # Total line: old format has no currency symbol; new format (2024-07+) has € before the number
    section_pattern = re.compile(
        r"\nEURC RESERVE ASSETS AS OF ([A-Z]+ \d{1,2}, \d{4})\n(.*?)"
        r"TOTAL EURC RESERVE ASSETS AS OF [A-Z]+ \d{1,2}, \d{4}\s+\S*\s*([\d,]+)",
        re.DOTALL
    )

    section_data = []
    for m in section_pattern.finditer(full_text):
        date_str  = m.group(1)
        body      = m.group(2)
        total     = clean_number(m.group(3))

        # Cash held
        # Old format: number on line before label
        # New format (2024-07+): label then currency symbol then number on same line
        cash_match = re.search(r"([\d,]+)\s*\nCash held at regulated financial institutions", body)
        if cash_match:
            cash = clean_number(cash_match.group(1))
        else:
            cash_match = re.search(r"Cash held at regulated financial institutions\s+\S+\s+([\d,]+)", body)
            cash = clean_number(cash_match.group(1)) if cash_match else None

        # Settlement differences
        # Old format: parenthesized negative at end of line
        # New format (2024-07+): currency symbol then number after "net N"
        settle_match = re.search(r"timing and settlement differences[^\n]*?([\(\d,\)]+)\s*$", body, re.MULTILINE)
        if settle_match:
            settlement = clean_number(settle_match.group(1))
        else:
            settle_match = re.search(r"timing and settlement differences.*?net \d+\s+\S+\s+(\([\d,]+\)|[\d,]+)", body, re.DOTALL)
            settlement = clean_number(settle_match.group(1)) if settle_match else None

        section_data.append({
            "section_date":   date_str,
            "cash_held":      cash,
            "settlement":     settlement,
            "total_reserves": total,
        })

    # Auditor
    auditor = None
    for firm in ["Deloitte", "Grant Thornton", "KPMG", "PwC", "Ernst & Young"]:
        if firm.lower() in full_text.lower():
            auditor = firm
            break

    # Build one row per report date
    n = max(len(report_dates), len(section_data), 1)
    for idx in range(n):
        row = {
            "file":                pdf_path.name,
            "report_date":         report_dates[idx] if idx < len(report_dates) else None,
            "eurc_in_circulation": circ_values[idx]  if idx < len(circ_values)  else None,
            "fair_value_reserves": fv_values[idx]    if idx < len(fv_values)    else None,
            "cash_held":           section_data[idx]["cash_held"]      if idx < len(section_data) else None,
            "settlement":          section_data[idx]["settlement"]     if idx < len(section_data) else None,
            "total_reserves":      section_data[idx]["total_reserves"] if idx < len(section_data) else None,
            "auditor":             auditor,
        }
        rows.append(row)

    return rows


def process_all():
    pdfs = sorted(RAW_DIR.glob("eurc_*.pdf"))
    if not pdfs:
        print("No PDFs found in {}. Run 00_fetch_eurc.py first.".format(RAW_DIR))
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
    out_path = OUT_DIR / "eurc_reserves.csv"
    df.to_csv(out_path, index=False)
    print("\nSaved {} rows to {}".format(len(df), out_path))
    print(df.to_string())


if __name__ == "__main__":
    process_all()
