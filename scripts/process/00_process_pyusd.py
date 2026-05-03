"""
Parses pyusd_complete_data.R and writes:
  data/processed/pyusd/pyusd_reserves.csv     -- aggregate per reporting date
  data/processed/pyusd/pyusd_securities.csv   -- CUSIP-level detail
"""

import re
import csv
from pathlib import Path
from datetime import datetime

ROOT = Path(__file__).parent.parent.parent
R_FILE = ROOT / "scripts" / "process" / "pyusd_complete_data.R"
OUT_DIR = ROOT / "data" / "processed" / "pyusd"
OUT_DIR.mkdir(parents=True, exist_ok=True)


# ── R expression parsers ──────────────────────────────────────────────────────

def _split_args(s):
    parts, depth, cur = [], 0, []
    for ch in s:
        if ch == "(":
            depth += 1; cur.append(ch)
        elif ch == ")":
            depth -= 1; cur.append(ch)
        elif ch == "," and depth == 0:
            parts.append("".join(cur).strip()); cur = []
        else:
            cur.append(ch)
    if cur:
        parts.append("".join(cur).strip())
    return parts


def _as_date(s):
    s = s.strip().strip('"')
    return datetime.strptime(s, "%Y-%m-%d").date()


def _as_num(s):
    s = s.strip()
    if s in ("NA_real_", "NA"):
        return None
    try:
        return float(s)
    except ValueError:
        return None  # e.g. sum(...) expressions in aggregate rows


def _as_str(s):
    return s.strip().strip('"')


def _expand(expr, kind):
    expr = expr.strip()
    if re.match(r"(character|numeric|logical)\(0\)", expr):
        return []
    if expr in ("as.Date(NA)", "NA", "NA_real_"):
        return [None]
    m = re.match(r"as\.Date\(c\((.*)\)\)\s*$", expr, re.DOTALL)
    if m:
        return [_as_date(i) for i in _split_args(m.group(1))]
    m = re.match(r'as\.Date\("(.+?)"\)\s*$', expr)
    if m:
        return [_as_date(m.group(1))]
    if "as.Date(character(0))" in expr:
        return []
    m = re.match(r"c\((.*)\)\s*$", expr, re.DOTALL)
    if m:
        return [kind(i) for i in _split_args(m.group(1))]
    return [kind(expr)]


FIELD_PARSERS = {
    "date":         lambda e: _expand(e, _as_date),
    "maturity_date":lambda e: _expand(e, _as_date),
    "cusip":        lambda e: _expand(e, _as_str),
    "counterparty": lambda e: _expand(e, _as_str),
    "asset_type":   lambda e: _expand(e, _as_str),
    "collateral":   lambda e: _expand(e, _as_str),
    "par_value":    lambda e: _expand(e, _as_num),
    "unit_cost":    lambda e: _expand(e, _as_num),
    "unit_price":   lambda e: _expand(e, _as_num),
    "cost":         lambda e: _expand(e, _as_num),
    "fair_value":   lambda e: _expand(e, _as_num),
    "coupon_rate":  lambda e: _expand(e, _as_num),
    "circulation":  lambda e: _expand(e, _as_num),
    "ust_holdings": lambda e: _expand(e, _as_num),
}


# ── block parser ──────────────────────────────────────────────────────────────

def parse_data_table(block):
    """Parse a data.table(...) body into a list of row dicts."""
    # Split into field assignments, respecting nested parens/quotes
    parts = []
    depth, in_str, cur = 0, False, []
    for ch in block:
        if ch == '"' and not in_str:
            in_str = True; cur.append(ch)
        elif ch == '"' and in_str:
            in_str = False; cur.append(ch)
        elif not in_str and ch == "(":
            depth += 1; cur.append(ch)
        elif not in_str and ch == ")":
            depth -= 1; cur.append(ch)
        elif not in_str and ch == "," and depth == 0:
            parts.append("".join(cur).strip()); cur = []
        else:
            cur.append(ch)
    if cur:
        parts.append("".join(cur).strip())

    fields = {}
    for part in parts:
        m = re.match(r"^(\w+)\s*=\s*(.+)$", part.strip(), re.DOTALL)
        if m:
            fname, fexpr = m.group(1), m.group(2).strip()
            parser = FIELD_PARSERS.get(fname)
            if parser:
                fields[fname] = parser(fexpr)

    if not fields:
        return []

    n = max((len(v) for v in fields.values()), default=0)
    if n == 0:
        return []

    rows = []
    for i in range(n):
        row = {}
        for fname, vals in fields.items():
            if len(vals) == 1:
                row[fname] = vals[0]
            elif i < len(vals):
                row[fname] = vals[i]
            else:
                row[fname] = None
        rows.append(row)
    return rows


