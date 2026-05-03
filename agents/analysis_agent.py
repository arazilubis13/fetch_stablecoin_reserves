# -*- coding: utf-8 -*-
"""
Interactive analysis agent: conversational Q&A over processed stablecoin data.

Loads all processed CSVs and answers questions using Claude.

Usage:
    python agents/analysis_agent.py
    python agents/analysis_agent.py --query "What was USDC's total reserves in Jan 2025?"
"""

import sys
import argparse
import pandas as pd
import anthropic
from pathlib import Path
from io import StringIO

PROJECT_ROOT = Path(__file__).parent.parent
MODEL = "claude-sonnet-4-6"

DATASETS = {
    "usdc_reserves":    PROJECT_ROOT / "data" / "processed" / "usdc" / "usdc_reserves.csv",
    "usdc_treasury":    PROJECT_ROOT / "data" / "processed" / "usdc" / "usdc_treasury_securities.csv",
    "eurc_reserves":    PROJECT_ROOT / "data" / "processed" / "eurc" / "eurc_reserves.csv",
    "busd_summary":     PROJECT_ROOT / "data" / "processed" / "busd" / "busd_reserves_summary_aug_nov_2025.csv",
    "busd_detailed":    PROJECT_ROOT / "data" / "processed" / "busd" / "busd_reserves_detailed_aug_nov_2025.csv",
}

COINGECKO_DIR = PROJECT_ROOT / "data" / "raw" / "coingecko"


def load_datasets():
    """Load all available processed CSVs."""
    dfs = {}
    for name, path in DATASETS.items():
        if path.exists():
            dfs[name] = pd.read_csv(path)
        else:
            print(f"  (not found: {name})")

    # Load coingecko price files
    for csv in sorted(COINGECKO_DIR.glob("*-usd-max.csv")):
        coin = csv.stem.replace("-usd-max", "")
        dfs[f"price_{coin}"] = pd.read_csv(csv)

    return dfs


def df_summary(name, df):
    """Produce a compact text summary of a DataFrame for the system prompt."""
    buf = StringIO()
    buf.write(f"### {name}  ({len(df)} rows)\n")
    buf.write(f"Columns: {', '.join(df.columns)}\n")

    # Full data for small tables, tail for larger ones
    if len(df) <= 40:
        buf.write(df.to_csv(index=False))
    else:
        buf.write("(first 5 rows)\n")
        buf.write(df.head(5).to_csv(index=False))
        buf.write("...\n(last 10 rows)\n")
        buf.write(df.tail(10).to_csv(index=False))

    # Numeric summary
    num_cols = df.select_dtypes(include="number").columns.tolist()
    if num_cols and len(df) > 1:
        buf.write("\nNumeric summary:\n")
        buf.write(df[num_cols].describe().to_string())
        buf.write("\n")

    return buf.getvalue()


def build_system_prompt(dfs):
    parts = [
        "You are a stablecoin reserve research assistant. You have access to attestation "
        "reserve data for USDC, EURC, BUSD, and price data for several stablecoins. "
        "Answer questions accurately and concisely. Cite specific dates and figures when relevant. "
        "All USD/EUR amounts are in dollars/euros (not millions or billions — exact figures).\n"
    ]

    parts.append("## Loaded Datasets\n")
    for name, df in dfs.items():
        parts.append(df_summary(name, df))
        parts.append("")

    return "\n".join(parts)


def run_query(dfs, query, history=None):
    """Run a single query and return the response text."""
    client = anthropic.Anthropic()
    system = build_system_prompt(dfs)

    if history is None:
        history = []

    history = history + [{"role": "user", "content": query}]

    response = client.messages.create(
        model=MODEL,
        max_tokens=2000,
        system=system,
        messages=history,
    )
    return response.content[0].text.strip()


def interactive_chat(dfs):
    """Run a multi-turn conversational session."""
    print("\nStablecoin Analysis Agent — type 'quit' to exit, 'reset' to clear history.\n")

    client = anthropic.Anthropic()
    system = build_system_prompt(dfs)
    history = []

    while True:
        try:
            user_input = input("You: ").strip()
        except (EOFError, KeyboardInterrupt):
            print("\nExiting.")
            break

        if not user_input:
            continue
        if user_input.lower() in ("quit", "exit", "q"):
            break
        if user_input.lower() == "reset":
            history = []
            print("  (conversation history cleared)\n")
            continue

        history.append({"role": "user", "content": user_input})

        response = client.messages.create(
            model=MODEL,
            max_tokens=2000,
            system=system,
            messages=history,
        )

        answer = response.content[0].text.strip()
        history.append({"role": "assistant", "content": answer})
        print(f"\nAssistant: {answer}\n")


def main():
    parser = argparse.ArgumentParser(description="Interactive stablecoin data analysis agent")
    parser.add_argument("--query", "-q", help="Single query (non-interactive mode)")
    args = parser.parse_args()

    print("Loading stablecoin datasets...")
    dfs = load_datasets()
    print(f"  Loaded {len(dfs)} datasets\n")

    if not dfs:
        print("No data found. Run the update agent first.")
        sys.exit(1)

    if args.query:
        answer = run_query(dfs, args.query)
        print(answer)
    else:
        interactive_chat(dfs)


if __name__ == "__main__":
    main()
