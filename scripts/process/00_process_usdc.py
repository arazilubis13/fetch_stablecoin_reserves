# -*- coding: utf-8 -*-
"""
Processes USDC attestation PDFs and extracts reserve information.

Report formats differ by era:
  - 2023+: Two report dates per PDF, Circle Reserve Fund + Other USDC Reserve Assets
  - 2022:  Single date, older Grant Thornton layout (limited extraction)
  - Pre-2022: Mostly image-based, minimal extraction possible

Reads from data/raw/usdc/, saves to data/processed/usdc/usdc_reserves.csv

Usage:
    python scripts/process/00_process_usdc.py
"""

import re
import pdfplumber
import pandas as pd
from pathlib import Path

RAW_DIR = Path(__file__).parent.parent.parent / "data" / "raw" / "usdc"
OUT_DIR = Path(__file__).parent.parent.parent / "data" / "processed" / "usdc"
OUT_DIR.mkdir(parents=True, exist_ok=True)


def clean_number(text):
    if not text:
        return None
    text = text.strip()
    negative = text.startswith("(") and text.endswith(")")
    cleaned = re.sub(r"[$,\s()]", "", text)
    try:
        val = float(cleaned)
        return -val if negative else val
    except ValueError:
        return None


def parse_treasury_securities(full_text):
    """
    Extract individual Treasury security rows (CUSIP, maturity, fair value).
    Returns a list of dicts, one per CUSIP per report date.
    """
    tsy_rows = []

    # Find each "CIRCLE RESERVE FUND ASSETS AS OF [DATE]" section
    section_pattern = re.compile(
        r"CIRCLE RESERVE FUND ASSETS AS OF ([A-Z]+ \d{1,2}, \d{4})"
        r".*?Cusip\s+Maturity Date\s+Fair Value.*?\n"
        r"(.*?)"
        r"TOTAL U\.S\. TREASURY SECURITIES",
        re.DOTALL
    )

    for m in section_pattern.finditer(full_text):
        report_date = m.group(1)
        body        = m.group(2)

        # Each line: CUSIP (9 alphanumeric chars)  MM/DD/YY  number
        line_pattern = re.compile(r"([A-Z0-9]{9})\s+(\d{2}/\d{2}/\d{2,4})\s+([\d,]+)")
        for line_m in line_pattern.finditer(body):
            tsy_rows.append({
                "report_date":   report_date,
                "cusip":         line_m.group(1),
                "maturity_date": line_m.group(2),
                "fair_value":    clean_number(line_m.group(3)),
            })

    return tsy_rows


