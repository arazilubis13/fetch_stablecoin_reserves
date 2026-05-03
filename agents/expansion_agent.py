# -*- coding: utf-8 -*-
"""
Expansion agent: adds coverage for new stablecoins using Claude tool-use.

Given a directory of PDFs for a new stablecoin, the agent:
  1. Samples PDFs to understand the report structure
  2. Extracts data from all PDFs using Claude
  3. Saves a structured CSV to data/processed/<coin>/

Usage:
    python agents/expansion_agent.py --coin pyusd --dir data/raw/pyusd
    python agents/expansion_agent.py --coin usdt  --dir data/raw/usdt --desc "Tether USDT reserve attestation"
    python agents/expansion_agent.py --coin fdusd --dir data/raw/fdusd
"""

import json
import argparse
import pdfplumber
import anthropic
import pandas as pd
from pathlib import Path

PROJECT_ROOT = Path(__file__).parent.parent
MODEL = "claude-sonnet-4-6"

# Tool definitions for the agentic loop
TOOLS = [
    {
        "name": "list_pdfs",
        "description": "List PDF files available in the coin's raw data directory.",
        "input_schema": {
            "type": "object",
            "properties": {
                "directory": {"type": "string", "description": "Directory path to list PDFs from"}
            },
            "required": ["directory"],
        },
    },
    {
        "name": "read_pdf_text",
        "description": "Extract raw text from a PDF file using pdfplumber. Use this to inspect report structure.",
        "input_schema": {
            "type": "object",
            "properties": {
                "file_path": {"type": "string", "description": "Full path to the PDF file"}
            },
            "required": ["file_path"],
        },
    },
    {
        "name": "extract_records",
        "description": (
            "Extract structured reserve data from a PDF. Provide the file path and a JSON schema "
            "describing the fields to extract (field_name -> description). Returns a list of records."
        ),
        "input_schema": {
            "type": "object",
            "properties": {
                "file_path": {"type": "string", "description": "Full path to the PDF file"},
                "schema": {
                    "type": "object",
                    "description": "Mapping of field names to descriptions for extraction",
                    "additionalProperties": {"type": "string"},
                },
                "currency": {"type": "string", "description": "Currency of monetary values (e.g. USD, EUR)"},
            },
            "required": ["file_path", "schema"],
        },
    },
    {
        "name": "save_csv",
        "description": "Save extracted records to a CSV file in the processed data directory.",
        "input_schema": {
            "type": "object",
            "properties": {
                "records": {
                    "type": "array",
                    "description": "List of record dicts to save",
                    "items": {"type": "object"},
                },
                "coin": {"type": "string", "description": "Coin name (used for output directory and filename)"},
                "filename": {"type": "string", "description": "Output CSV filename (e.g. pyusd_reserves.csv)"},
            },
            "required": ["records", "coin", "filename"],
        },
    },
]


# ---- Tool implementations ----

def tool_list_pdfs(directory):
    path = Path(directory)
    if not path.is_absolute():
        path = PROJECT_ROOT / path
    if not path.exists():
        return {"error": f"Directory not found: {path}"}
    pdfs = sorted(path.glob("*.pdf"))
    return {"files": [str(p) for p in pdfs], "count": len(pdfs)}


def tool_read_pdf_text(file_path):
    path = Path(file_path)
    if not path.exists():
        return {"error": f"File not found: {file_path}"}
    try:
        with pdfplumber.open(path) as pdf:
            pages = [page.extract_text() or "" for page in pdf.pages]
        text = "\n".join(pages)
        return {"text": text[:8000], "total_chars": len(text), "pages": len(pages)}
    except Exception as e:
        return {"error": str(e)}


def tool_extract_records(file_path, schema, currency="USD"):
    path = Path(file_path)
    if not path.exists():
        return {"error": f"File not found: {file_path}"}

    try:
        with pdfplumber.open(path) as pdf:
            pages = [page.extract_text() or "" for page in pdf.pages]
        text = "\n".join(pages)
    except Exception as e:
        return {"error": f"PDF read error: {e}"}

    if not text.strip():
        return {"records": [], "warning": "No text extracted — may be image-based PDF"}

    fields_desc = "\n".join(f"  - {k}: {v}" for k, v in schema.items())

    prompt = f"""Extract structured reserve data from this stablecoin attestation report.
Currency: {currency}

Fields to extract for each report date:
{fields_desc}

Rules:
- Numeric values: plain numbers, no currency symbols or commas
- Negative values: negative numbers
- Missing fields: null
- Return a JSON array of objects, one per report date found
- Return only the JSON array

PDF TEXT:
---
{text[:15000]}
---"""

    client = anthropic.Anthropic()
    response = client.messages.create(
        model=MODEL,
        max_tokens=2000,
        messages=[{"role": "user", "content": prompt}],
    )

    raw = response.content[0].text.strip()
    if raw.startswith("```"):
        raw = raw.split("```")[1]
        if raw.startswith("json"):
            raw = raw[4:]
    raw = raw.strip()

    try:
        records = json.loads(raw)
        for rec in records:
            rec["file"] = path.name
        return {"records": records}
    except json.JSONDecodeError as e:
        return {"error": f"JSON parse error: {e}", "raw": raw[:500]}


