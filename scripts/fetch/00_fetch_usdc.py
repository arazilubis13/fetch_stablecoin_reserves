"""
Downloads all USDC attestation reports from Circle's transparency page.
Reports are saved to data/raw/usdc/ with clean filenames.

Usage:
    python scripts/fetch/00_fetch_usdc.py
"""

import requests
import time
from pathlib import Path

RAW_DIR = Path(__file__).parent.parent.parent / "data" / "raw" / "usdc"
RAW_DIR.mkdir(parents=True, exist_ok=True)

REPORTS = [
    # 2026
    ("2026-02", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2026/2026%20USDC_Examination%20Report%20February%2026.pdf"),
    ("2026-01", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2026/2026%20USDC_Examination%20Report%20January%2026.pdf"),
    # 2025
    ("2025-01", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2025/2025-USDC_Examination-Report-January-25.pdf"),
    ("2025-02", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2025/2025%20USDC_Examination%20Report%20February%2025.pdf"),
    ("2025-03", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2025/2025%20USDC_Examination%20Report%20March%2025.pdf"),
    ("2025-04", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2025/2025-USDC_Examination-Report-April-25.pdf"),
    ("2025-05", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2025/2025%20USDC_Examination%20Report%20May%2025.pdf"),
    ("2025-06", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2025/2025%20USDC_Examination%20Report%20June%2025.pdf"),
    ("2025-07", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2025/2025%20USDC_Examination%20Report%20July%2025.pdf"),
    ("2025-08", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2025/2025%20USDC_Examination%20Report%20August%2025.pdf"),
    ("2025-09", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2025/2025%20USDC_Examination%20Report%20September%2025.pdf"),
    ("2025-10", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2025/2025%20USDC_Examination%20Report%20October%2025.pdf"),
    ("2025-11", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2025/2025%20USDC_Examination%20Report%20November%2025.pdf"),
    ("2025-12", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2025/2025%20USDC_Examination%20Report%20December%2025.pdf"),
    # 2024
    ("2024-01", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2024/2024%20USDC_Examination%20Report%20January%202024.pdf"),
    ("2024-02", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2024/2024%20USDC_Examination%20Report%20February%202024.pdf"),
    ("2024-03", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2024/2024%20USDC_Examination%20Report%20March%202024.pdf"),
    ("2024-04", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2024/2024%20USDC_Examination%20Report%20April%202024.pdf"),
    ("2024-05", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2024/2024%20USDC_Examination%20Report%20May%202024.pdf"),
    ("2024-06", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2024/2024%20USDC_Examination%20Report%20June%202024.pdf"),
    ("2024-07", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2024/2024%20USDC_Examination%20Report%20July%202024.pdf"),
    ("2024-08", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2024/2024%20USDC_Examination%20Report%20August%202024.pdf"),
    ("2024-09", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2024/2024%20USDC_Examination%20Report%20September%202024.pdf"),
    ("2024-10", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2024/2024%20USDC_Examination%20Report%20October%202024%20%283%29.pdf"),
    ("2024-11", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2024/2024%20USDC_Examination%20Report%20November%202024.pdf"),
    ("2024-12", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2024/2024%20USDC_Examination%20Report%20December%2024.pdf"),
    # 2023
    ("2023-01", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2023%20USDC_Circle%20Examination%20Report%20January%202023.pdf"),
    ("2023-02", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2023%20USDC_Circle%20Examination%20Report%20February%202023.pdf"),
    ("2023-03", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2023/2023%20USDC_Circle%20Examination%20Report%20March%202023.pdf"),
    ("2023-04", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2023/2023%20USDC_Circle%20Examination%20Report%20April%202023.pdf"),
    ("2023-05", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2023/2023%20USDC_Circle%20Examination%20Report%20May%202023.pdf"),
    ("2023-06", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2023/2023%20USDC_Circle%20Examination%20Report%20June%202023.pdf"),
    ("2023-07", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2023/2023%20USDC_Circle%20Examination%20Report%20July%202023.pdf"),
    ("2023-08", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2023/2023%20USDC_Circle%20Examination%20Report%20August%202023.pdf"),
    ("2023-09", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2023/2023%20USDC_Circle%20Examination%20Report%20September%202023.pdf"),
    ("2023-10", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2023/2023%20USDC_Circle%20Examination%20Report%20October%202023.pdf"),
    ("2023-11", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2023/2023%20USDC_Circle%20Examination%20Report%20November%202023.pdf"),
    ("2023-12", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2023/2023%20USDC_Examination%20Report%20December%202023.pdf"),
    # 2022
    ("2022-01", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2022/2022%20USDC%20Circle%20Grant%20Thornton%20Report%20January.pdf"),
    ("2022-02", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2022/2022%20USDC%20Circle%20Grant%20Thornton%20Report%20February.pdf"),
    ("2022-03", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2022/2022%20USDC%20Circle%20Grant%20Thornton%20Report%20March.pdf"),
    ("2022-04", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2022/2022%20USDC%20Circle%20Grant%20Thornton%20Report%20April.pdf"),
    ("2022-05", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2022/2022%20USDC%20Circle%20Grant%20Thornton%20Report%20May.pdf"),
    ("2022-06", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2022/2022%20USDC%20Circle%20Grant%20Thornton%20Report%20June.pdf"),
    ("2022-07", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2022/2022%20USDC%20Circle%20Grant%20Thornton%20Report%20July.pdf"),
    ("2022-08", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2022/2022%20USDC%20Circle%20Grant%20Thornton%20Report%20August.pdf"),
    ("2022-09", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2022/2022%20USDC%20Circle%20Grant%20Thornton%20Report%20September.pdf"),
    ("2022-10", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2022/2022%20USDC%20Circle%20Grant%20Thornton%20Report%20October.pdf"),
    ("2022-11", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2022/2022%20USDC%20Circle%20Grant%20Thornton%20Report%20November.pdf"),
    ("2022-12", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2022/2022%20USDC%20Circle%20Grant%20Thornton%20Report%20December.pdf"),
    # 2021
    ("2021-01", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2021/2021%20USDC%20Circle%20Grant%20Thornton%20Report%20January.pdf"),
    ("2021-02", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2021/2021%20USDC%20Circle%20Grant%20Thornton%20Report%20February.pdf"),
    ("2021-03", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2021/2021%20USDC%20Circle%20Grant%20Thornton%20Report%20March.pdf"),
    ("2021-04", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2021/2021%20USDC%20Circle%20Grant%20Thornton%20Report%20April.pdf"),
    ("2021-05", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2021/2021%20USDC%20Circle%20Grant%20Thornton%20Report%20May.pdf"),
    ("2021-06", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2021/2021%20USDC%20Circle%20Grant%20Thornton%20Report%20June.pdf"),
    ("2021-07", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2021/2021%20USDC%20Circle%20Grant%20Thornton%20Report%20July.pdf"),
    ("2021-08", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2021/2021%20USDC%20Circle%20Grant%20Thornton%20Report%20August.pdf"),
    ("2021-09", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2021/2021%20USDC%20Circle%20Grant%20Thornton%20Report%20September.pdf"),
    ("2021-10", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2021/2021%20USDC%20Circle%20Grant%20Thornton%20Report%20October.pdf"),
    ("2021-11", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2021/2021%20USDC%20Circle%20Grant%20Thornton%20Report%20November.pdf"),
    ("2021-12", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2021/2021%20USDC%20Circle%20Grant%20Thornton%20Report%20December.pdf"),
    # 2020
    ("2020-01", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2020/2020%20USDC%20Circle%20Grant%20Thornton%20Report%20January.pdf"),
    ("2020-02", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2020/2020%20USDC%20Circle%20Grant%20Thornton%20Report%20February.pdf"),
    ("2020-03", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2020/2020%20USDC%20Circle%20Grant%20Thornton%20Report%20March.pdf"),
    ("2020-04", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2020/2020%20USDC%20Circle%20Grant%20Thornton%20Report%20April.pdf"),
    ("2020-05", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2020/2020%20USDC%20Circle%20Grant%20Thornton%20Report%20May.pdf"),
    ("2020-06", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2020/2020%20USDC%20Circle%20Grant%20Thornton%20Report%20June.pdf"),
    ("2020-07", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2020/2020%20USDC%20Circle%20Grant%20Thornton%20Report%20July.pdf"),
    ("2020-08", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2020/2020%20USDC%20Circle%20Grant%20Thornton%20Report%20August.pdf"),
    ("2020-09", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2020/2020%20USDC%20Circle%20Grant%20Thornton%20Report%20September.pdf"),
    ("2020-10", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2020/2020%20USDC%20Circle%20Grant%20Thornton%20Report%20October.pdf"),
    ("2020-11", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2020/2020%20USDC%20Circle%20Grant%20Thornton%20Report%20November.pdf"),
    ("2020-12", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2020/2020%20USDC%20Circle%20Grant%20Thornton%20Report%20December.pdf"),
    # 2019
    ("2019-01", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2019/2019%20USDC%20Circle%20Grant%20Thornton%20Report%20January.pdf"),
    ("2019-02", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2019/2019%20USDC%20Circle%20Grant%20Thornton%20Report%20February.pdf"),
    ("2019-03", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2019/2019%20USDC%20Circle%20Grant%20Thornton%20Report%20March.pdf"),
    ("2019-04", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2019/2019%20USDC%20Circle%20Grant%20Thornton%20Report%20April.pdf"),
    ("2019-05", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2019/2019%20USDC%20Circle%20Grant%20Thornton%20Report%20May.pdf"),
    ("2019-06", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2019/2019%20USDC%20Circle%20Grant%20Thornton%20Report%20June.pdf"),
    ("2019-07", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2019/2019%20USDC%20Circle%20Grant%20Thornton%20Report%20July.pdf"),
    ("2019-08", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2019/2019%20USDC%20Circle%20Grant%20Thornton%20Report%20August.pdf"),
    ("2019-09", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2019/2019%20USDC%20Circle%20Grant%20Thornton%20Report%20September.pdf"),
    ("2019-10", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2019/2019%20USDC%20Circle%20Grant%20Thornton%20Report%20October.pdf"),
    ("2019-11", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2019/2019%20USDC%20Circle%20Grant%20Thornton%20Report%20November.pdf"),
    ("2019-12", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2019/2019%20USDC%20Circle%20Grant%20Thornton%20Report%20December.pdf"),
    # 2018
    ("2018-10", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2018/2018%20USDC%20Circle%20Grant%20Thornton%20Report%20October.pdf"),
    ("2018-11", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2018/2018%20USDC%20Circle%20Grant%20Thornton%20Report%20November.pdf"),
    ("2018-12", "https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/USDCAttestationReports/2018/2018%20USDC%20Circle%20Grant%20Thornton%20Report%20December.pdf"),
]


def download_reports():
    session = requests.Session()
    session.headers.update({"User-Agent": "Mozilla/5.0"})

    for date_str, url in REPORTS:
        out_path = RAW_DIR / "usdc_{}.pdf".format(date_str)
        if out_path.exists():
            print("  Skipping {} (already downloaded)".format(date_str))
            continue
        try:
            r = session.get(url, timeout=30)
            r.raise_for_status()
            out_path.write_bytes(r.content)
            print("  Downloaded {} ({:.0f} KB)".format(date_str, len(r.content) / 1024))
            time.sleep(0.5)
        except Exception as e:
            print("  Failed {}: {}".format(date_str, e))

    print("\nDone. Files saved to {}".format(RAW_DIR))


if __name__ == "__main__":
    print("Downloading {} USDC attestation reports...\n".format(len(REPORTS)))
    download_reports()
