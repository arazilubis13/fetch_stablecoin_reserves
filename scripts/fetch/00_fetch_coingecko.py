"""
Downloads historical daily market data (price, market cap, volume) from CoinGecko
for stablecoins not yet in data/raw/coingecko/.

Output format matches existing files:
    snapped_at,price,market_cap,total_volume

CoinGecko coin IDs:
    eurc  - EURC (Circle Euro Coin)
    rlusd - Ripple USD

Usage:
    python scripts/fetch/00_fetch_coingecko.py
"""

import requests
import time
import csv
from datetime import datetime, timezone
from pathlib import Path

RAW_DIR = Path(__file__).parent.parent.parent / "data" / "raw" / "coingecko"
RAW_DIR.mkdir(parents=True, exist_ok=True)

COINS = [
    "euro-coin",   # EURC (Circle Euro Coin)
    "ripple-usd",  # RLUSD (Ripple USD)
]

BASE_URL = "https://api.coingecko.com/api/v3/coins/{id}/market_chart"


def fetch_coin(coin_id):
    out_path = RAW_DIR / f"{coin_id}-usd-max.csv"
    if out_path.exists():
        print(f"  Skipping {coin_id} (already exists)")
        return

    params = {"vs_currency": "usd", "days": "max", "interval": "daily"}
    r = requests.get(BASE_URL.format(id=coin_id), params=params, timeout=30)
    r.raise_for_status()
    data = r.json()

    prices = {ts: p for ts, p in data["prices"]}
    market_caps = {ts: m for ts, m in data["market_caps"]}
    volumes = {ts: v for ts, v in data["total_volumes"]}

    timestamps = sorted(prices.keys())

    with open(out_path, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["snapped_at", "price", "market_cap", "total_volume"])
        for ts in timestamps:
            dt = datetime.fromtimestamp(ts / 1000, tz=timezone.utc)
            snapped_at = dt.strftime("%Y-%m-%d %H:%M:%S UTC")
            writer.writerow([
                snapped_at,
                prices.get(ts, ""),
                market_caps.get(ts, ""),
                volumes.get(ts, ""),
            ])

    print(f"  Downloaded {coin_id}: {len(timestamps)} rows -> {out_path.name}")


def main():
    for coin_id in COINS:
        print(f"Fetching {coin_id}...")
        try:
            fetch_coin(coin_id)
        except Exception as e:
            print(f"  Failed {coin_id}: {e}")
        time.sleep(1.5)  # respect free tier rate limit

    print(f"\nDone. Files saved to {RAW_DIR}")


if __name__ == "__main__":
    main()