def tool_save_csv(records, coin, filename):
    out_dir = PROJECT_ROOT / "data" / "processed" / coin
    out_dir.mkdir(parents=True, exist_ok=True)
    out_path = out_dir / filename

    df = pd.DataFrame(records)
    df.to_csv(out_path, index=False)
    return {"saved": str(out_path), "rows": len(df), "columns": list(df.columns)}


def dispatch_tool(tool_name, tool_input):
    """Route a tool call to its implementation."""
    if tool_name == "list_pdfs":
        return tool_list_pdfs(**tool_input)
    elif tool_name == "read_pdf_text":
        return tool_read_pdf_text(**tool_input)
    elif tool_name == "extract_records":
        return tool_extract_records(**tool_input)
    elif tool_name == "save_csv":
        return tool_save_csv(**tool_input)
    else:
        return {"error": f"Unknown tool: {tool_name}"}


# ---- Agentic loop ----

def run_expansion(coin, pdf_dir, description=None):
    """
    Run the expansion agent for a new stablecoin.

    The agent will autonomously sample PDFs, determine the report structure,
    extract all data, and save a CSV.
    """
    coin = coin.lower()
    pdf_dir = str(PROJECT_ROOT / pdf_dir) if not Path(pdf_dir).is_absolute() else pdf_dir

    if description is None:
        description = f"{coin.upper()} reserve attestation reports"

    system_prompt = (
        f"You are a stablecoin data pipeline agent. Your task is to extract reserve data "
        f"from {description} and save it as a structured CSV.\n\n"
        "Workflow:\n"
        "1. List available PDFs in the directory\n"
        "2. Read 1-2 sample PDFs to understand the report structure and identify key fields\n"
        "3. Define an extraction schema based on what you found\n"
        "4. Extract data from ALL PDFs using that schema\n"
        "5. Save all records to a CSV\n\n"
        "Be thorough: extract every report date in every PDF. "
        "When you have saved the CSV, explain what data was collected."
    )

    client = anthropic.Anthropic()
    messages = [
        {
            "role": "user",
            "content": (
                f"Process all {coin.upper()} PDFs in directory: {pdf_dir}\n"
                f"Save the output as {coin}_reserves.csv"
            ),
        }
    ]

    print(f"Expansion Agent — {coin.upper()}")
    print(f"Directory: {pdf_dir}")
    print("=" * 50)

    # Agentic loop
    while True:
        response = client.messages.create(
            model=MODEL,
            max_tokens=4096,
            system=system_prompt,
            tools=TOOLS,
            messages=messages,
        )

        # Collect any text the model outputs
        for block in response.content:
            if hasattr(block, "text") and block.text:
                print(f"\nAgent: {block.text}")

        # Stop conditions
        if response.stop_reason == "end_turn":
            break
        if response.stop_reason != "tool_use":
            print(f"Unexpected stop_reason: {response.stop_reason}")
            break

        # Process tool calls
        tool_results = []
        for block in response.content:
            if block.type != "tool_use":
                continue

            print(f"\n  [tool] {block.name}({json.dumps(block.input)[:120]})")
            result = dispatch_tool(block.name, block.input)
            print(f"  [result] {json.dumps(result)[:200]}")

            tool_results.append({
                "type": "tool_result",
                "tool_use_id": block.id,
                "content": json.dumps(result),
            })

        # Append assistant turn + tool results to messages
        messages.append({"role": "assistant", "content": response.content})
        messages.append({"role": "user", "content": tool_results})

    print("\n" + "=" * 50)
    print("Done.")


def main():
    parser = argparse.ArgumentParser(description="Expansion agent: add coverage for a new stablecoin")
    parser.add_argument("--coin", required=True,
                        help="Coin identifier (e.g. pyusd, usdt, fdusd)")
    parser.add_argument("--dir", required=True,
                        help="Directory containing the coin's raw PDFs")
    parser.add_argument("--desc",
                        help="Description of the reports (e.g. 'Tether USDT transparency report')")
    args = parser.parse_args()

    run_expansion(coin=args.coin, pdf_dir=args.dir, description=args.desc)


if __name__ == "__main__":
    main()
