"""
Downloads USDT (Tether) quarterly attestation reports from Tether / BDO.
Reports are saved to data/raw/usdt/ with clean filenames.

Note: Tether publishes quarterly (not monthly) reports via BDO Italia.
BDO attestations began in Q2 2022 (Tether switched from MHA Cayman Islands).

Usage:
    python scripts/fetch/00_fetch_usdt.py
"""

import requests
import time
from pathlib import Path

RAW_DIR = Path(__file__).parent.parent.parent / "data" / "raw" / "usdt"
RAW_DIR.mkdir(parents=True, exist_ok=True)

REPORTS = [
    # 2025
    ("2025-Q4", "https://assets.ctfassets.net/vyse88cgwfbl/20d2BoOAd28ZfkiQPYPjGN/4ed12f5939e1e06ee5aceccad4effbe4/ISAE_3000R_-_Opinion_Tether_International_Financial_Figure_31-12-2025.pdf"),
    ("2025-Q3", "https://tether.io/wp-content/uploads/2025/10/ISAE-3000R-Opinion-Tether-International-Financial-Figure-31-10-2025-RC187322025BD0440-Fascicolo.pdf"),
    ("2025-Q2", "https://assets.ctfassets.net/vyse88cgwfbl/2SGAAXnsb1wKByIzkhcbSx/9efa4682b3cd4c62d87a4c88ee729693/ISAE_3000R_-_Opinion_Tether_International_Financial_Figure_RC187322025BD0201.pdf"),
    ("2025-Q1", "https://assets.ctfassets.net/vyse88cgwfbl/1LdSmP3HBynDxm6wvkDSsL/c4bcbd1f6fc18a0e8b3a12444ac8ae97/ISAE_3000R_-_Opinion_Tether_International_Financial_Figures___Reserves_Report_31.03.2025_RC187322025BD0040.pdf"),
    # 2024
    ("2024-Q4", "https://assets.ctfassets.net/vyse88cgwfbl/6L2yLNnLltcCP6ZcTxJrll/aea0ec279fea08637445c8be57f63d87/ISAE_3000R_-_Opinion_on_Tether_Consolidated_Financials_Figures_31.12.2024.pdf"),
    ("2024-Q3", "https://assets.ctfassets.net/vyse88cgwfbl/5TKa7xwJVLIAnVBMWb7iTq/5688216da5194fce27f4a0f2e808a486/ISAE_3000R_-_Opinion_on_Tether_Consolidated_Financials_Figures_30.09.2024_.pdf"),
    ("2024-Q2", "https://assets.ctfassets.net/vyse88cgwfbl/6h4YWqZOXbwtBaPtYgICGy/d7462f312aa15b872f8474322ba90363/ISAE_3000R_-_Opinion_on_Consolidated_Financials_Figures_30.06.2024_RC134792024BD0209.pdf"),
    ("2024-Q1", "https://assets.ctfassets.net/vyse88cgwfbl/2JwUN6EeDvWi02CyuQd2nJ/d7b3b4c3800ec70abd7282cc79fa2973/ISAE_3000R_-_Opinion_on_Consolidated_Financials_Figures_and_Reserves_Report_31.03.2024_RC134792024BD0043.pdf"),
    # 2023
    ("2023-Q4", "https://assets.ctfassets.net/vyse88cgwfbl/7DZ8nVyr8zTaWhJqTIsMsH/b8e55bc151c9bb74adf20ff840e84088/ESO.03.01_Std_ISAE_3000R_Opinion_31-12-2023_BDO_Tether_CRR_RC134792023BD0684__1_.pdf"),
    ("2023-Q3", "https://assets.ctfassets.net/vyse88cgwfbl/36XORApdEYAq3AsH1FTXRT/9205ac62f2f57178c47ac5e2eca098c0/Std_ISAE_3000R_Opinion_30-09-2023_BDO_Tether_CRR_RC134792023BD0430.pdf"),
    ("2023-Q2", "https://assets.ctfassets.net/vyse88cgwfbl/63oJePOHqIvrcnXWMPZ1M0/4cfaf2e7cdf80c30b17fdc70faaf741f/ESO.03.01_Std_ISAE_3000R_Opinion_30-06-2023_BDO_Tether_CRR.pdf"),
    ("2023-Q1", "https://assets.ctfassets.net/vyse88cgwfbl/24G4DuQ0HE7h7EQE6vGy4J/8a8a170edf687ea07b3f86048af8b87b/ESO.03.01_Std_ISAE_3000R_Opinion_31-03-2023_BDO_Tether_CRR.pdf"),
    # 2022 (BDO began Q2 2022)
    ("2022-Q4", "https://assets.ctfassets.net/vyse88cgwfbl/53L8YRM4ZHCEeqlpKbc3Q8/2e6cbcd1593b3e5ea867718c5938d6c8/Std_ISAE_3000R_Opinion_BDO_31-12-2022_Tether_CRR.pdf"),
    ("2022-Q3", "https://assets.ctfassets.net/vyse88cgwfbl/1Xfu4398CIoMiuKjPhvnHM/6d1608c90bb775d2d432b7b24264da28/ESO.02_Std_ISAE_3000R_Opinion_30-9-2022_RC134792022BD0548.pdf"),
    ("2022-Q2", "https://assets.ctfassets.net/vyse88cgwfbl/2xJyKdUKicdRUWpC9buRWR/6fe2987698dbbf39b947af718d736ddb/Std_ISAE_3000R_Opinion_30-6-2022_RC134792022BD0303.pdf"),
]


def download_reports():
    session = requests.Session()
    session.headers.update({"User-Agent": "Mozilla/5.0"})

    for date_str, url in REPORTS:
        out_path = RAW_DIR / f"usdt_{date_str}.pdf"
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
    print(f"Downloading {len(REPORTS)} USDT attestation reports...\n")
    download_reports()
