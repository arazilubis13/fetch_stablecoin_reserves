# Stablecoin Reserve Data Project

## Overview

This project collects, processes, and stores reserve attestation data for major stablecoins. Data is sourced from official transparency reports published by stablecoin issuers. The pipeline downloads raw PDFs, extracts structured reserve information using Python, and saves it to CSV files for analysis.

---

## Directory Structure

```
stablecoins/
├── data/
│   ├── raw/
│   │   ├── eurc/           EURC/EUROC attestation PDFs from Circle (2022–present)
│   │   ├── usdc/           USDC attestation PDFs from Circle (2018–present)
│   │   ├── aave/           Aavescan CSV exports (USDC, USDT history on Aave v3)
│   │   └── coingecko/      Price history CSVs from CoinGecko (max range)
│   └── processed/
│       ├── eurc/           Extracted EURC reserve data (eurc_reserves.csv)
│       ├── usdc/           Extracted USDC reserve data and Treasury securities
│       └── busd/           Manually collected BUSD attestation data
├── scripts/
│   ├── fetch/              Scripts that download raw data
│   ├── process/            Scripts that parse PDFs and produce CSVs
│   └── analysis/           R scripts for analysis and modelling
├── docs/                   Project documentation (this file)
├── output/                 Output PDFs and figures
└── [legacy dirs]           aavescan/, busd/, coingecko/, collected_busd/
                            (kept for reference, data moved to data/)
```

---

## Environment

