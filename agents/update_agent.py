# -*- coding: utf-8 -*-
"""
Monthly update agent: runs the full fetch + process pipeline and summarizes changes.

Usage:
    python agents/update_agent.py              # full update (fetch + process)
    python agents/update_agent.py --no-fetch   # skip downloading PDFs
    python agents/update_agent.py --no-process # skip processing PDFs
    python agents/update_agent.py --coin usdc  # update only USDC
"""

import subprocess
import sys
import argparse
import pandas as pd
import anthropic
from pathlib import Path
from datetime import datetime

PYTHON = r"C:\Users\X1 Carbon i7-7500\anaconda3\python.exe"
PROJECT_ROOT = Path(__file__).parent.parent
MODEL = "claude-sonnet-4-6"

SCRIPTS = {
    "usdc": {
        "fetch":   PROJECT_ROOT / "scripts" / "fetch"   / "00_fetch_usdc.py",
        "process": PROJECT_ROOT / "scripts" / "process" / "00_process_usdc.py",
    },
    "eurc": {
        "fetch":   PROJECT_ROOT / "scripts" / "fetch"   / "00_fetch_eurc.py",
        "process": PROJECT_ROOT / "scripts" / "process" / "00_process_eurc.py",
    },
}

PROCESSED = {
    "usdc": PROJECT_ROOT / "data" / "processed" / "usdc" / "usdc_reserves.csv",
    "eurc": PROJECT_ROOT / "data" / "processed" / "eurc" / "eurc_reserves.csv",
}


def run_script(script_path):
    """Run a Python script, stream output, and return (success, full_output)."""
    result = subprocess.run(
        [PYTHON, str(script_path)],
        capture_output=True,
        text=True,
        cwd=str(PROJECT_ROOT),
    )
    return result.returncode == 0, result.stdout + result.stderr


def csv_snapshot(csv_path):
    """Return (row_count, latest_date) for a processed CSV."""
    if not csv_path.exists():
        return None, None
    df = pd.read_csv(csv_path)
    n = len(df)
    date_col = "report_date" if "report_date" in df.columns else None
    latest = df[date_col].dropna().iloc[-1] if date_col and n > 0 else None
    return n, latest


def summarize_with_claude(change_log):
    """Ask Claude to write a brief update memo from the change log."""
    client = anthropic.Anthropic()
    prompt = (
        "You are summarizing a stablecoin reserve data pipeline update. "
        "Write a concise 2-4 sentence memo describing what changed, covering "
        "new data coverage and any errors. Be factual and direct.\n\n"
        f"Change log:\n{change_log}"
    )
    response = client.messages.create(
        model=MODEL,
        max_tokens=300,
        messages=[{"role": "user", "content": prompt}],
    )
    return response.content[0].text.strip()


def run_update(coins=None, fetch=True, process=True):
    """
    Run the full update pipeline for the specified coins.

    Args:
        coins: List of coin names to update. Defaults to all available.
        fetch: Whether to download new PDFs.
        process: Whether to re-process PDFs.
    """
    if coins is None:
        coins = list(SCRIPTS.keys())

    print(f"Stablecoin Update Agent — {datetime.now().strftime('%Y-%m-%d %H:%M')}")
    print("=" * 50)

    before = {coin: csv_snapshot(PROCESSED[coin]) for coin in coins if coin in PROCESSED}
    run_log = []
    errors = []

    # ---- Fetch ----
    if fetch:
        print("\n[1/2] Fetching new PDFs...")
        for coin in coins:
            if coin not in SCRIPTS:
                continue
            print(f"  {coin.upper()}:", end=" ", flush=True)
            ok, output = run_script(SCRIPTS[coin]["fetch"])
            new_downloads = [l.strip() for l in output.splitlines() if "Downloaded" in l]
            skipped = sum(1 for l in output.splitlines() if "Skipping" in l)
            failed = [l.strip() for l in output.splitlines() if "Failed" in l]

            if new_downloads:
                print(f"{len(new_downloads)} new files downloaded")
                for line in new_downloads:
                    print(f"    {line}")
            else:
                print(f"no new files ({skipped} already present)")

            if failed:
                for line in failed:
                    print(f"    WARNING: {line}")
                errors.extend(failed)

            if not ok:
                errors.append(f"{coin} fetch script exited with error")

    # ---- Process ----
    if process:
        print("\n[2/2] Processing PDFs...")
        for coin in coins:
            if coin not in SCRIPTS:
                continue
            print(f"  {coin.upper()}:", end=" ", flush=True)
            ok, output = run_script(SCRIPTS[coin]["process"])
            saved = next((l.strip() for l in output.splitlines() if "Saved" in l), None)
            errs = [l.strip() for l in output.splitlines() if "Error" in l]

            if saved:
                print(saved)
            else:
                print("done")

            if errs:
                for e in errs:
                    print(f"    WARNING: {e}")
                errors.extend(errs)

            if not ok:
                errors.append(f"{coin} process script exited with error")

    # ---- Summary ----
    print("\n" + "=" * 50)
    print("SUMMARY")
    print("=" * 50)

    after = {coin: csv_snapshot(PROCESSED[coin]) for coin in coins if coin in PROCESSED}

    for coin in coins:
        if coin not in PROCESSED:
            continue
        b_rows, b_date = before.get(coin, (None, None))
        a_rows, a_date = after.get(coin, (None, None))

        if b_rows is None:
            status = f"Created — {a_rows} rows, latest: {a_date}"
        elif a_rows != b_rows:
            added = a_rows - b_rows
            status = f"{b_rows} → {a_rows} rows (+{added}), latest: {a_date}"
        else:
            status = f"No change — {a_rows} rows, latest: {a_date}"

        print(f"  {coin.upper():6s} {status}")
        run_log.append(f"{coin.upper()}: {status}")

    if errors:
        print("\nErrors:")
        for e in errors:
            print(f"  - {e}")
        run_log.append("Errors: " + "; ".join(errors))

    # Claude summary memo
    if run_log:
        print("\nMemo:")
        memo = summarize_with_claude("\n".join(run_log))
        print(f"  {memo}")

    print()


def main():
    parser = argparse.ArgumentParser(description="Monthly stablecoin data update agent")
    parser.add_argument("--coin", choices=list(SCRIPTS.keys()),
                        help="Update only this coin (default: all)")
    parser.add_argument("--no-fetch",   action="store_true", help="Skip downloading PDFs")
    parser.add_argument("--no-process", action="store_true", help="Skip processing PDFs")
    args = parser.parse_args()

    coins = [args.coin] if args.coin else None
    run_update(coins=coins, fetch=not args.no_fetch, process=not args.no_process)


if __name__ == "__main__":
    main()