def parse_modern(full_text):
    """Parse 2023+ format with two report dates per PDF."""
    rows = []

    # USDC in Circulation (two values)
    circ_match = re.search(r"USDC in Circulation\s+([\d,]+)\s+([\d,]+)", full_text)
    circ_values = []
    if circ_match:
        circ_values = [clean_number(circ_match.group(1)), clean_number(circ_match.group(2))]

    # Fair Value of Assets (two values)
    fv_match = re.search(
        r"Fair Value of Assets Held in USDC Reserve\s+\$?\s*([\d,]+)\s+\$?\s*([\d,]+)",
        full_text
    )
    fv_values = []
    if fv_match:
        fv_values = [clean_number(fv_match.group(1)), clean_number(fv_match.group(2))]

    # Report Dates
    date_match = re.search(
        r"Report Dates\s+([A-Za-z]+ \d{1,2},? \d{4})\s+([A-Za-z]+ \d{1,2},? \d{4})",
        full_text
    )
    report_dates = []
    if date_match:
        report_dates = [date_match.group(1).strip(), date_match.group(2).strip()]

    # Per-date reserve sections
    # Pattern: from "CIRCLE RESERVE FUND ASSETS AS OF [DATE]" to "TOTAL USDC RESERVE ASSETS AS OF [DATE] [total]"
    section_pattern = re.compile(
        r"CIRCLE RESERVE FUND ASSETS AS OF ([A-Z]+ \d{1,2}, \d{4})\n"
        r"(.*?)"
        r"TOTAL USDC RESERVE ASSETS AS OF [A-Z]+ \d{1,2}, \d{4}\s+([\d,]+)",
        re.DOTALL
    )

    section_data = []
    for m in section_pattern.finditer(full_text):
        body  = m.group(2)
        total = clean_number(m.group(3))

        # US Treasury Securities total
        tsy_match = re.search(r"TOTAL U\.S\. TREASURY SECURITIES\s+([\d,]+)", body)
        treasury = clean_number(tsy_match.group(1)) if tsy_match else None

        # Repo agreements
        repo_match = re.search(r"U\.S\. Treasury Repurchase Agreements\s+\d?\s*([\d,]+)", body)
        repo = clean_number(repo_match.group(1)) if repo_match else None

        # Cash in Circle Reserve Fund
        fund_cash_match = re.search(r"Cash held in Circle Reserve Fund\s+([\d,]+)", body)
        fund_cash = clean_number(fund_cash_match.group(1)) if fund_cash_match else None

        # Total Circle Reserve Fund
        fund_total_match = re.search(r"TOTAL CIRCLE RESERVE FUND ASSETS\s+([\d,]+)", body)
        fund_total = clean_number(fund_total_match.group(1)) if fund_total_match else None

        # Settlement within Circle Reserve Fund (can be negative, shown in parentheses)
        fund_settle_match = re.search(
            r"Circle Reserve Fund due to timing.*?net\d?\s+(\([\d,]+\)|[\d,]+)",
            body, re.DOTALL
        )
        fund_settlement = clean_number(fund_settle_match.group(1)) if fund_settle_match else None

        # Cash at regulated financial institutions (number appears before "Cash held at regulated")
        bank_cash_match = re.search(r"([\d,]+)\s*\nCash held at regulated financial institutions", body)
        bank_cash = clean_number(bank_cash_match.group(1)) if bank_cash_match else None

        # Settlement within Other USDC Reserve Assets (can be positive or negative)
        other_settle_match = re.search(
            r"Cash due to/\(owed by\) Circle due to timing.*?net\d?\s+(\([\d,]+\)|[\d,]+)",
            body, re.DOTALL
        )
        other_settlement = clean_number(other_settle_match.group(1)) if other_settle_match else None

        # Total Other USDC Reserve Assets
        other_total_match = re.search(r"TOTAL OTHER USDC RESERVE ASSETS\s+([\d,]+)", body)
        other_total = clean_number(other_total_match.group(1)) if other_total_match else None

        section_data.append({
            "treasury_securities": treasury,
            "repo":                repo,
            "fund_cash":           fund_cash,
            "fund_settlement":     fund_settlement,
            "fund_total":          fund_total,
            "bank_cash":           bank_cash,
            "other_settlement":    other_settlement,
            "other_total":         other_total,
            "total_reserves":      total,
        })

    # Auditor
    auditor = None
    for firm in ["Deloitte", "Grant Thornton", "KPMG", "PwC", "Ernst & Young"]:
        if firm.lower() in full_text.lower():
            auditor = firm
            break

    n = max(len(report_dates), len(section_data), 1)
    for idx in range(n):
        s = section_data[idx] if idx < len(section_data) else {}
        rows.append({
            "report_date":         report_dates[idx] if idx < len(report_dates) else None,
            "usdc_in_circulation": circ_values[idx]  if idx < len(circ_values)  else None,
            "fair_value_reserves": fv_values[idx]    if idx < len(fv_values)    else None,
            "treasury_securities": s.get("treasury_securities"),
            "repo":                s.get("repo"),
            "fund_cash":           s.get("fund_cash"),
            "fund_settlement":     s.get("fund_settlement"),
            "fund_total":          s.get("fund_total"),
            "bank_cash":           s.get("bank_cash"),
            "other_settlement":    s.get("other_settlement"),
            "other_total":         s.get("other_total"),
            "total_reserves":      s.get("total_reserves"),
            "auditor":             auditor,
            "format":              "modern",
        })

    return rows


