"""
Downloads RLUSD (Ripple USD) monthly reserve attestation reports.
Reports are saved to data/raw/rlusd/ with clean filenames.

Attestations are conducted by an independent CPA and published monthly
via Ripple's transparency page: https://ripple.com/solutions/stablecoin/transparency/

Usage:
    python scripts/fetch/00_fetch_rlusd.py
"""

import requests
import time
from pathlib import Path

RAW_DIR = Path(__file__).parent.parent.parent / "data" / "raw" / "rlusd"
RAW_DIR.mkdir(parents=True, exist_ok=True)

REPORTS = [
    # 2026
    ("2026-02", "https://cdn.sanity.io/files/ior4a5y3/production/775b1aee336cea2bc165585d47e7c0a6361e979b.pdf/RLUSD_Attestation_Report_-_Feb'26 - FINAL.pdf"),
    ("2026-01", "https://cdn.sanity.io/files/ior4a5y3/production/ec52283a0d9ed86b40381199bcead6cd1a1a53fe.pdf/RLUSD_Attestation_Report_January-26 - FINAL.pdf"),
    # 2025
    ("2025-12", "https://cdn.sanity.io/files/ior4a5y3/production/0b1816ad7f5ea17799bf6fe6e9ddbfd66634296d.pdf/RLUSD_Attestation_Report - Dec'25 - FINAL.pdf"),
    ("2025-11", "https://cdn.sanity.io/files/ior4a5y3/production/46af4e8ec2539bdddfdad2d44b6b071ce876db75.pdf/RLUSD_Attestation_Report-Nov'25 Final.pdf"),
    ("2025-10", "https://cdn.sanity.io/files/ior4a5y3/production/dfb0d9ece8d5aae5dc46166b70f545ba75077a62.pdf/RLUSD_Attestation_Report-Oct-25_Final.pdf"),
    ("2025-09", "https://cdn.sanity.io/files/ior4a5y3/production/ef1ecf93c88d93a25c3177c55b15497cec891bf2.pdf/RLUSD_Attestation_Report_-_Sept-25_Final.pdf"),
    ("2025-08", "https://cdn.sanity.io/files/ior4a5y3/production/1aa06b66a8cfc77beace0a58f8bea1ab8d8d5eed.pdf/Standard Custody & Trust Company, LLC - RLUSD Reserves Report August 2025.pdf"),
    ("2025-07", "https://cdn.sanity.io/files/ior4a5y3/production/e8c677d6deb42e2a5ddf3b29cf2e28688c5f7f7d.pdf/Standard Custody & Trust Company, LLC - RLUSD Reserves Report July 2025.pdf"),
    ("2025-06", "https://cdn.sanity.io/files/ior4a5y3/production/33ba3e71f1bd6c0dbb6601216fc05736eddf8879.pdf/Standard Custody & Trust Company, LLC - RLUSD Reserves Report June 2025.pdf"),
    ("2025-05", "https://cdn.sanity.io/files/ior4a5y3/production/e5689456575be999b570160ec235451f3a77b221.pdf/Standard Custody and Trust LLC May 2025 RLUSD Reserves Report - Issued.pdf"),
    ("2025-04", "https://cdn.sanity.io/files/ior4a5y3/production/6ddcbdc1bfe7e22862861e9ed0917e6129477db7.pdf/Standard Custody and Trust LLC April 2025 RLUSD Reserve Report.pdf"),
    ("2025-03", "https://cdn.sanity.io/files/ior4a5y3/production/6540ba1ada47ab1dc724549716b8cb153f5fa472.pdf/Standard Custody and Trust LLC March 2025 RLUSD Reserves Report - Issued.pdf"),
    ("2025-02", "https://cdn.sanity.io/files/ior4a5y3/production/8ce7a3b23af7d5bb4663c050f742d984e3c48d15.pdf/Standard Custody & Trust Company, LLC February 2025 RLUSD Reserves Report - Issued.pdf"),
    ("2025-01", "https://cdn.sanity.io/files/ior4a5y3/production/f4bda99b02a9004227e1af95015940352b66dee7.pdf/Standard Custody & Trust Company, LLC January 2025 RLUSD Reserves Report - Issued.pdf"),
    # 2024
    ("2024-12", "https://cdn.sanity.io/files/ior4a5y3/production/d152131c3d5ad6ff6f3555f11d6fa9699044be95.pdf/RLUSD_Reserves Report_Dec 2024_Issued.pdf"),
]


def download_reports():
    session = requests.Session()
    session.headers.update({"User-Agent": "Mozilla/5.0"})

    for date_str, url in REPORTS:
        out_path = RAW_DIR / f"rlusd_{date_str}.pdf"
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
    print(f"Downloading {len(REPORTS)} RLUSD attestation reports...\n")
    download_reports()