def extract_all_tables(r_text):
    """Find all `varname <- data.table(...)` blocks and parse them."""
    # Normalise line endings
    r_text = r_text.replace("\r\n", "\n")

    tables = {}
    # Match: identifier <- data.table( ... ) across lines
    pattern = re.compile(
        r"^(\w+)\s*<-\s*data\.table\s*\(", re.MULTILINE
    )

    for m in pattern.finditer(r_text):
        var_name = m.group(1)
        start = m.end()  # position just after opening paren
        # Walk forward to find matching closing paren
        depth, i = 1, start
        in_str = False
        while i < len(r_text) and depth > 0:
            ch = r_text[i]
            if ch == '"' and not in_str:
                in_str = True
            elif ch == '"' and in_str:
                in_str = False
            elif not in_str:
                if ch == "(":
                    depth += 1
                elif ch == ")":
                    depth -= 1
            i += 1
        block_body = r_text[start:i - 1]
        rows = parse_data_table(block_body)
        if rows:
            tables[var_name] = rows

    return tables


# ── build output CSVs ─────────────────────────────────────────────────────────

def build_reserves(tables):
    """Join pyusd_circulation + pyusd_ust into aggregate reserve rows."""
    circ = {r["date"]: r["circulation"] for r in tables.get("pyusd_circulation", [])}
    repo_map = {r["date"]: r["fair_value"] for r in tables.get("pyusd_repo", [])}
    ust_rows = tables.get("pyusd_ust", [])

    rows = []
    for r in ust_rows:
        d = r["date"]
        total = r["ust_holdings"]
        repo = repo_map.get(d)
        treasuries = (total - repo) if (total is not None and repo is not None) else None
        rows.append({
            "report_date":          d,
            "source_file":          "pyusd_complete_data.R",
            "auditor":              None,
            "tokens_in_circulation":circ.get(d),
            "total_reserves":       total,
            "repo":                 repo,
            "treasuries":           treasuries,
            "cash":                 None,
            "settlement_adj":       None,
        })
    return sorted(rows, key=lambda r: r["report_date"])


def build_securities(tables):
    """Collect all CUSIP-level rows from repo_collateral and ust_direct/ust tables."""
    rows = []
    sec_cols = {"date", "counterparty", "asset_type", "cusip",
                "maturity_date", "par_value", "unit_cost", "unit_price", "cost", "fair_value"}

    for var, data in tables.items():
        # Only tables that carry CUSIP data
        if not ("repo_collateral" in var or "ust_direct" in var
                or (var.endswith("_ust") and "pyusd_ust" not in var)):
            continue
        for r in data:
            if not r.get("cusip"):
                continue
            rows.append({
                "report_date":  r.get("date"),
                "source_file":  "pyusd_complete_data.R",
                "token":        "PYUSD",
                "counterparty": r.get("counterparty"),
                "asset_type":   r.get("asset_type"),
                "cusip":        r.get("cusip"),
                "maturity_date":r.get("maturity_date"),
                "par_value":    r.get("par_value"),
                "unit_cost":    r.get("unit_cost"),
                "unit_price":   r.get("unit_price"),
                "cost":         r.get("cost"),
                "fair_value":   r.get("fair_value"),
            })

    return sorted(rows, key=lambda r: (r["report_date"] or "", r.get("cusip") or ""))


def write_csv(path, rows, fieldnames):
    with open(path, "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fieldnames, extrasaction="ignore")
        w.writeheader()
        w.writerows(rows)
    print(f"  Wrote {len(rows):,} rows -> {path.name}")


def main():
    print("Parsing pyusd_complete_data.R ...")
    r_text = R_FILE.read_text(encoding="utf-8")
    tables = extract_all_tables(r_text)
    print(f"  Found {len(tables)} data.table objects")

    reserves = build_reserves(tables)
    write_csv(
        OUT_DIR / "pyusd_reserves.csv",
        reserves,
        ["report_date", "source_file", "auditor", "tokens_in_circulation",
         "total_reserves", "repo", "treasuries", "cash", "settlement_adj"],
    )

    securities = build_securities(tables)
    write_csv(
        OUT_DIR / "pyusd_securities.csv",
        securities,
        ["report_date", "source_file", "token", "counterparty", "asset_type",
         "cusip", "maturity_date", "par_value", "unit_cost", "unit_price",
         "cost", "fair_value"],
    )

    print("Done.")


if __name__ == "__main__":
    main()
