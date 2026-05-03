"""
Downloads all EURC/EUROC attestation reports from Circle's transparency page.
Reports are saved to data/raw/eurc/ with clean filenames.

Usage:
    python scripts/fetch/00_fetch_eurc.py
"""

import requests
import time
from pathlib import Path

RAW_DIR = Path(__file__).parent.parent.parent / "data" / "raw" / "eurc"
RAW_DIR.mkdir(parents=True, exist_ok=True)

REPORTS = [
    # 2026
    ("2026-02", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/EURC%20Attestations/2026%20EURC_Examination%20Report%20February%2026.pdf"),
    ("2026-01", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/EURC%20Attestations/2026%20EURC_Examination%20Report%20January%2026.pdf"),
    # 2025
    ("2025-01", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/EURC%20Attestations/2025-EURC_Examination-Report-January-25.pdf"),
    ("2025-02", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/EURC%20Attestations/2025%20EURC_Examination%20Report%20February%2025.pdf"),
    ("2025-03", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/EURC%20Attestations/2025%20EURC_Examination%20Report%20March%2025.pdf"),
    ("2025-04", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/EURC%20Attestations/2025-EURC_Examination-Report-April-25.pdf"),
    ("2025-05", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/EURC%20Attestations/2025%20EURC_Examination%20Report%20May%2025.pdf"),
    ("2025-06", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/EURC%20Attestations/2025%20EURC_Examination%20Report%20June%2025.pdf"),
    ("2025-07", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/EURC%20Attestations/2025%20EURC_Examination%20Report%20July%2025.pdf"),
    ("2025-08", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/EURC%20Attestations/2025%20EURC_Examination%20Report%20August%2025.pdf"),
    ("2025-09", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/EURC%20Attestations/2025%20EURC_Examination%20Report%20September%2025.pdf"),
    ("2025-10", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/EURC%20Attestations/2025%20EURC_Examination%20Report%20October%2025.pdf"),
    ("2025-11", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/EURC%20Attestations/2025%20EURC_Examination%20Report%20November%2025.pdf"),
    ("2025-12", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/EURC%20Attestations/2025%20EURC_Examination%20Report%20December%2025.pdf"),
    # 2024
    ("2024-01", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/EURC%20Attestations/2024%20EURC_Examination%20Report%20January%202024.pdf"),
    ("2024-02", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/EURC%20Attestations/2024%20EURC_Examination%20Report%20February%202024.pdf"),
    ("2024-03", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/EURC%20Attestations/2024%20EURC_Examination%20Report%20March%202024.pdf"),
    ("2024-04", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/EURC%20Attestations/2024%20EURC_Examination%20Report%20April%202024.pdf"),
    ("2024-05", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/EURC%20Attestations/2024%20EURC_Examination%20Report%20May%202024.pdf"),
    ("2024-06", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/EURC%20Attestations/2024%20EURC_Examination%20Report%20June%202024.pdf"),
    ("2024-07", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/EURC%20Attestations/2024%20EURC_Examination%20Report%20July%202024.pdf"),
    ("2024-08", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/EURC%20Attestations/2024%20EURC_Examination%20Report%20August%202024.pdf"),
    ("2024-09", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/EURC%20Attestations/2024%20EURC_Examination%20Report%20September%202024%20.pdf"),
    ("2024-10", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/EURC%20Attestations/2024%20EURC_Examination%20Report%20October%202024%20%20%282%29.pdf"),
    ("2024-11", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/EURC%20Attestations/2024%20EURC_Examination%20Report%20November%202024.pdf"),
    ("2024-12", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/EURC%20Attestations/2024%20EURC_Examination%20Report%20December%2024.pdf"),
    # 2023
    ("2023-01", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/Euro%20Coin%20Attestations/2023%20EUROC_Circle%20Examination%20Report%20January%202023.pdf"),
    ("2023-02", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/Euro%20Coin%20Attestations/2023%20EUROC_Circle%20Examination%20Report%20February%202023.pdf"),
    ("2023-03", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/Euro%20Coin%20Attestations/2023%20EUROC_Circle%20Examination%20Report%20March%202023.pdf"),
    ("2023-04", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/Euro%20Coin%20Attestations/2023%20EUROC_Circle%20Examination%20Report%20April%202023.pdf"),
    ("2023-05", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/Euro%20Coin%20Attestations/2023%20EUROC_Circle%20Examination%20Report%20May%202023.pdf"),
    ("2023-06", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/Euro%20Coin%20Attestations/2023%20EUROC_Circle%20Examination%20Report%20June%202023.pdf"),
    ("2023-07", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/Euro%20Coin%20Attestations/2023%20EUROC_Circle%20Examination%20Report%20July%202023.pdf"),
    ("2023-08", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/Euro%20Coin%20Attestations/2023%20EUROC_Circle%20Examination%20Report%20August%202023.pdf"),
    ("2023-09", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/Euro%20Coin%20Attestations/2023%20EURC_Circle%20Examination%20Report%20September%202023.pdf"),
    ("2023-10", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/Euro%20Coin%20Attestations/2023%20EURC_Circle%20Examination%20Report%20October%202023.pdf"),
    ("2023-11", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/Euro%20Coin%20Attestations/2023%20EURC_Circle%20Examination%20Report%20November%202023.pdf"),
    ("2023-12", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/Euro%20Coin%20Attestations/2023%20EURC_Examination%20Report%20December%202023.pdf"),
    # 2022
    ("2022-06", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/Euro%20Coin%20Attestations/EUROC%202022_Circle%20Examination%20Report%20June%202022.pdf"),
    ("2022-07", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/EUROC%202022_Circle%20Examination%20Report%20July%202022.pdf"),
    ("2022-08", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/Euro%20Coin%20Attestations/EUROC%202022_Circle%20Examination%20Report%20August%202022.pdf"),
    ("2022-09", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/EUROC%202022_Circle%20Examination%20Report%20Sept%202022.pdf"),
    ("2022-10", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/Euro%20Coin%20Attestations/EUROC%202022_Circle%20Examination%20Report%20October%202022.pdf"),
    ("2022-11", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/Euro%20Coin%20Attestations/EUROC%202022_Circle%20Examination%20Report%20November%202022.pdf"),
    ("2022-12", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2022%20EUROC_Circle%20Examination%20Report%20December%202022.pdf"),
]


def download_reports():
    session = requests.Session()
    session.headers.update({"User-Agent": "Mozilla/5.0"})

    for date_str, url in REPORTS:
        out_path = RAW_DIR / f"eurc_{date_str}.pdf"
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
    print(f"Downloading {len(REPORTS)} EURC attestation reports...\n")
    download_reports()