- **OS**: Windows 10
- **Python**: Anaconda base environment (`C:\Users\X1 Carbon i7-7500\anaconda3\`)
- **Required packages**: `requests`, `pandas`, `pdfplumber`
- **Always use full paths**:
  - Python: `"C:\Users\X1 Carbon i7-7500\anaconda3\python.exe"`
  - Pip: `"C:\Users\X1 Carbon i7-7500\anaconda3\Scripts\pip.exe"`

### Installing dependencies
```
"C:\Users\X1 Carbon i7-7500\anaconda3\Scripts\pip.exe" install pdfplumber
```

---

## Data Sources

### EURC (Circle Euro Coin)
- **Issuer**: Circle Internet Financial, LLC
- **Currency**: Euro (EUR)
- **Reports**: Monthly attestation reports by Deloitte
- **Coverage**: June 2022 – present
- **Source URL**: https://www.circle.com/transparency
- **PDF host**: HubSpot CDN (`6778953.fs1.hubspotusercontent-na1.net`)
- **Notes**:
  - Early reports (2022) labelled "EUROC", rebranded to "EURC" in mid-2023
  - Each PDF covers **two report dates** (bi-monthly snapshots)
  - Reserve is 100% cash held at regulated European financial institutions

### USDC (Circle USD Coin)
- **Issuer**: Circle Internet Financial, LLC
- **Currency**: US Dollar (USD)
- **Reports**: Monthly attestation reports (Grant Thornton 2018–2022, Deloitte 2023+)
- **Coverage**: October 2018 – present
- **Source URL**: https://www.circle.com/transparency
- **PDF host**: HubSpot CDN (`6778953.fs1.hubspotusercontent-na1.net`)
- **Notes**:
  - Modern format (2023+): Two report dates per PDF, detailed breakdown
  - Legacy format (2022): Single date, limited extraction possible
  - Pre-2022: Mostly image-based, USDC in circulation extractable from page 1 only
  - Reserves held in Circle Reserve Fund (T-bills + repo) and bank accounts

### BUSD (Binance USD) — Legacy
- **Issuer**: Paxos Trust Company
- **Status**: Discontinued (Paxos stopped minting Feb 2023)
- **Data**: Manually collected attestation data stored as CSVs in `data/processed/busd/`
- **Scripts**: `scripts/fetch/busd_attestation_data.R`, `00_collect_busd_trnspy.r`

### CoinGecko Price Data
- **Coverage**: Max historical range for BUSD, PYUSD, USDC, USDT, TUSD, FDUSD, FUSD
- **Format**: CSV files (`{coin}-usd-max.csv`) in `data/raw/coingecko/`

### Aave (USDC/USDT on Aave v3 Ethereum)
- **Data**: Interest rate and liquidity history from Aavescan
- **Files**: `data/raw/aave/aavescan-aave-v3-ethereum-{usdc,usdt}-history.csv`
- **Script**: `scripts/analysis/00_aave_sofr.R`

---

## Scripts

### Fetch Scripts (`scripts/fetch/`)

#### `00_fetch_eurc.py`
Downloads all EURC/EUROC attestation PDFs from Circle's transparency page.

- **Input**: Hardcoded URL list (44 reports, 2022-06 to 2026-01)
- **Output**: `data/raw/eurc/eurc_YYYY-MM.pdf`
- **Behaviour**: Skips files already downloaded (safe to re-run monthly)
- **Run**:
  ```
  "C:\Users\X1 Carbon i7-7500\anaconda3\python.exe" scripts/fetch/00_fetch_eurc.py
  ```

#### `00_fetch_usdc.py`
Downloads all USDC attestation PDFs from Circle's transparency page.

- **Input**: Hardcoded URL list (98 reports, 2018-10 to 2026-01)
- **Output**: `data/raw/usdc/usdc_YYYY-MM.pdf`
- **Behaviour**: Skips files already downloaded (safe to re-run monthly)
- **Run**:
  ```
  "C:\Users\X1 Carbon i7-7500\anaconda3\python.exe" scripts/fetch/00_fetch_usdc.py
  ```

#### `00_pyusd_reserves.R` / `00_pyusd_reserves_part2.R`
R scripts that fetch PYUSD reserve data from PayPal's transparency reports.

#### `00_collect_busd_trnspy.r` / `00_manual_collect_busd.r`
R scripts used to collect BUSD attestation data from Paxos transparency reports.

---

### Process Scripts (`scripts/process/`)

#### `00_process_eurc.py`
Parses EURC PDFs and extracts reserve data to CSV.

- **Input**: `data/raw/eurc/eurc_YYYY-MM.pdf`
- **Output**: `data/processed/eurc/eurc_reserves.csv`
- **Rows**: Two per PDF (one per report date)
- **Columns**:

| Column | Description |
|--------|-------------|
| `file` | Source PDF filename |
| `report_date` | Report date (e.g. "June 10, 2024") |
| `eurc_in_circulation` | Total EURC tokens in circulation |
| `fair_value_reserves` | Fair value of assets held in EURC reserve (EUR) |
| `cash_held` | Cash held at regulated financial institutions (EUR) |
| `settlement` | Timing/settlement adjustments (EUR, can be negative) |
| `total_reserves` | Total EURC reserve assets (EUR) |
| `auditor` | Attesting firm (e.g. Deloitte) |

- **Run**:
  ```
  "C:\Users\X1 Carbon i7-7500\anaconda3\python.exe" scripts/process/00_process_eurc.py
  ```

#### `00_process_usdc.py`
Parses USDC PDFs and extracts reserve data to two CSVs.

- **Input**: `data/raw/usdc/usdc_YYYY-MM.pdf`
- **Output**:
  - `data/processed/usdc/usdc_reserves.csv` — summary per report date
  - `data/processed/usdc/usdc_treasury_securities.csv` — individual T-bill holdings

- **Format detection**:
  - `modern` (2023+): Two dates per PDF, full breakdown
  - `legacy` (2022): Single date, limited fields
  - Pre-2022: USDC in circulation only (image-based PDFs)

- **Columns — `usdc_reserves.csv`**:

| Column | Description |
|--------|-------------|
| `file` | Source PDF filename |
| `report_date` | Report date |
| `format` | `modern` or `legacy` |
| `usdc_in_circulation` | Total USDC tokens in circulation |
| `fair_value_reserves` | Fair value of all USDC reserve assets (USD) |
| `treasury_securities` | Total US Treasury securities in Circle Reserve Fund (USD) |
| `repo` | US Treasury Repurchase Agreements (USD) |
| `fund_cash` | Cash held in Circle Reserve Fund (USD) |
| `fund_total` | Total Circle Reserve Fund assets (USD) |
| `bank_cash` | Cash held at regulated financial institutions (USD) |
| `other_total` | Total Other USDC Reserve Assets (USD) |
| `total_reserves` | Total USDC reserve assets (USD) |
| `auditor` | Attesting firm |

- **Columns — `usdc_treasury_securities.csv`**:

| Column | Description |
|--------|-------------|
| `file` | Source PDF filename |
| `report_date` | Report date |
| `cusip` | 9-character CUSIP identifier |
| `maturity_date` | Security maturity date (MM/DD/YY) |
| `fair_value` | Fair value of the holding (USD) |

- **Run**:
  ```
  "C:\Users\X1 Carbon i7-7500\anaconda3\python.exe" scripts/process/00_process_usdc.py
  ```

#### `debug_eurc_pdf.py` / `debug_usdc_pdf.py`
Diagnostic scripts that dump raw extracted text from PDFs to the terminal. Used to inspect PDF structure when fixing regex patterns.

#### `pyusd_complete_data.R` / `pyusd_complete_data(1).R`
R scripts that manually encode PYUSD reserve data (UST holdings and repo collateral by CUSIP) from attestation reports. Data goes back to August 2023.

---

### Analysis Scripts (`scripts/analysis/`)

#### `00_aave_sofr.R`
Analyses USDC/USDT rates on Aave v3 Ethereum relative to SOFR.

#### `00_reproduce_ahmed_25.r`
Replication code for Ahmed (2025) paper on stablecoin reserve composition.

---

## Monthly Update Workflow

Each month when new attestation reports are published:

1. **Open Anaconda Prompt**
2. Navigate to project:
   ```
   cd "C:\Users\X1 Carbon i7-7500\Dropbox\stablecoins"
   ```
3. Download new PDFs (skips existing files automatically):
   ```
   "C:\Users\X1 Carbon i7-7500\anaconda3\python.exe" scripts/fetch/00_fetch_eurc.py
   "C:\Users\X1 Carbon i7-7500\anaconda3\python.exe" scripts/fetch/00_fetch_usdc.py
   ```
4. Re-run processors to update CSVs:
   ```
   "C:\Users\X1 Carbon i7-7500\anaconda3\python.exe" scripts/process/00_process_eurc.py
   "C:\Users\X1 Carbon i7-7500\anaconda3\python.exe" scripts/process/00_process_usdc.py
   ```
5. Close any open CSVs in Excel before running processors (avoids PermissionError)

---

## Known Issues & Notes

- **PermissionError [Errno 13]**: Occurs when trying to write a CSV that is open in Excel. Close the file and re-run.
- **USDC pre-2022 PDFs**: Image-based, very limited text extraction. Only USDC in circulation (from page 1 text) may be available.
- **EURC 2022 older PDFs**: Some fields may be NaN due to different report layout. Check `eurc_reserves.csv` for coverage.
- **USDC URL patterns**: Circle's HubSpot URLs are inconsistent (some use hyphens, some use `%20`). URLs are hardcoded in the fetch scripts to handle this.
- **Windows encoding**: When redirecting Python output to a file, use `set PYTHONIOENCODING=utf-8` first to avoid charmap errors from special PDF characters.
- **pdfplumber CID codes**: Some text in PDFs renders as `(cid:XX)` sequences — these are font encoding artifacts and cannot be decoded without the original font file.
