# -*- coding: utf-8 -*-
"""
Stablecoin agent orchestrator — single entry point for all pipeline agents.

Usage:
    python agents/orchestrator.py update
    python agents/orchestrator.py update --coin usdc --no-fetch
    python agents/orchestrator.py analyze
    python agents/orchestrator.py analyze --query "What was USDC reserves in Jan 2025?"
    python agents/orchestrator.py extract data/raw/usdc/usdc_2026-02.pdf --coin usdc
    python agents/orchestrator.py expand --coin pyusd --dir data/raw/pyusd

Run from the project root:
    "C:\\Users\\X1 Carbon i7-7500\\anaconda3\\python.exe" agents/orchestrator.py <command>
"""

import sys
import argparse
from pathlib import Path

PROJECT_ROOT = Path(__file__).parent.parent


def cmd_update(args):
    from agents.update_agent import run_update
    coins = [args.coin] if args.coin else None
    run_update(coins=coins, fetch=not args.no_fetch, process=not args.no_process)


def cmd_analyze(args):
    from agents.analysis_agent import load_datasets, run_query, interactive_chat
    print("Loading stablecoin datasets...")
    dfs = load_datasets()
    print(f"  Loaded {len(dfs)} datasets\n")
    if not dfs:
        print("No data found. Run: python agents/orchestrator.py update")
        sys.exit(1)
    if args.query:
        answer = run_query(dfs, args.query)
        print(answer)
    else:
        interactive_chat(dfs)


def cmd_extract(args):
    from agents.extraction_agent import extract_with_claude
    import json
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


def cmd_expand(args):
    from agents.expansion_agent import run_expansion
    run_expansion(coin=args.coin, pdf_dir=args.dir, description=args.desc)


def main():
    parser = argparse.ArgumentParser(
        description="Stablecoin pipeline agent orchestrator",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    sub = parser.add_subparsers(dest="command", required=True)

    # ---- update ----
    p_update = sub.add_parser("update", help="Run monthly fetch + process pipeline")
    p_update.add_argument("--coin", choices=["usdc", "eurc"], help="Update only this coin")
    p_update.add_argument("--no-fetch",   action="store_true", help="Skip PDF downloads")
    p_update.add_argument("--no-process", action="store_true", help="Skip PDF processing")
    p_update.set_defaults(func=cmd_update)

    # ---- analyze ----
    p_analyze = sub.add_parser("analyze", help="Interactive Q&A over reserve data")
    p_analyze.add_argument("--query", "-q", help="Single query (non-interactive)")
    p_analyze.set_defaults(func=cmd_analyze)

    # ---- extract ----
    p_extract = sub.add_parser("extract", help="Extract data from a single PDF using Claude")
    p_extract.add_argument("pdf", help="Path to PDF file")
    p_extract.add_argument("--coin", default="unknown",
                           choices=["usdc", "eurc", "pyusd", "unknown"],
                           help="Coin type (default: unknown)")
    p_extract.add_argument("--desc", help="Custom description of the report")
    p_extract.set_defaults(func=cmd_extract)

    # ---- expand ----
    p_expand = sub.add_parser("expand", help="Add coverage for a new stablecoin")
    p_expand.add_argument("--coin", required=True, help="Coin identifier (e.g. pyusd, usdt)")
    p_expand.add_argument("--dir",  required=True, help="Directory of raw PDFs for this coin")
    p_expand.add_argument("--desc", help="Description of the reports")
    p_expand.set_defaults(func=cmd_expand)

    args = parser.parse_args()

    # Ensure project root is on sys.path so agent imports work
    sys.path.insert(0, str(PROJECT_ROOT))

    args.func(args)


if __name__ == "__main__":
    main()