def parse_legacy(full_text):
    """Parse 2022 and older single-date format."""
    rows = []

    # USDC in Circulation — older format: "USDC in Circulation1 = 50,031,478,777"
    circ_match = re.search(
        r"USD\s*Coin.*?in [Cc]irculation\d?\s*[=:]\s*([\d,]+)",
        full_text, re.DOTALL
    )
    circ = clean_number(circ_match.group(1)) if circ_match else None

    # Fair value — older format often on page 1
    fv_match = re.search(r"total fair value.*?\$([\d,]+)", full_text, re.IGNORECASE | re.DOTALL)
    fv = clean_number(fv_match.group(1)) if fv_match else None

    # Report date
    date_match = re.search(r"as of ([A-Za-z]+ \d{1,2},? \d{4})", full_text)
    report_date = date_match.group(1).strip() if date_match else None

    auditor = None
    for firm in ["Deloitte", "Grant Thornton", "KPMG", "PwC", "Ernst & Young"]:
        if firm.lower() in full_text.lower():
            auditor = firm
            break

    rows.append({
        "report_date":         report_date,
        "usdc_in_circulation": circ,
        "fair_value_reserves": fv,
        "treasury_securities": None,
        "repo":                None,
        "fund_cash":           None,
        "fund_total":          None,
        "bank_cash":           None,
        "other_total":         None,
        "total_reserves":      None,
        "auditor":             auditor,
        "format":              "legacy",
    })

    return rows


def parse_report(pdf_path):
    with pdfplumber.open(pdf_path) as pdf:
        pages = [page.extract_text() or "" for page in pdf.pages]
    full_text = "\n".join(pages)

    if "CIRCLE RESERVE FUND ASSETS AS OF" in full_text:
        reserve_rows = parse_modern(full_text)
        tsy_rows     = parse_treasury_securities(full_text)
    else:
        reserve_rows = parse_legacy(full_text)
        tsy_rows     = []

    for row in reserve_rows:
        row["file"] = pdf_path.name
    for row in tsy_rows:
        row["file"] = pdf_path.name

    return reserve_rows, tsy_rows


def process_all():
    pdfs = sorted(RAW_DIR.glob("usdc_*.pdf"))
    if not pdfs:
        print("No PDFs found in {}. Run 00_fetch_usdc.py first.".format(RAW_DIR))
        return

    print("Processing {} PDFs...\n".format(len(pdfs)))
    all_reserves = []
    all_treasury = []

    for pdf in pdfs:
        print("  {}...".format(pdf.name))
        try:
            reserve_rows, tsy_rows = parse_report(pdf)
            all_reserves.extend(reserve_rows)
            all_treasury.extend(tsy_rows)
        except Exception as e:
            print("    Error: {}".format(e))

    # Save reserves summary
    df_reserves = pd.DataFrame(all_reserves)
    cols = ["file", "report_date", "format", "usdc_in_circulation", "fair_value_reserves",
            "treasury_securities", "repo", "fund_cash", "fund_settlement", "fund_total",
            "bank_cash", "other_settlement", "other_total", "total_reserves", "auditor"]
    df_reserves = df_reserves[[c for c in cols if c in df_reserves.columns]]
    reserves_path = OUT_DIR / "usdc_reserves.csv"
    df_reserves.to_csv(reserves_path, index=False)
    print("\nSaved {} reserve rows to {}".format(len(df_reserves), reserves_path))

    # Save treasury securities detail
    df_tsy = pd.DataFrame(all_treasury)
    if not df_tsy.empty:
        tsy_cols = ["file", "report_date", "cusip", "maturity_date", "fair_value"]
        df_tsy = df_tsy[[c for c in tsy_cols if c in df_tsy.columns]]
        tsy_path = OUT_DIR / "usdc_treasury_securities.csv"
        df_tsy.to_csv(tsy_path, index=False)
        print("Saved {} treasury security rows to {}".format(len(df_tsy), tsy_path))

    print(df_reserves.to_string())


if __name__ == "__main__":
    process_all()
