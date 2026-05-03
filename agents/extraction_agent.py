# -*- coding: utf-8 -*-
"""
Claude-powered PDF extraction agent.

Extracts structured reserve data from stablecoin attestation PDFs using Claude
as a fallback when regex parsing fails or for new/unknown PDF layouts.

Usage:
    python agents/extraction_agent.py <pdf_path> --coin usdc
    python agents/extraction_agent.py <pdf_path> --coin eurc
    python agents/extraction_agent.py <pdf_path> --coin unknown --desc "Tether USDT report"
"""

import json
import sys
import argparse
import pdfplumber
import anthropic
from pathlib import Path

PROJECT_ROOT = Path(__file__).parent.parent
MODEL = "claude-sonnet-4-6"

COIN_SCHEMAS = {
    "usdc": {
        "description": "USDC (USD Coin) reserve attestation report by Circle Internet Financial",
        "currency": "USD",
        "fields": {
            "report_date": "Report date string (e.g. 'January 26, 2026')",
            "usdc_in_circulation": "Total USDC tokens in circulation (numeric)",
            "fair_value_reserves": "Fair value of all assets held in USDC Reserve (USD numeric)",
            "treasury_securities": "Total US Treasury securities in Circle Reserve Fund (USD numeric)",
            "repo": "US Treasury Repurchase Agreements (USD numeric)",
            "fund_cash": "Cash held in Circle Reserve Fund (USD numeric)",
            "fund_total": "Total Circle Reserve Fund assets (USD numeric)",
            "bank_cash": "Cash held at regulated financial institutions (USD numeric)",
            "other_total": "Total Other USDC Reserve Assets (USD numeric)",
            "total_reserves": "Total USDC reserve assets (USD numeric)",
            "auditor": "Name of attesting audit firm (string)",
        },
    },
    "eurc": {
        "description": "EURC (Euro Coin) reserve attestation report by Circle Internet Financial",
        "currency": "EUR",
        "fields": {
            "report_date": "Report date string (e.g. 'June 10, 2024')",
            "eurc_in_circulation": "Total EURC tokens in circulation (numeric)",
            "fair_value_reserves": "Fair value of assets held in EURC Reserve (EUR numeric)",
            "cash_held": "Cash held at regulated European financial institutions (EUR numeric)",
            "settlement": "Timing and settlement differences (EUR numeric, can be negative)",
            "total_reserves": "Total EURC reserve assets (EUR numeric)",
            "auditor": "Name of attesting audit firm (string)",
        },
    },
    "pyusd": {
        "description": "PYUSD (PayPal USD) reserve attestation report by PayPal",
        "currency": "USD",
        "fields": {
            "report_date": "Report date string",
            "pyusd_in_circulation": "Total PYUSD tokens outstanding (numeric)",
            "us_treasury_bills": "US Treasury bills held (USD numeric)",
            "us_treasury_notes": "US Treasury notes held (USD numeric)",
            "repo": "Repurchase agreements (USD numeric)",
            "cash_deposits": "Cash and deposit accounts (USD numeric)",
            "money_market": "Money market fund holdings (USD numeric)",
            "total_reserves": "Total reserve assets (USD numeric)",
            "auditor": "Name of attesting audit firm (string)",
        },
    },
    "unknown": {
        "description": "Unknown stablecoin reserve attestation report",
        "currency": "USD",
        "fields": {
            "report_date": "Report date string",
            "tokens_in_circulation": "Total tokens outstanding (numeric)",
            "total_reserves": "Total reserve assets (numeric)",
            "reserve_breakdown": "JSON object with reserve asset categories and amounts",
            "auditor": "Name of attesting audit firm (string)",
            "issuer": "Name of the stablecoin issuer (string)",
            "coin_name": "Name of the stablecoin (string)",
        },
    },
}


def extract_pdf_text(pdf_path):
    """Extract text from all pages of a PDF using pdfplumber."""
    with pdfplumber.open(pdf_path) as pdf:
        pages = [page.extract_text() or "" for page in pdf.pages]
    return "\n".join(pages)


def extract_with_claude(pdf_path, coin_type="unknown", custom_desc=None):
    """
    Use Claude to extract structured reserve data from a PDF.

    Args:
        pdf_path: Path to the PDF file.
        coin_type: Key into COIN_SCHEMAS ('usdc', 'eurc', 'pyusd', 'unknown').
        custom_desc: Optional override for the coin description.

    Returns:
        List of dicts, one per report date found in the PDF.
    """
    pdf_path = Path(pdf_path)
    coin_type = coin_type.lower()

    if coin_type not in COIN_SCHEMAS:
        coin_type = "unknown"

    schema = COIN_SCHEMAS[coin_type]
    description = custom_desc or schema["description"]

    text = extract_pdf_text(pdf_path)
    if not text.strip():
        print(f"  Warning: No text extracted from {pdf_path.name} — may be image-based PDF")
        return []

    fields_desc = "\n".join(f"  - {k}: {v}" for k, v in schema["fields"].items())

    prompt = f"""You are extracting structured data from a {description}.

The PDF may contain data for one or two report dates. Extract all report dates present.

For each report date, return a JSON object with these fields:
{fields_desc}

Rules:
- Numeric values: plain numbers only, no $ signs or commas. Example: 45123456789
- Negative values as negative numbers. Example: -1234567
- Absent fields: null
- Return a JSON array of objects, one per report date
- Return only the JSON array, no other text

PDF TEXT:
---
{text[:18000]}
---"""

    client = anthropic.Anthropic()
    response = client.messages.create(
        model=MODEL,
        max_tokens=2000,
        messages=[{"role": "user", "content": prompt}],
    )

    raw = response.content[0].text.strip()
    if raw.startswith("```"):
        raw = raw.split("```")[1]
        if raw.startswith("json"):
            raw = raw[4:]
    raw = raw.strip()

    records = json.loads(raw)
    for rec in records:
        rec["file"] = pdf_path.name
        rec["extraction_method"] = "claude"

    return records


def main():
    parser = argparse.ArgumentParser(description="Extract stablecoin reserve data from a PDF using Claude")
    parser.add_argument("pdf", help="Path to the PDF file")
    parser.add_argument("--coin", default="unknown", choices=list(COIN_SCHEMAS.keys()),
                        help="Coin type (default: unknown)")
    parser.add_argument("--desc", help="Custom description of the report (overrides coin schema description)")
    args = parser.parse_args()

    pdf_path = Path(args.pdf)
    if not pdf_path.is_absolute():
        pdf_path = PROJECT_ROOT / pdf_path

    print(f"Extracting {args.coin.upper()} data from {pdf_path.name}...\n")
    records = extract_with_claude(pdf_path, args.coin, args.desc)

    if records:
        print(json.dumps(records, indent=2))
        print(f"\n{len(records)} record(s) extracted.")
    else:
        print("No records extracted.")


if __name__ == "__main__":
    main()
