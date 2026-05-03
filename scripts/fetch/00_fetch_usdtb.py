"""
Downloads USDtb (Anchorage Digital / Ethena Labs) reserve attestation reports.
Reports are saved to data/raw/usdtb/ with clean filenames.

Source: https://www.anchorage.com/platform/usdtb-reserve-attestations

Usage:
    python scripts/fetch/00_fetch_usdtb.py
"""

import requests
import time
from pathlib import Path

RAW_DIR = Path(__file__).parent.parent.parent / "data" / "raw" / "usdtb"
RAW_DIR.mkdir(parents=True, exist_ok=True)

REPORTS = [
    # 2025 format: MM.DD.YY%20USDtb%20Stablecoin%20Attestation%20Report.pdf
    ("2025-10", "https://learn.anchorage.com/10.31.25%20USDtb%20Stablecoin%20Attestation%20Report.pdf"),
    ("2025-11", "https://learn.anchorage.com/11.30.25%20USDtb%20Stablecoin%20Attestation%20Report.pdf"),
    ("2025-12", "https://learn.anchorage.com/12.31.25%20USDtb%20Stablecoin%20Attestation%20Report.pdf"),
    # 2026 format: MM.DD.YY_USDtb-Stablecoin-Attestation-Report.pdf
    ("2026-01", "https://learn.anchorage.com/01.31.26_USDtb-Stablecoin-Attestation-Report.pdf"),
    ("2026-02", "https://learn.anchorage.com/02.28.26_USDtb-Stablecoin-Attestation-Report.pdf"),
    ("2026-03", "https://learn.anchorage.com/03.31.26_USDtb-Stablecoin-Attestation-Report.pdf"),
]


def download_reports():
    session = requests.Session()
    session.headers.update({"User-Agent": "Mozilla/5.0"})

    for date_str, url in REPORTS:
        out_path = RAW_DIR / f"usdtb_{date_str}.pdf"
        if out_path.exists():
            print(f"  Skipping {date_str} (already downloaded)")
            continue
        try:
            r = session.get(url, timeout=30)
            r.raise_for_status()
            out_path.write_bytes(r.content)
            print(f"  Downloaded {date_str} ({len(r.content) / 1024:.0f} KB)")
            time.sleep(0.5)
        except Exception as e:
            print(f"  Failed {date_str}: {e}")

    print(f"\nDone. Files saved to {RAW_DIR}")


if __name__ == "__main__":
    print(f"Downloading {len(REPORTS)} USDtb attestation reports...\n")
    download_reports()
