# BUSD Attestation Report Data Collection
# Extracted from Paxos Trust Company attestation reports
# Contract: 0x4fabb145d64652a948d72533023f6e7a623c7c53

library(data.table)

# =============================================================================
# SUMMARY DATA
# =============================================================================

busd_summary <- data.table(
  report_date = as.Date(c(
    "2024-11-25", "2024-11-29",
    "2024-12-02", "2024-12-31",
    "2025-01-21", "2025-01-31",
    "2025-02-13", "2025-02-28",
    "2025-03-18", "2025-03-31",
    "2025-04-10", "2025-04-30"
  )),
  tokens_outstanding = c(
    68223497, 68223497,
    68223497, 68223497,
    60490548, 60490548,
    60490548, 60490548,
    60490548, 57893556,
    57893556, 57792684
  ),
  redemption_assets_usd = c(
    69781254, 69816065,
    69842303, 69825809,
    60637473, 60708689,
    60576432, 60683253,
    60611598, 58102725,
    58171381, 57990387
  ),
  auditor = c(
    "WithumSmith+Brown", "WithumSmith+Brown",
    "WithumSmith+Brown", "WithumSmith+Brown",
    "KPMG", "KPMG",
    "KPMG", "KPMG",
    "KPMG", "KPMG",
    "KPMG", "KPMG"
  ),
  report_issued = as.Date(c(
    "2024-12-18", "2024-12-18",
    "2025-01-20", "2025-01-20",
    "2025-02-28", "2025-02-28",
    "2025-03-28", "2025-03-28",
    "2025-04-29", "2025-04-29",
    "2025-05-28", "2025-05-28"
  ))
)

# Calculate derived metrics
busd_summary[, `:=`(
  surplus_usd = redemption_assets_usd - tokens_outstanding,
  overcollateral_pct = (redemption_assets_usd / tokens_outstanding - 1) * 100
)]

# =============================================================================
# RESERVE COMPOSITION (DETAILED HOLDINGS)
# =============================================================================

busd_holdings <- data.table(
  report_date = as.Date(c(
    # Nov 25, 2024
    "2024-11-25", "2024-11-25",
    # Nov 29, 2024
    "2024-11-29", "2024-11-29", "2024-11-29",
    # Dec 2, 2024
    "2024-12-02", "2024-12-02",
    # Dec 31, 2024
    "2024-12-31", "2024-12-31", "2024-12-31",
    # Jan 21, 2025
    "2025-01-21", "2025-01-21",
    # Jan 31, 2025
    "2025-01-31", "2025-01-31",
    # Feb 13, 2025
    "2025-02-13", "2025-02-13",
    # Feb 28, 2025
    "2025-02-28", "2025-02-28",
    # Mar 18, 2025
    "2025-03-18", "2025-03-18",
    # Mar 31, 2025
    "2025-03-31", "2025-03-31",
    # Apr 10, 2025
    "2025-04-10", "2025-04-10",
    # Apr 30, 2025
    "2025-04-30", "2025-04-30"
  )),
  asset_type = c(
    # Nov 25, 2024
    "US Treasury Debt (Repo)", "Cash",
    # Nov 29, 2024
    "US Treasury Debt (Repo)", "US Treasury Debt (Repo)", "Cash",
    # Dec 2, 2024
    "US Treasury Debt (Repo)", "Cash",
    # Dec 31, 2024
    "US Treasury Debt (Repo)", "US Treasury Debt (Repo)", "Cash",
    # Jan 21, 2025
    "Repurchase Agreement", "Cash",
    # Jan 31, 2025
    "Repurchase Agreement", "Cash",
    # Feb 13, 2025
    "Repurchase Agreement", "Cash",
    # Feb 28, 2025
    "Repurchase Agreement", "Cash",
    # Mar 18, 2025
    "Repurchase Agreement", "Cash",
    # Mar 31, 2025
    "Repurchase Agreement", "Cash",
    # Apr 10, 2025
    "Repurchase Agreement", "Cash",
    # Apr 30, 2025
    "Repurchase Agreement", "Cash"
  ),
  cusip = c(
    # Nov 25, 2024
    "912810UA4", NA_character_,
    # Nov 29, 2024
    "91282CLJ8", "912810TM0", NA_character_,
    # Dec 2, 2024
    "912810TL2", NA_character_,
    # Dec 31, 2024
    "912810QE1", "912810SQ2", NA_character_,
    # Jan 21, 2025
    NA_character_, NA_character_,
    # Jan 31, 2025
    NA_character_, NA_character_,
    # Feb 13, 2025
    NA_character_, NA_character_,
    # Feb 28, 2025
    NA_character_, NA_character_,
    # Mar 18, 2025
    NA_character_, NA_character_,
    # Mar 31, 2025
    NA_character_, NA_character_,
    # Apr 10, 2025
    NA_character_, NA_character_,
    # Apr 30, 2025
    NA_character_, NA_character_
  ),
  maturity_date = as.Date(c(
    # Nov 25, 2024
    "2054-05-15", NA,
    # Nov 29, 2024
    "2031-08-31", "2042-11-15", NA,
    # Dec 2, 2024
    "2052-11-15", NA,
    # Dec 31, 2024
    "2040-02-15", "2040-08-15", NA,
    # Jan 21, 2025 (overnight repos)
    "2025-01-22", NA,
    # Jan 31, 2025 (overnight repos)
    "2025-02-03", NA,
    # Feb 13, 2025 (overnight repos)
    "2025-02-14", NA,
    # Feb 28, 2025 (overnight repos)
    "2025-03-03", NA,
    # Mar 18, 2025 (overnight repos)
    "2025-03-19", NA,
    # Mar 31, 2025 (overnight repos)
    "2025-04-01", NA,
    # Apr 10, 2025 (overnight repos)
    "2025-04-11", NA,
    # Apr 30, 2025 (overnight repos)
    "2025-05-01", NA
  )),
  fair_value_usd = c(
    # Nov 25, 2024
    68845920, 935334,
    # Nov 29, 2024
    38754851, 30125749, 935465,
    # Dec 2, 2024
    68907120, 935183,
    # Dec 31, 2024
    48483109, 20406671, 936029,
    # Jan 21, 2025
    59701000, 936473,
    # Jan 31, 2025
    59772000, 936689,
    # Feb 13, 2025
    59640000, 936432,
    # Feb 28, 2025
    59747000, 936253,
    # Mar 18, 2025
    57028000, 3583598,
    # Mar 31, 2025
    57116000, 986725,
    # Apr 10, 2025
    57185000, 986381,
    # Apr 30, 2025
    57055000, 935387
  ),
  coupon_rate = c(
    # Nov 25, 2024
    NA_real_, NA_real_,
    # Nov 29, 2024
    NA_real_, NA_real_, NA_real_,
    # Dec 2, 2024
    NA_real_, NA_real_,
    # Dec 31, 2024
    NA_real_, NA_real_, NA_real_,
    # Jan 21, 2025 (repo rates)
    0.0425, NA_real_,
    # Jan 31, 2025
    0.0432, NA_real_,
    # Feb 13, 2025
    0.0430, NA_real_,
    # Feb 28, 2025
    0.0434, NA_real_,
    # Mar 18, 2025
    0.0428, NA_real_,
    # Mar 31, 2025
    0.0436, NA_real_,
    # Apr 10, 2025
    0.0432, NA_real_,
    # Apr 30, 2025
    0.0435, NA_real_
  )
)

