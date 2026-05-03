"""
Parses USDtb attestation PDFs and writes:
  data/processed/usdtb/usdtb_reserves.csv     -- aggregate per report date
  data/processed/usdtb/usdtb_buidl_detail.csv -- BUIDL holdings by blockchain
"""

import re
import csv
from pathlib import Path
from datetime import datetime

import pdfplumber

ROOT    = Path(__file__).parent.parent.parent
RAW_DIR = ROOT / "data" / "raw" / "usdtb"
OUT_DIR = ROOT / "data" / "processed" / "usdtb"
OUT_DIR.mkdir(parents=True, exist_ok=True)


# ── helpers ───────────────────────────────────────────────────────────────────

def parse_usd(s):
    """'$1,825,531,453' -> 1825531453.0, or None."""
    if not s:
        return None
    s = str(s).strip().lstrip("$").replace(",", "")
    try:
        return float(s)
    except ValueError:
        return None


def find_date(text, pattern):
    """Return first datetime.date matching a strptime pattern in text, or None."""
    # Normalise whitespace
    text = re.sub(r"\s+", " ", text)
    m = re.search(pattern, text, re.IGNORECASE)
    if m:
        try:
            return datetime.strptime(m.group(0), pattern.replace(r"\b", "").strip()).date()
        except Exception:
            return None
    return None


MONTH_RE = (
    r"(?:January|February|March|April|May|June|July|August|September|"
    r"October|November|December)\s+\d{1,2},?\s+\d{4}"
)


def extract_date_from_text(text):
    text = re.sub(r"\s+", " ", text)
    m = re.search(MONTH_RE, text, re.IGNORECASE)
    if m:
        raw = m.group(0).replace(",", "")
        for fmt in ("%B %d %Y", "%B %d, %Y"):
            try:
                return datetime.strptime(raw, fmt).date()
            except ValueError:
                continue
    return None


# ── PDF parser ────────────────────────────────────────────────────────────────

def parse_pdf(path):
    """Return (reserves_row, buidl_rows) for one PDF."""
    fname = path.name

    with pdfplumber.open(path) as pdf:
        p1_text = pdf.pages[0].extract_text() or ""
        p2_text = pdf.pages[1].extract_text() or ""
        p2_tables = pdf.pages[1].extract_tables()
        p5_tables = pdf.pages[4].extract_tables()
        p6_tables = pdf.pages[5].extract_tables()
        p7_tables = pdf.pages[6].extract_tables() if len(pdf.pages) > 6 else []

    # ── report_date from page 1: "as of {Month} {Day}, {Year}"
    m = re.search(r"as of\s+" + MONTH_RE, p1_text, re.IGNORECASE)
    report_date = extract_date_from_text(m.group(0)) if m else None

    # ── attestation_date: last date in page 1 text
    all_dates = list(re.finditer(MONTH_RE, p1_text, re.IGNORECASE))
    attestation_date = extract_date_from_text(all_dates[-1].group(0)) if all_dates else None

    # ── tokens_in_circulation and total_reserves from page 2 table
    tokens_in_circulation = None
    total_reserves = None
    for table in (p2_tables or []):
        for row in table:
            if row and len(row) >= 2:
                label = str(row[0] or "").lower()
                val   = parse_usd(row[1])
                if "redeemable tokens outstanding" in label:
                    tokens_in_circulation = val
                elif "total reserve assets" in label:
                    total_reserves = val

    # ── cash and buidl from page 5 table (Schedule II)
    cash  = None
    buidl = None
    for table in (p5_tables or []):
        for row in table:
            if not row or len(row) < 2:
                continue
            label = str(row[0] or "").strip().lower()
            val   = parse_usd(row[-1])
            if label == "cash":
                cash = val
            elif label.startswith("buidl"):
                buidl = val

    # ── surplus/deficit from page 7 (Schedule III)
    surplus = None
    for table in (p7_tables or []):
        for row in table:
            if not row or len(row) < 2:
                continue
            label = str(row[0] or "").lower()
            if "surplus" in label or "deficit" in label:
                val = parse_usd(row[-1])
                if val is not None:
                    surplus = val

    reserves_row = {
        "file":                  fname,
        "report_date":           report_date,
        "attestation_date":      attestation_date,
        "auditor":               None,   # firm name is a logo, not extractable as text
        "tokens_in_circulation": tokens_in_circulation,
        "total_reserves":        total_reserves,
        "cash":                  cash,
        "buidl":                 buidl,
        "surplus_deficit":       surplus,
    }

    # ── BUIDL by blockchain from page 6
    buidl_rows = []
    for table in (p6_tables or []):
        for row in table:
            if not row or len(row) < 3:
                continue
            label = str(row[1] or "").strip()
            val   = parse_usd(row[2])
            if val is None or not label or label.lower() in ("blockchain", "balance", "total buidl"):
                continue
            # Strip footnote markers and trailing letters
            blockchain = re.sub(r"[ivxlcdm]+$", "", label, flags=re.IGNORECASE).strip()
            buidl_rows.append({
                "file":         fname,
                "report_date":  report_date,
                "blockchain":   blockchain,
                "fair_value":   val,
            })

    return reserves_row, buidl_rows


# ── main ──────────────────────────────────────────────────────────────────────

def write_csv(path, rows, fieldnames):
    with open(path, "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fieldnames, extrasaction="ignore")
        w.writeheader()
        w.writerows(rows)
    print(f"  Wrote {len(rows):,} rows -> {path.name}")


def main():
    pdfs = sorted(RAW_DIR.glob("usdtb_*.pdf"))
    if not pdfs:
        print(f"No PDFs found in {RAW_DIR}")
        return

    print(f"Processing {len(pdfs)} USDtb PDFs...\n")

    all_reserves = []
    all_buidl    = []

    for path in pdfs:
        print(f"  {path.name}")
        try:
            res_row, buidl_rows = parse_pdf(path)
            all_reserves.append(res_row)
            all_buidl.extend(buidl_rows)
        except Exception as e:
            print(f"    ERROR: {e}")

    write_csv(
        OUT_DIR / "usdtb_reserves.csv",
        all_reserves,
        ["file", "report_date", "attestation_date", "auditor",
         "tokens_in_circulation", "total_reserves", "cash", "buidl", "surplus_deficit"],
    )

    write_csv(
        OUT_DIR / "usdtb_buidl_detail.csv",
        all_buidl,
        ["file", "report_date", "blockchain", "fair_value"],
    )

    print("\nDone.")


if __name__ == "__main__":
    main()
