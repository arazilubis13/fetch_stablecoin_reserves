"""
Downloads FDUSD (First Digital USD) monthly reserve attestation reports.
Reports are saved to data/raw/fdusd/ with clean filenames.

Source: https://www.firstdigitallabs.com/transparency

Notes:
- From Jul 2025 onwards, two documents per month are published:
    _reserves  = Reserve Accounts Report (signed by accountant)
    _isae3000  = ISAE3000 Attestation Report
- Apr-Jun 2025: Two auditors published simultaneously (IAPA International + Prism)
    _iapa = IAPA International report
    _prism = Prism report
- Earlier months: single attestation report (no suffix)

Usage:
    python scripts/fetch/00_fetch_fdusd.py
"""

import requests
import time
from pathlib import Path

RAW_DIR = Path(__file__).parent.parent.parent / "data" / "raw" / "fdusd"
RAW_DIR.mkdir(parents=True, exist_ok=True)

BASE = "https://cdn.prod.website-files.com/675ab99bf1f7ea944d49a55b/"

REPORTS = [
    # 2026
    ("2026-02_reserves",  "https://cdn.prod.website-files.com/675ab99bf1f7ea944d49a55b/69b8bb473f0157074ffcd838_FDUSD_Reserve_accounts_Report__FEB_2026_(signed_by_Accountant).pdf"),
    ("2026-02_isae3000",  "https://cdn.prod.website-files.com/675ab99bf1f7ea944d49a55b/69b8bb692133e7d22020f80a_FD121_(BVI)_-_ISAE3000_Attestation_Report_on_Reserves_Account_(Feb_2026)_(FINAL).pdf"),
    ("2026-01_reserves",  BASE + "6996468bc78e80ae2007998e_FDUSD%20Reserve%20accounts%20Report_%20JAN%202026%20(signed%20by%20Accountant).pdf"),
    ("2026-01_isae3000",  BASE + "69964656b7cbfa2234e0a6e2_ISAE3000%20-%20Attestation%20Report%20on%20Reserves%20Account%20(Jan%202026)%20(clean).pdf"),
    # 2025
    ("2025-12_reserves",  BASE + "6969d920f0bbd106f0132d53_FDUSD%20Reserve%20accounts%20Report_%20DEC%202025%20(signed%20by%20Accountant).pdf"),
    ("2025-12_isae3000",  BASE + "6969d8f3152133800af43919_ISAE3000%20-%20Attestation%20Report%20on%20Reserves%20Account%20(Dec%202025).pdf"),
    ("2025-11_reserves",  BASE + "6940a4d6221cf05739ad4184_FDUSD%20Reserve%20accounts%20Report_%20NOV%202025%20(signed).pdf"),
    ("2025-11_isae3000",  BASE + "6940a51aaaea4f2e643857ba_ISAE3000%20-%20Attestation%20Report%20on%20Reserves%20Account%20(Nov%202025)%20(signed).pdf"),
    ("2025-10_reserves",  BASE + "691ae730c0002ec5197b3cf0_FDUSD%20Reserve%20accounts%20Report_%20OCT%202025%20(signed%20by%20Accountant).pdf"),
    ("2025-10_isae3000",  BASE + "691ae08e4d207889dd082d2a_ISAE3000%20-%20Attestation%20Report%20on%20Reserves%20Account%20(Oct%202025)%20Final.pdf"),
    ("2025-09_reserves",  BASE + "68f09efc81c2a516125db704_FDUSD_Reserve_accounts_Report__SEP_2025_(final)_(FD_20251010).pdf"),
    ("2025-09_isae3000",  BASE + "68f09f623c0571b23acecbcc_ISAE3000_-_Attestion_Report_on_Reserves_Account_(Sept_2025)_Final.pdf"),
    ("2025-08_reserves",  BASE + "68c7c387b95895d1940d8d1e_FDUSD%20Reserve%20accounts%20Report_%20AUG%202025_signed%20(1).pdf"),
    ("2025-08_isae3000",  BASE + "68c7c365d6693ad3317ac31e_ISAE3000%20-%20Attestion%20Report%20on%20Reserves%20Account%20(Aug%202025)%20Final%20(1).pdf"),
    ("2025-07_reserves",  BASE + "68a544a4e036b565d7d99085_Attestation%20report_Jul%202025.pdf"),
    ("2025-07_isae3000",  BASE + "68a5446b8f42abc2cb241610_ISAE3000%20-%20Attestation%20Report%20on%20Reserves%20Account%20(July%202025)%2020250813.pdf"),
    ("2025-06_iapa",      BASE + "6875c5d167957aed6df7a2b1_IAPA%20International%20-%20Jun%202025.pdf"),
    ("2025-06_prism",     BASE + "6875c5598a7e1f4d0de4cb12_Prism%20-%20June%202025.pdf"),
    ("2025-05_iapa",      BASE + "684bda74a554a6a4f740d4d5_%5BMetadata%20Removed%5D%20IAPA%20International%20-%20May%202025%20Attestation%20Report%20(1).pdf"),
    ("2025-05_prism",     BASE + "684bd9c00ae1c7edf8c317d5_Prism%20-%20May%202025%20Attestation%20Report%20(1).pdf"),
    ("2025-04_reserves",  BASE + "682c39fa3650a5ebc24a96eb_%5BMetadata%20Removed%5D%20April%202025%20Report%20-%20Ko%20Chi%20Kwong%20(1).pdf"),
    ("2025-04_isae3000",  BASE + "682c3839248a085370ccec8b_ISAE3000%20-%20Attestion%20Report%20on%20Reserves%20Account%20Report%20(April%202025)%20-%20Final%20exe%20(1).pdf"),
    ("2025-03_a",         BASE + "67fc74cf2e666b43699b10c1_fdusd_attestation_march_002_compressed.pdf"),
    ("2025-03_b",         BASE + "67fc74289e1ee391a768efd1_fdusd_attestation_march_001.pdf"),
    ("2025-02",           BASE + "67e12b28b3f2b0d908a162bc_fdusd-attestation-2025-02-28-67dcd1b781dea.pdf"),
    ("2025-01",           BASE + "67d977181b6101b6976d28fb_fdusd-attestation-2025-01-31.pdf"),
    # 2024
    ("2024-12",           BASE + "67ace35720f0484afb6a48ec_fdusd-attestation-2024-12-31.pdf"),
    ("2024-11",           BASE + "67728a7b9dd5f938607e2ce1_fdusd-attestation-2024-11-30.pdf"),
    ("2024-10",           BASE + "67728abd507d090f996453b8_fdusd-attestation-2024-10-31.pdf"),
    ("2024-09",           BASE + "67728b6bb68d78a962bbcceb_fdusd-attestation-2024-09-30.pdf"),
    ("2024-08",           BASE + "67dcce6b6d997f5e063ba5fe_fdusd-attestation-2024-08-31-66e4176aba810.pdf"),
    ("2024-07",           BASE + "67dcce96f06695539aea4dd9_fdusd-attestation-2024-07-31-66b98fc8458bb.pdf"),
    ("2024-06",           BASE + "67dccecd84c0ed3ff7386106_fdusd-attestation-2024-06-30-6690cfe7ef630.pdf"),
    ("2024-05",           BASE + "67dccee86e60ec98bd3fa23d_fdusd-attestation-2024-05-31-667572d10bd5d.pdf"),
    ("2024-04",           BASE + "67dccf011a0a23a836b6428d_fdusd-attestation-2024-04-30-6646ec140a1a3.pdf"),
    ("2024-03",           BASE + "67dccf25df1f554ca835c0ca_fdusd-attestation-2024-03-31-6621039b5dbae.pdf"),
    ("2024-02",           BASE + "67dccf447ef23b7014715b39_fdusd-attestation-2024-02-29-6603c9176cc2c.pdf"),
    ("2024-01",           BASE + "67dccf5b6cff0a46a5734940_fdusd-attestation-2024-01-31-65d2b6173dfb9.pdf"),
    # 2023
    ("2023-12",           BASE + "67dccd6c5ea595bc4b593068_fdusd-attestation-2023-12-31-65a624e163e2a.pdf"),
    ("2023-11",           BASE + "67dccd557f1809ce98406338_fdusd-attestation-2023-11-30-65836439382b5.pdf"),
    ("2023-10",           BASE + "67dcc964034f0ef337e3f190_fdusd-attestation-2023-10-31-655ee573504e9.pdf"),
    ("2023-09",           BASE + "67dcc8cff20a97dbc6b713cb_fdusd-attestation-2023-09-30-653a2e915e0d3.pdf"),
    ("2023-08",           BASE + "67dcc89b0ce1a50342f79498_fdusd-attestation-2023-08-31-651ea94955c59.pdf"),
    ("2023-07",           BASE + "67dcc869034f0ef337e2ffcb_fdusd-attestation-2023-07-31-64dd74a323e70.pdf"),
    ("2023-06",           BASE + "67dcc84a19805bab8b7e9550_fdusd-attestation-2023-06-30-64c7adb560a31.pdf"),
]


def download_reports():
    session = requests.Session()
    session.headers.update({"User-Agent": "Mozilla/5.0"})

    for date_str, url in REPORTS:
        out_path = RAW_DIR / f"fdusd_{date_str}.pdf"
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
    print(f"Downloading {len(REPORTS)} FDUSD attestation reports...\n")
    download_reports()