# =============================================================================
# AGGREGATED COMPOSITION BY DATE
# =============================================================================

busd_composition <- busd_holdings[, .(
  total_treasuries_repo = sum(fair_value_usd[asset_type %in% c("US Treasury Debt (Repo)", "Repurchase Agreement")]),
  total_cash = sum(fair_value_usd[asset_type == "Cash"]),
  total_redemption_assets = sum(fair_value_usd)
), by = report_date]

busd_composition[, `:=`(
  treasury_pct = total_treasuries_repo / total_redemption_assets * 100,
  cash_pct = total_cash / total_redemption_assets * 100
)]

# =============================================================================
# METADATA
# =============================================================================

busd_metadata <- list(
  token_name = "BUSD",
  issuer = "Paxos Trust Company, LLC",
  blockchain = "Ethereum",
  contract_address = "0x4fabb145d64652a948d72533023f6e7a623c7c53",
  regulator = "New York Department of Financial Services (NYDFS)",
  regulatory_guidance = "https://www.dfs.ny.gov/industry_guidance/industry_letters/il20220608_issuance_stablecoins",
  peg = "1:1 USD",
  minting_halted = as.Date("2023-02-13"),
  extraction_date = Sys.Date()
)

# =============================================================================
# PRINT SUMMARIES
# =============================================================================

cat("=== BUSD Attestation Summary ===\n\n")
print(busd_summary)

cat("\n=== Reserve Composition by Date ===\n\n")
print(busd_composition)

cat("\n=== Detailed Holdings ===\n\n")
print(busd_holdings)

cat("\n=== Key Observations ===\n")
cat(sprintf("Supply decreased from %s to %s tokens (%.1f%% redemption)\n",
            format(busd_summary[1, tokens_outstanding], big.mark = ","),
            format(busd_summary[.N, tokens_outstanding], big.mark = ","),
            (1 - busd_summary[.N, tokens_outstanding] / busd_summary[1, tokens_outstanding]) * 100))
cat(sprintf("Overcollateralization range: %.2f%% to %.2f%%\n",
            min(busd_summary$overcollateral_pct),
            max(busd_summary$overcollateral_pct)))
cat(sprintf("Cash buffer range: $%s to $%s\n",
            format(min(busd_holdings[asset_type == "Cash", fair_value_usd]), big.mark = ","),
            format(max(busd_holdings[asset_type == "Cash", fair_value_usd]), big.mark = ",")))
