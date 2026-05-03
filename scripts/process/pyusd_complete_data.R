library(data.table)

# =============================================================================
# DECEMBER 2023 DATA
# =============================================================================

# December 27, 2023 data - No direct UST holdings (all in repo)
dec27_2023_ust_direct <- data.table(
  date = as.Date("2023-12-27"),
  counterparty = character(0),
  asset_type = character(0),
  cusip = character(0),
  maturity_date = as.Date(character(0)),
  par_value = numeric(0),
  unit_cost = numeric(0),
  unit_price = numeric(0),
  cost = numeric(0),
  fair_value = numeric(0)
)

# December 27, 2023 - Repo collateral breakdown
dec27_2023_repo_collateral <- data.table(
  date = as.Date("2023-12-27"),
  counterparty = "Bank 1",
  asset_type = "Repo Collateral",
  cusip = c("91282CCW9", "912810TN8", "912810TP3", "912810TR9"),
  maturity_date = as.Date(c("2026-08-31", "2053-02-15", "2053-02-15", "2053-05-15")),
  par_value = c(500000, 113500000, 93000000, 58500000),
  unit_cost = c(102.02, 102.17, 102.10, 102.11),
  unit_price = c(102.02, 102.17, 102.10, 102.11),
  cost = c(510077, 115965868, 94949679, 59736400),
  fair_value = c(510077, 115965868, 94949679, 59736400)
)

# December 29, 2023 data - No direct UST holdings (all in repo)
dec29_2023_ust_direct <- data.table(
  date = as.Date("2023-12-29"),
  counterparty = character(0),
  asset_type = character(0),
  cusip = character(0),
  maturity_date = as.Date(character(0)),
  par_value = numeric(0),
  unit_cost = numeric(0),
  unit_price = numeric(0),
  cost = numeric(0),
  fair_value = numeric(0)
)

# December 29, 2023 - Repo collateral breakdown
dec29_2023_repo_collateral <- data.table(
  date = as.Date("2023-12-29"),
  counterparty = "Bank 1",
  asset_type = "Repo Collateral",
  cusip = c("9128286F2", "912810QD3", "912810QE1"),
  maturity_date = as.Date(c("2026-02-28", "2039-11-15", "2040-02-15")),
  par_value = c(1085000, 115000000, 149000000),
  unit_cost = c(102.19, 101.87, 102.03),
  unit_price = c(102.19, 101.87, 102.03),
  cost = c(1108775, 117146493, 152015216),
  fair_value = c(1108775, 117146493, 152015216)
)

# =============================================================================
# JANUARY 2024 DATA
# =============================================================================

# January 12, 2024 data - Direct UST holdings (Treasury Bills)
jan12_ust_direct <- data.table(
  date = as.Date("2024-01-12"),
  counterparty = "Direct",
  asset_type = "UST",
  cusip = "912797JF5",
  maturity_date = as.Date("2024-02-27"),
  par_value = 5000000,
  unit_cost = 99.33,
  unit_price = 99.33,
  cost = 4966450,
  fair_value = 4966450
)

# January 12, 2024 - Repo collateral breakdown
jan12_repo_collateral <- data.table(
  date = as.Date("2024-01-12"),
  counterparty = "Bank 1",
  asset_type = "Repo Collateral",
  cusip = c("912810SD1", "912810SE9", "912810SJ8", "912810SP4", "912810SS8"),
  maturity_date = as.Date(c("2048-08-15", "2048-11-15", "2049-08-15", "2050-08-15", "2050-11-15")),
  par_value = c(67000000, 25000000, 102000000, 53500000, 41500000),
  unit_cost = c(101.80, 102.45, 101.52, 102.11, 102.92),
  unit_price = c(101.80, 102.45, 101.52, 102.11, 102.92),
  cost = c(68206471, 25613286, 103545602, 54626868, 42708271),
  fair_value = c(68206471, 25613286, 103545602, 54626868, 42708271)
)

# January 31, 2024 data - Direct UST holdings (Treasury Bills)
jan31_ust_direct <- data.table(
  date = as.Date("2024-01-31"),
  counterparty = "Direct",
  asset_type = "UST",
  cusip = "912797JF5",
  maturity_date = as.Date("2024-02-27"),
  par_value = 5000000,
  unit_cost = 99.61,
  unit_price = 99.61,
  cost = 4980250,
  fair_value = 4980250
)

# January 31, 2024 - Repo collateral breakdown
jan31_repo_collateral <- data.table(
  date = as.Date("2024-01-31"),
  counterparty = "Bank 1",
  asset_type = "Repo Collateral",
  cusip = c("912810SJ8", "912810SK5", "912810SL3", "912810SP4"),
  maturity_date = as.Date(c("2049-08-15", "2049-11-15", "2050-02-15", "2050-08-15")),
  par_value = c(214000000, 26000000, 14500000, 43000000),
  unit_cost = c(101.96, 102.35, 101.83, 102.26),
  unit_price = c(101.96, 102.35, 101.83, 102.26),
  cost = c(218193403, 26612132, 14765039, 43971230),
  fair_value = c(218193403, 26612132, 14765039, 43971230)
)

# =============================================================================
# FEBRUARY 2024 DATA
# =============================================================================

# February 5, 2024 data - Direct UST holdings (Treasury Bills)
feb05_ust_direct <- data.table(
  date = as.Date("2024-02-05"),
  counterparty = "Direct",
  asset_type = "UST",
  cusip = "912797JF5",
  maturity_date = as.Date("2024-02-27"),
  par_value = 5000000,
  unit_cost = 99.69,
  unit_price = 99.69,
  cost = 4984650,
  fair_value = 4984650
)

# February 5, 2024 - Repo collateral breakdown
feb05_repo_collateral <- data.table(
  date = as.Date("2024-02-05"),
  counterparty = "Bank 1",
  asset_type = "Repo Collateral",
  cusip = "912810TV0",
  maturity_date = as.Date("2053-11-15"),
  par_value = 298000000,
  unit_cost = 101.94,
  unit_price = 101.94,
  cost = 303765278,
  fair_value = 303765278
)

# February 29, 2024 data - No direct UST holdings (all in repo)
feb29_ust_direct <- data.table(
  date = as.Date("2024-02-29"),
  counterparty = character(0),
  asset_type = character(0),
  cusip = character(0),
  maturity_date = as.Date(character(0)),
  par_value = numeric(0),
  unit_cost = numeric(0),
  unit_price = numeric(0),
  cost = numeric(0),
  fair_value = numeric(0)
)

# February 29, 2024 - Repo collateral breakdown
feb29_repo_collateral <- data.table(
  date = as.Date("2024-02-29"),
  counterparty = "Bank 1",
  asset_type = "Repo Collateral",
  cusip = c("91282CKB6", "91282CFJ5", "912810SP4", "912810SS8", "912810SX7"),
  maturity_date = as.Date(c("2026-02-28", "2029-08-31", "2050-08-15", "2050-11-15", "2051-05-15")),
  par_value = c(20200000, 14000000, 220000000, 12000000, 37000000),
  unit_cost = c(102.00, 102.00, 102.62, 103.05, 102.71),
  unit_price = c(102.00, 102.00, 102.62, 103.05, 102.71),
  cost = c(20603026, 14280026, 225774817, 12365670, 38002097),
  fair_value = c(20603026, 14280026, 225774817, 12365670, 38002097)
)

# =============================================================================
# MARCH 2024 DATA
# =============================================================================

# March 12, 2024 data - Direct UST holdings (Treasury Bills)
mar12_ust_direct <- data.table(
  date = as.Date("2024-03-12"),
  counterparty = "Direct",
  asset_type = "UST",
  cusip = "912797HS9",
  maturity_date = as.Date("2024-05-30"),
  par_value = 15000000,
  unit_cost = 98.87,
  unit_price = 98.87,
  cost = 14829900,
  fair_value = 14829900
)

# March 12, 2024 - Repo collateral breakdown
mar12_repo_collateral <- data.table(
  date = as.Date("2024-03-12"),
  counterparty = "Bank 1",
  asset_type = "Repo Collateral",
  cusip = c("91282CBC4", "91282CHT1", "912810SY5", "912810SJ8", "912810TT5"),
  maturity_date = as.Date(c("2025-12-31", "2033-08-15", "2041-05-15", "2049-08-15", "2053-08-15")),
  par_value = c(11700000, 11000000, 160000000, 22000000, 2650000),
  unit_cost = c(101.76, 102.00, 102.29, 101.43, 102.60),
  unit_price = c(101.76, 102.00, 102.29, 101.43, 102.60),
  cost = c(11906464, 11220077, 163666094, 22315145, 2718776),
  fair_value = c(11906464, 11220077, 163666094, 22315145, 2718776)
)

# March 29, 2024 data - Direct UST holdings (Treasury Bills)
mar29_ust_direct <- data.table(
  date = as.Date("2024-03-29"),
  counterparty = "Direct",
  asset_type = "UST",
  cusip = "912797HS9",
  maturity_date = as.Date("2024-05-30"),
  par_value = 15000000,
  unit_cost = 99.14,
  unit_price = 99.14,
  cost = 14870700,
  fair_value = 14870700
)

# March 29, 2024 - Repo collateral breakdown
mar29_repo_collateral <- data.table(
  date = as.Date("2024-03-29"),
  counterparty = "Bank 1",
  asset_type = "Repo Collateral",
  cusip = c("91282CBC4", "9128287D6", "912810TX6", "912810TY4"),
  maturity_date = as.Date(c("2025-12-31", "2029-07-15", "2054-02-15", "2054-02-15")),
  par_value = c(9500000, 5000000, 73500000, 86000000),
  unit_cost = c(102.01, 102.00, 102.33, 102.30),
  unit_price = c(102.01, 102.00, 102.33, 102.30),
  cost = c(9691028, 5100034, 75221600, 87978413),
  fair_value = c(9691028, 5100034, 75221600, 87978413)
)

# =============================================================================
# APRIL 2024 DATA
# =============================================================================

# April 22, 2024 data - Direct UST holdings (Treasury Bills)
apr22_ust_direct <- data.table(
  date = as.Date("2024-04-22"),
  counterparty = "Direct",
  asset_type = "UST",
  cusip = "912797HS9",
  maturity_date = as.Date("2024-05-30"),
  par_value = 15000000,
  unit_cost = 99.46,
  unit_price = 99.46,
  cost = 14918700,
  fair_value = 14918700
)

# April 22, 2024 - Repo collateral breakdown
apr22_repo_collateral <- data.table(
  date = as.Date("2024-04-22"),
  counterparty = "Bank 1",
  asset_type = "Repo Collateral",
  cusip = c("912797KS5", "912810TS7", "912810TY4"),
  maturity_date = as.Date(c("2025-04-17", "2043-05-15", "2054-02-15")),
  par_value = c(3500000, 10000000, 175000000),
  unit_cost = c(99.44, 102.00, 102.00),
  unit_price = c(99.44, 102.00, 102.00),
  cost = c(3480240, 10200000, 178500000),
  fair_value = c(3480240, 10200000, 178500000)
)

# April 30, 2024 data - Direct UST holdings (Treasury Bills)
apr30_ust_direct <- data.table(
  date = as.Date("2024-04-30"),
  counterparty = "Direct",
  asset_type = "UST",
  cusip = "912797HS9",
  maturity_date = as.Date("2024-05-30"),
  par_value = 15000000,
  unit_cost = 99.58,
  unit_price = 99.58,
  cost = 14936250,
  fair_value = 14936250
)

# April 30, 2024 - Repo collateral breakdown
apr30_repo_collateral <- data.table(
  date = as.Date("2024-04-30"),
  counterparty = "Bank 1",
  asset_type = "Repo Collateral",
  cusip = c("91282CHH7", "91282CGW5", "912810TY4"),
  maturity_date = as.Date(c("2026-06-15", "2028-04-15", "2054-02-15")),
  par_value = c(7200000, 7000000, 300000000),
  unit_cost = c(101.04, 102.00, 102.00),
  unit_price = c(101.04, 102.00, 102.00),
  cost = c(7274640, 7140000, 306000000),
  fair_value = c(7274640, 7140000, 306000000)
)

# =============================================================================
# MAY 2024 DATA
# =============================================================================

# May 16, 2024 data - Direct UST holdings (Treasury Bills)
may16_ust_direct <- data.table(
  date = as.Date("2024-05-16"),
  counterparty = "Direct",
  asset_type = "UST",
  cusip = "912797KB2",
  maturity_date = as.Date("2024-08-15"),
  par_value = 30000000,
  unit_cost = 98.69,
  unit_price = 98.69,
  cost = 29607000,
  fair_value = 29607000
)

# May 16, 2024 - Repo collateral breakdown
may16_repo_collateral <- data.table(
  date = as.Date("2024-05-16"),
  counterparty = "Bank 1",
  asset_type = "Repo Collateral",
  cusip = c("91282CHB0", "91282CHZ7", "91282CKN0", "912810QU5", "912810TH1", "912810TK4", "912810UA4"),
  maturity_date = as.Date(c("2026-05-15", "2030-09-30", "2031-04-30", "2042-02-15", "2042-05-15", "2042-08-15", "2054-05-15")),
  par_value = c(5500000, 4800000, 200000, 200000000, 36000000, 110000000, 10000000),
  unit_cost = c(100.72, 102.01, 101.84, 102.97, 104.31, 103.30, 100.72),
  unit_price = c(100.72, 102.01, 101.84, 102.97, 104.31, 103.30, 100.72),
  cost = c(5539620, 4896318, 203682, 205942254, 37552600, 113633273, 10071873),
  fair_value = c(5539620, 4896318, 203682, 205942254, 37552600, 113633273, 10071873)
)

# May 31, 2024 data - Direct UST holdings (Treasury Bills)
may31_ust_direct <- data.table(
  date = as.Date("2024-05-31"),
  counterparty = "Direct",
  asset_type = "UST",
  cusip = c("912797JZ1", "912797KB2"),
  maturity_date = as.Date(c("2024-06-04", "2024-08-15")),
  par_value = c(1000, 30000000),
  unit_cost = c(100.00, 98.94),
  unit_price = c(100.00, 98.94),
  cost = c(1000, 29681100),
  fair_value = c(1000, 29681100)
)

# May 31, 2024 - Repo collateral breakdown
may31_repo_collateral <- data.table(
  date = as.Date("2024-05-31"),
  counterparty = "Bank 1",
  asset_type = "Repo Collateral",
  cusip = c("91282CGV7", "91282CBW0", "912810SX7", "912810SZ2", "912810TB4", "912810TD0", "912810TG3"),
  maturity_date = as.Date(c("2026-04-15", "2026-04-30", "2051-05-15", "2051-08-15", "2051-11-15", "2052-02-15", "2052-05-15")),
  par_value = c(4900000, 4400000, 120000000, 7000000, 55000000, 10000000, 220000000),
  unit_cost = c(101.10, 101.68, 100.04, 102.00, 102.93, 100.42, 100.59),
  unit_price = c(101.10, 101.68, 100.04, 102.00, 102.93, 100.42, 100.59),
  cost = c(4953959, 4473901, 120045130, 7140000, 56612764, 10041709, 221300397),
  fair_value = c(4953959, 4473901, 120045130, 7140000, 56612764, 10041709, 221300397)
)

# =============================================================================
# JUNE 2024 DATA
# =============================================================================

# June 4, 2024 data - Direct UST holdings (Treasury Bills)
jun04_ust_direct <- data.table(
  date = as.Date("2024-06-04"),
  counterparty = "Direct",
  asset_type = "UST",
  cusip = "912797KB2",
  maturity_date = as.Date("2024-08-15"),
  par_value = 30000000,
  unit_cost = 98.97,
  unit_price = 98.97,
  cost = 29689500,
  fair_value = 29689500
)

# June 4, 2024 - Repo collateral breakdown
jun04_repo_collateral <- data.table(
  date = as.Date("2024-06-04"),
  counterparty = "Bank 1",
  asset_type = "Repo Collateral",
  cusip = c("91282CEJ6", "91282CFF3", "912810TL2", "912810TN8"),
  maturity_date = as.Date(c("2027-04-15", "2032-08-15", "2052-11-15", "2053-02-15")),
  par_value = c(6500000, 5000000, 95000000, 300000000),
  unit_cost = c(101.81, 102.00, 102.28, 105.31),
  unit_price = c(101.81, 102.00, 102.28, 105.31),
  cost = c(6617760, 5100000, 97168715, 315931285),
  fair_value = c(6617760, 5100000, 97168715, 315931285)
)

# June 28, 2024 data - Direct UST holdings (Treasury Bills)
jun28_ust_direct <- data.table(
  date = as.Date("2024-06-28"),
  counterparty = "Direct",
  asset_type = "UST",
  cusip = c("912797KB2", "912797KM8"),
  maturity_date = as.Date(c("2024-08-15", "2024-09-26")),
  par_value = c(30000000, 20000000),
  unit_cost = c(99.35, 98.74),
  unit_price = c(99.35, 98.74),
  cost = c(29803500, 19747400),
  fair_value = c(29803500, 19747400)
)

# June 28, 2024 - Repo collateral breakdown
jun28_repo_collateral <- data.table(
  date = as.Date("2024-06-28"),
  counterparty = "Bank 1",
  asset_type = "Repo Collateral",
  cusip = c("91282CKK6", "91282CHP9", "91282CJY8"),
  maturity_date = as.Date(c("2026-04-30", "2033-07-15", "2034-01-15")),
  par_value = c(22000000, 380000000, 48000000),
  unit_cost = c(99.53, 99.88, 102.09),
  unit_price = c(99.53, 99.88, 102.09),
  cost = c(21897360, 379546118, 49003822),
  fair_value = c(21897360, 379546118, 49003822)
)

# =============================================================================
# JULY 2024 DATA
# =============================================================================

# July 26, 2024 data - Direct UST holdings (Treasury Bills)
jul26_ust_direct <- data.table(
  date = as.Date("2024-07-26"),
  counterparty = "Direct",
  asset_type = "UST",
  cusip = c("912797KB2", "912797KM8", "912797KT3"),
  maturity_date = as.Date(c("2024-08-15", "2024-09-26", "2024-10-10")),
  par_value = c(30000000, 20000000, 32000000),
  unit_cost = c(99.75, 99.14, 98.95),
  unit_price = c(99.75, 99.14, 98.95),
  cost = c(29925300, 19828200, 31664000),
  fair_value = c(29925300, 19828200, 31664000)
)

# July 26, 2024 - Repo collateral breakdown
jul26_repo_collateral <- data.table(
  date = as.Date("2024-07-26"),
  counterparty = "Bank 1",
  asset_type = "Repo Collateral",
  cusip = c("91282CEQ0", "91282CAQ4", "912810TZ1", "912810RJ9", "912810SA7", "912810SD1", "912810SE9", "912810SH2", "912810SX7"),
  maturity_date = as.Date(c("2025-05-15", "2025-10-15", "2044-02-15", "2044-11-15", "2048-02-15", "2048-08-15", "2048-11-15", "2049-05-15", "2051-05-15")),
  par_value = c(14000000, 8000000, 15000000, 90000000, 35000000, 105000000, 60000000, 35000000, 120000000),
  unit_cost = c(101.61, 100.20, 109.00, 108.30, 111.34, 106.53, 109.82, 111.28, 101.09),
  unit_price = c(101.61, 100.20, 109.00, 108.30, 111.34, 106.53, 109.82, 111.28, 101.09),
  cost = c(14224923, 8016177, 16350137, 97469137, 38970314, 111857629, 65890755, 38949737, 121306712),
  fair_value = c(14224923, 8016177, 16350137, 97469137, 38970314, 111857629, 65890755, 38949737, 121306712)
)

# July 31, 2024 data - Direct UST holdings (Treasury Bills)
jul31_ust_direct <- data.table(
  date = as.Date("2024-07-31"),
  counterparty = "Direct",
  asset_type = "UST",
  cusip = c("912797KB2", "912797KM8", "912797KT3"),
  maturity_date = as.Date(c("2024-08-15", "2024-09-26", "2024-10-10")),
  par_value = c(30000000, 20000000, 32000000),
  unit_cost = c(99.80, 99.18, 99.00),
  unit_price = c(99.80, 99.18, 99.00),
  cost = c(29938500, 19836400, 31678720),
  fair_value = c(29938500, 19836400, 31678720)
)

# July 31, 2024 - Repo collateral breakdown
jul31_repo_collateral <- data.table(
  date = as.Date("2024-07-31"),
  counterparty = "Bank 1",
  asset_type = "Repo Collateral",
  cusip = c("91282CJS1", "912810TU2", "912810TV0"),
  maturity_date = as.Date(c("2025-12-31", "2043-08-15", "2053-11-15")),
  par_value = c(8000000, 520000000, 22000000),
  unit_cost = c(100.32, 100.26, 105.08),
  unit_price = c(100.32, 100.26, 105.08),
  cost = c(8025360, 521343420, 23118300),
  fair_value = c(8025360, 521343420, 23118300)
)

# =============================================================================
# SEPTEMBER 2024 DATA
# =============================================================================

# September 18, 2024 data - Direct UST holdings (Treasury Bills)
sep18_ust_direct <- data.table(
  date = as.Date("2024-09-18"),
  counterparty = "Direct",
  asset_type = "UST",
  cusip = c("912797KL0", "912797KM8", "912797KT3", "912797KU0", "912797LD7", "912797LE5"),
  maturity_date = as.Date(c("2024-09-19", "2024-09-26", "2024-10-10", "2024-10-17", "2024-11-14", "2024-11-21")),
  par_value = c(18000000, 20000000, 32000000, 30000000, 30000000, 20000000),
  unit_cost = c(100.00, 99.91, 99.72, 99.63, 99.27, 99.18),
  unit_price = c(100.00, 99.91, 99.72, 99.63, 99.27, 99.18),
  cost = c(18000000, 19982000, 31911680, 29889900, 29780700, 19836600),
  fair_value = c(18000000, 19982000, 31911680, 29889900, 29780700, 19836600)
)

# September 18, 2024 - Repo collateral breakdown
sep18_repo_collateral <- data.table(
  date = as.Date("2024-09-18"),
  counterparty = "Bank 1",
  asset_type = "Repo Collateral",
  cusip = c("912828S50", "912810UB2"),
  maturity_date = as.Date(c("2026-07-15", "2044-05-15")),
  par_value = c(45000000, 500000000),
  unit_cost = c(97.88, 106.34),
  unit_price = c(97.88, 106.34),
  cost = c(44046660, 531677040),
  fair_value = c(44046660, 531677040)
)

# September 30, 2024 data - Direct UST holdings (Treasury Bills)
sep30_ust_direct <- data.table(
  date = as.Date("2024-09-30"),
  counterparty = "Direct",
  asset_type = "UST",
  cusip = c("912797LK1", "912797KT3", "912797KU0", "912797LD7", "912797LE5"),
  maturity_date = as.Date(c("2024-10-01", "2024-10-10", "2024-10-17", "2024-11-14", "2024-11-21")),
  par_value = c(1000, 32000000, 30000000, 30000000, 20000000),
  unit_cost = c(100.00, 99.88, 99.79, 99.43, 99.34),
  unit_price = c(100.00, 99.88, 99.79, 99.43, 99.34),
  cost = c(1000, 31962880, 29937300, 29829000, 19868800),
  fair_value = c(1000, 31962880, 29937300, 29829000, 19868800)
)

# September 30, 2024 - Repo collateral breakdown
sep30_repo_collateral <- data.table(
  date = as.Date("2024-09-30"),
  counterparty = "Bank 1",
  asset_type = "Repo Collateral",
  cusip = c("91282CJQ5", "912810TA6", "912810SK5", "912810SL3", "912810SM1", "912810SS8", "912810SX7"),
  maturity_date = as.Date(c("2030-12-31", "2041-08-15", "2049-11-15", "2050-02-15", "2050-02-15", "2050-11-15", "2051-05-15")),
  par_value = c(40000000, 1000000, 50000000, 140000000, 50000000, 25000000, 240000000),
  unit_cost = c(106.36, 102.00, 110.63, 109.40, 112.32, 119.43, 103.03),
  unit_price = c(106.36, 102.00, 110.63, 109.40, 112.32, 119.43, 103.03),
  cost = c(42545198, 1020022, 55313446, 153162230, 56160223, 29857422, 247270500),
  fair_value = c(42545198, 1020022, 55313446, 153162230, 56160223, 29857422, 247270500)
)

# =============================================================================
# OCTOBER 2024 DATA
# =============================================================================

# October 11, 2024 data - Direct UST holdings (Treasury Bills)
oct11_ust_direct <- data.table(
  date = as.Date("2024-10-11"),
  counterparty = "Direct",
  asset_type = "UST",
  cusip = c("912797KU0", "912797LD7", "912797LE5"),
  maturity_date = as.Date(c("2024-10-17", "2024-11-14", "2024-11-21")),
  par_value = c(30000000, 30000000, 20000000),
  unit_cost = c(99.97, 99.61, 99.52),
  unit_price = c(99.97, 99.61, 99.52),
  cost = c(29992200, 29882100, 19903200),
  fair_value = c(29992200, 29882100, 19903200)
)

# October 11, 2024 - Repo collateral breakdown
oct11_repo_collateral <- data.table(
  date = as.Date("2024-10-11"),
  counterparty = "Bank 1",
  asset_type = "Repo Collateral",
  cusip = c("91282CBT7", "91282CHB0", "912810SL3", "912810SP4", "912810TJ7", "912810TL2", "912810TY4"),
  maturity_date = as.Date(c("2026-03-31", "2026-05-15", "2050-02-15", "2050-08-15", "2052-08-15", "2052-11-15", "2054-02-15")),
  par_value = c(10000000, 25000000, 20000000, 30000000, 300000000, 40000000, 100000000),
  unit_cost = c(102.00, 99.49, 117.42, 119.59, 103.51, 118.96, 104.08),
  unit_price = c(102.00, 99.49, 117.42, 119.59, 103.51, 118.96, 104.08),
  cost = c(10200000, 24872700, 23484507, 35876467, 310530570, 47585173, 104081923),
  fair_value = c(10200000, 24872700, 23484507, 35876467, 310530570, 47585173, 104081923)
)

# October 31, 2024 data - Direct UST holdings (Treasury Bills)
oct31_ust_direct <- data.table(
  date = as.Date("2024-10-31"),
  counterparty = "Direct",
  asset_type = "UST",
  cusip = c("912797LD7", "912797MC8", "912797LE5"),
  maturity_date = as.Date(c("2024-11-14", "2024-11-19", "2024-11-21")),
  par_value = c(30000000, 30000000, 20000000),
  unit_cost = c(99.83, 99.77, 99.74),
  unit_price = c(99.83, 99.77, 99.74),
  cost = c(29949900, 29930700, 19948800),
  fair_value = c(29949900, 29930700, 19948800)
)

# October 31, 2024 - Repo collateral breakdown
oct31_repo_collateral <- data.table(
  date = as.Date("2024-10-31"),
  counterparty = "Bank 1",
  asset_type = "Repo Collateral",
  cusip = c("91282CCJ8", "91282CJP7", "912810SX7", "912810SZ2", "912810TL2", "912810TR9", "912810TT5", "912810TY4"),
  maturity_date = as.Date(c("2026-06-30", "2026-12-15", "2051-05-15", "2051-08-15", "2052-11-15", "2053-05-15", "2053-08-15", "2054-02-15")),
  par_value = c(15000000, 40000000, 200000000, 25000000, 40000000, 40000000, 60000000, 50000000),
  unit_cost = c(102.00, 98.94, 102.35, 121.67, 96.32, 109.25, 105.70, 100.23),
  unit_price = c(102.00, 98.94, 102.35, 121.67, 96.32, 109.25, 105.70, 100.23),
  cost = c(15300000, 39574980, 204702186, 30418223, 38529683, 43699558, 63422190, 50115940),
  fair_value = c(15300000, 39574980, 204702186, 30418223, 38529683, 43699558, 63422190, 50115940)
)

# =============================================================================
# NOVEMBER 2024 DATA
# =============================================================================

# November 25, 2024 data - Direct UST holdings (none)
nov25_ust_direct <- data.table(
  date = as.Date("2024-11-25"),
  counterparty = character(0),
  asset_type = character(0),
  cusip = character(0),
  maturity_date = as.Date(character(0)),
  par_value = numeric(0),
  unit_cost = numeric(0),
  unit_price = numeric(0),
  cost = numeric(0),
  fair_value = numeric(0)
)

# November 25, 2024 - Repo collateral breakdown
nov25_repo_collateral <- data.table(
  date = as.Date("2024-11-25"),
  counterparty = "Bank 1",
  asset_type = "Repo Collateral",
  cusip = c("91282CKK6", "912810UA4"),
  maturity_date = as.Date(c("2026-04-30", "2054-05-15")),
  par_value = c(55000000, 500000000),
  unit_cost = c(98.73, 102.51),
  unit_price = c(98.73, 102.51),
  cost = c(54301740, 512554080),
  fair_value = c(54301740, 512554080)
)

# November 29, 2024 data - Direct UST holding
nov29_ust_direct <- data.table(
  date = as.Date("2024-11-29"),
  counterparty = "Direct",
  asset_type = "UST",
  cusip = "912797MQ7",
  maturity_date = as.Date("2024-12-24"),
  par_value = 75000000,
  unit_cost = 99.72,
  unit_price = 99.72,
  cost = 74791500,
  fair_value = 74791500
)

# November 29, 2024 - Repo collateral breakdown
nov29_repo_collateral <- data.table(
  date = as.Date("2024-11-29"),
  counterparty = "Bank 1",
  asset_type = "Repo Collateral",
  cusip = c("91282CGT2", "91282CJR3", "91282CLC3", "91282CLJ8"),
  maturity_date = as.Date(c("2028-03-31", "2028-12-31", "2029-07-31", "2031-08-31")),
  par_value = c(370000000, 45000000, 19000000, 10000000),
  unit_cost = c(101.48, 99.99, 100.84, 104.30),
  unit_price = c(101.48, 99.99, 100.84, 104.30),
  cost = c(375493706, 44995641, 19159680, 10430053),
  fair_value = c(375493706, 44995641, 19159680, 10430053)
)

# =============================================================================
# DECEMBER 2024 DATA
# =============================================================================

# December 2, 2024 data - Direct UST holding
dec02_ust_direct <- data.table(
  date = as.Date("2024-12-02"),
  counterparty = "Direct",
  asset_type = "UST",
  cusip = "912797MQ7",
  maturity_date = as.Date("2024-12-24"),
  par_value = 75000000,
  unit_cost = 99.65,
  unit_price = 99.65,
  cost = 74735167,
  fair_value = 74735167
)

# December 2, 2024 - Repo collateral breakdown
dec02_repo_collateral <- data.table(
  date = as.Date("2024-12-02"),
  counterparty = "Bank 1",
  asset_type = "Repo Collateral",
  cusip = c("91282CBT7", "91282CKK6", "912810TL2", "912810TN8", "912810TR9", "912810UA4"),
  maturity_date = as.Date(c("2026-03-31", "2026-04-30", "2052-11-15", "2053-02-15", "2053-05-15", "2054-05-15")),
  par_value = c(10000000, 20000000, 100000000, 40000000, 80000000, 100000000),
  unit_cost = c(102.00, 96.82, 139.57, 110.28, 105.15, 101.89),
  unit_price = c(102.00, 96.82, 139.57, 110.28, 105.15, 101.89),
  cost = c(10200000, 19363680, 139568352, 44111073, 84121341, 101892114),
  fair_value = c(10200000, 19363680, 139568352, 44111073, 84121341, 101892114)
)

# December 31, 2024 - Repo collateral breakdown
dec31_2024_repo_collateral <- data.table(
  date = as.Date("2024-12-31"),
  counterparty = "Bank 1",
  asset_type = "Repo Collateral",
  cusip = c("912810QE1", "912810TU2"),
  maturity_date = as.Date(c("2040-02-15", "2043-08-15")),
  par_value = c(480000000, 6000000),
  unit_cost = c(100.40, 101.39),
  unit_price = c(100.40, 101.39),
  cost = c(481910220, 6083280),
  fair_value = c(481910220, 6083280)
)

# December 31, 2024 - No direct UST holdings
dec31_2024_ust_direct <- data.table(
  date = as.Date("2024-12-31"),
  counterparty = character(0),
  asset_type = character(0),
  cusip = character(0),
  maturity_date = as.Date(character(0)),
  par_value = numeric(0),
  unit_cost = numeric(0),
  unit_price = numeric(0),
  cost = numeric(0),
  fair_value = numeric(0)
)

# =============================================================================
# 2025 DATA (REPO ONLY FORMAT)
# =============================================================================

# January 21, 2025
jan21_2025_repo <- data.table(
  date = as.Date("2025-01-21"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.25,
  maturity_date = as.Date("2025-01-22"),
  par_value = 485299000,
  fair_value = 485299000
)

jan21_2025_ust <- data.table(
  date = as.Date("2025-01-21"),
  counterparty = character(0),
  asset_type = character(0),
  cusip = character(0),
  maturity_date = as.Date(character(0)),
  par_value = numeric(0),
  unit_cost = numeric(0),
  unit_price = numeric(0),
  cost = numeric(0),
  fair_value = numeric(0)
)

# January 31, 2025
jan31_2025_repo <- data.table(
  date = as.Date("2025-01-31"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.32,
  maturity_date = as.Date("2025-02-03"),
  par_value = 455868000,
  fair_value = 455868000
)

jan31_2025_ust <- data.table(
  date = as.Date("2025-01-31"),
  counterparty = character(0),
  asset_type = character(0),
  cusip = character(0),
  maturity_date = as.Date(character(0)),
  par_value = numeric(0),
  unit_cost = numeric(0),
  unit_price = numeric(0),
  cost = numeric(0),
  fair_value = numeric(0)
)

# February 13, 2025
feb13_2025_repo <- data.table(
  date = as.Date("2025-02-13"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.30,
  maturity_date = as.Date("2025-02-14"),
  par_value = 589905000,
  fair_value = 589905000
)

feb13_2025_ust <- data.table(
  date = as.Date("2025-02-13"),
  counterparty = character(0),
  asset_type = character(0),
  cusip = character(0),
  maturity_date = as.Date(character(0)),
  par_value = numeric(0),
  unit_cost = numeric(0),
  unit_price = numeric(0),
  cost = numeric(0),
  fair_value = numeric(0)
)

# February 28, 2025
feb28_2025_repo <- data.table(
  date = as.Date("2025-02-28"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.34,
  maturity_date = as.Date("2025-03-03"),
  par_value = 729955000,
  fair_value = 729955000
)

feb28_2025_ust <- data.table(
  date = as.Date("2025-02-28"),
  counterparty = character(0),
  asset_type = character(0),
  cusip = character(0),
  maturity_date = as.Date(character(0)),
  par_value = numeric(0),
  unit_cost = numeric(0),
  unit_price = numeric(0),
  cost = numeric(0),
  fair_value = numeric(0)
)

# Continue with remaining 2025 data...
# March through December 2025 (same format as document 1)

mar18_2025_repo <- data.table(date = as.Date("2025-03-18"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = 4.28, maturity_date = as.Date("2025-03-19"), par_value = 736518000, fair_value = 736518000)
mar18_2025_ust <- data.table(date = as.Date("2025-03-18"), counterparty = character(0), asset_type = character(0), cusip = character(0), maturity_date = as.Date(character(0)), par_value = numeric(0), unit_cost = numeric(0), unit_price = numeric(0), cost = numeric(0), fair_value = numeric(0))

mar31_2025_repo <- data.table(date = as.Date("2025-03-31"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = 4.36, maturity_date = as.Date("2025-04-01"), par_value = 729349000, fair_value = 729349000)
mar31_2025_ust <- data.table(date = as.Date("2025-03-31"), counterparty = character(0), asset_type = character(0), cusip = character(0), maturity_date = as.Date(character(0)), par_value = numeric(0), unit_cost = numeric(0), unit_price = numeric(0), cost = numeric(0), fair_value = numeric(0))

apr10_2025_repo <- data.table(date = as.Date("2025-04-10"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = 4.32, maturity_date = as.Date("2025-04-11"), par_value = 791216000, fair_value = 791216000)
apr10_2025_ust <- data.table(date = as.Date("2025-04-10"), counterparty = character(0), asset_type = character(0), cusip = character(0), maturity_date = as.Date(character(0)), par_value = numeric(0), unit_cost = numeric(0), unit_price = numeric(0), cost = numeric(0), fair_value = numeric(0))

apr30_2025_repo <- data.table(date = as.Date("2025-04-30"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = 4.35, maturity_date = as.Date("2025-05-01"), par_value = 865610000, fair_value = 865610000)
apr30_2025_ust <- data.table(date = as.Date("2025-04-30"), counterparty = character(0), asset_type = character(0), cusip = character(0), maturity_date = as.Date(character(0)), par_value = numeric(0), unit_cost = numeric(0), unit_price = numeric(0), cost = numeric(0), fair_value = numeric(0))

may08_2025_repo <- data.table(date = as.Date("2025-05-08"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = 4.34, maturity_date = as.Date("2025-05-09"), par_value = 843605000, fair_value = 843605000)
may08_2025_ust <- data.table(date = as.Date("2025-05-08"), counterparty = character(0), asset_type = character(0), cusip = character(0), maturity_date = as.Date(character(0)), par_value = numeric(0), unit_cost = numeric(0), unit_price = numeric(0), cost = numeric(0), fair_value = numeric(0))

may30_2025_repo <- data.table(date = as.Date("2025-05-30"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = 4.31, maturity_date = as.Date("2025-06-02"), par_value = 864661000, fair_value = 864661000)
may30_2025_ust <- data.table(date = as.Date("2025-05-30"), counterparty = character(0), asset_type = character(0), cusip = character(0), maturity_date = as.Date(character(0)), par_value = numeric(0), unit_cost = numeric(0), unit_price = numeric(0), cost = numeric(0), fair_value = numeric(0))

jun09_2025_repo <- data.table(date = as.Date("2025-06-09"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = 4.31, maturity_date = as.Date("2025-06-10"), par_value = 932766000, fair_value = 932766000)
jun09_2025_ust <- data.table(date = as.Date("2025-06-09"), counterparty = character(0), asset_type = character(0), cusip = character(0), maturity_date = as.Date(character(0)), par_value = numeric(0), unit_cost = numeric(0), unit_price = numeric(0), cost = numeric(0), fair_value = numeric(0))

jun30_2025_repo <- data.table(date = as.Date("2025-06-30"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = 4.31, maturity_date = as.Date("2025-07-01"), par_value = 929011000, fair_value = 929011000)
jun30_2025_ust <- data.table(date = as.Date("2025-06-30"), counterparty = character(0), asset_type = character(0), cusip = character(0), maturity_date = as.Date(character(0)), par_value = numeric(0), unit_cost = numeric(0), unit_price = numeric(0), cost = numeric(0), fair_value = numeric(0))

jul08_2025_repo <- data.table(date = as.Date("2025-07-08"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = 4.30, maturity_date = as.Date("2025-07-09"), par_value = 845607000, fair_value = 845607000)
jul08_2025_ust <- data.table(date = as.Date("2025-07-08"), counterparty = character(0), asset_type = character(0), cusip = character(0), maturity_date = as.Date(character(0)), par_value = numeric(0), unit_cost = numeric(0), unit_price = numeric(0), cost = numeric(0), fair_value = numeric(0))

jul31_2025_repo <- data.table(date = as.Date("2025-07-31"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = 4.31, maturity_date = as.Date("2025-08-01"), par_value = 1013469049, fair_value = 1013469049)
jul31_2025_ust <- data.table(date = as.Date("2025-07-31"), counterparty = character(0), asset_type = character(0), cusip = character(0), maturity_date = as.Date(character(0)), par_value = numeric(0), unit_cost = numeric(0), unit_price = numeric(0), cost = numeric(0), fair_value = numeric(0))

aug07_2025_repo <- data.table(date = as.Date("2025-08-07"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = 4.30, maturity_date = as.Date("2025-08-08"), par_value = 919891000, fair_value = 919891000)
aug07_2025_ust <- data.table(date = as.Date("2025-08-07"), counterparty = "Bank 1", asset_type = "UST", cusip = "912797PY7", maturity_date = as.Date("2025-08-14"), par_value = 75000000, unit_cost = 99.20, unit_price = 99.20, cost = 74400000, fair_value = 74400000)

aug29_2025_repo <- data.table(date = as.Date("2025-08-29"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = 4.30, maturity_date = as.Date("2025-09-02"), par_value = 954338000, fair_value = 954338000)
aug29_2025_ust <- data.table(date = as.Date("2025-08-29"), counterparty = "Bank 1", asset_type = "UST", cusip = c("912797QE5", "912797QR6", "912797QT2"), maturity_date = as.Date(c("2025-09-04", "2025-09-25", "2025-10-09")), par_value = c(25000000, 100000000, 50000000), unit_cost = c(99.94, 99.27, 98.87), unit_price = c(99.94, 99.27, 98.87), cost = c(24984000, 99266000, 49435000), fair_value = c(24984000, 99266000, 49553000))

sep08_2025_repo <- data.table(date = as.Date("2025-09-08"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = 4.29, maturity_date = as.Date("2025-09-09"), par_value = 960496000, fair_value = 960496000)
sep08_2025_ust <- data.table(date = as.Date("2025-09-08"), counterparty = "Bank 1", asset_type = "UST", cusip = c("912797QR6", "912797QT2", "912797QU9"), maturity_date = as.Date(c("2025-09-25", "2025-10-09", "2025-10-23")), par_value = c(100000000, 50000000, 25000000), unit_cost = c(99.44, 99.04, 98.63), unit_price = c(99.44, 99.04, 98.63), cost = c(99444000, 49519750, 24656250), fair_value = c(99446750, 49519750, 24656250))

sep30_2025_repo <- data.table(date = as.Date("2025-09-30"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = 4.30, maturity_date = as.Date("2025-10-01"), par_value = 2218270000, fair_value = 2218270000)
sep30_2025_ust <- data.table(date = as.Date("2025-09-30"), counterparty = "Bank 1", asset_type = "UST", cusip = c("912797QT2", "912797QU9", "912797QV7"), maturity_date = as.Date(c("2025-10-09", "2025-10-23", "2025-11-06")), par_value = c(50000000, 25000000, 100000000), unit_cost = c(99.60, 99.19, 98.72), unit_price = c(99.60, 99.19, 98.72), cost = c(49799250, 24797250, 98723500), fair_value = c(49799250, 24797250, 99796750))

oct10_2025_repo <- data.table(date = as.Date("2025-10-10"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = 4.30, maturity_date = as.Date("2025-10-14"), par_value = 2319884000, fair_value = 2319884000)
oct10_2025_ust <- data.table(date = as.Date("2025-10-10"), counterparty = "Bank 1", asset_type = "UST", cusip = c("912797QU9", "912797QV7", "912797QW5"), maturity_date = as.Date(c("2025-10-23", "2025-11-06", "2025-11-13")), par_value = c(25000000, 100000000, 50000000), unit_cost = c(99.72, 99.31, 99.22), unit_price = c(99.72, 99.31, 99.22), cost = c(24929500, 99307500, 49608500), fair_value = c(24929500, 99307500, 50413500))

oct15_2025_repo <- data.table(date = as.Date("2025-10-15"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = 4.29, maturity_date = as.Date("2025-10-16"), par_value = 1875769000, fair_value = 1875769000)
oct15_2025_ust <- data.table(date = as.Date("2025-10-15"), counterparty = "Bank 1", asset_type = "UST", cusip = c("912797QU9", "912797QV7", "912797QW5"), maturity_date = as.Date(c("2025-10-23", "2025-11-06", "2025-11-13")), par_value = c(25000000, 100000000, 50000000), unit_cost = c(99.80, 99.40, 99.30), unit_price = c(99.80, 99.40, 99.30), cost = c(24949000, 99395000, 49652000), fair_value = c(24949000, 99395000, 50344000))

oct31_2025_repo <- data.table(date = as.Date("2025-10-31"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = 4.31, maturity_date = as.Date("2025-11-03"), par_value = 2675270000, fair_value = 2675270000)
oct31_2025_ust <- data.table(date = as.Date("2025-10-31"), counterparty = "Bank 1", asset_type = "UST", cusip = c("912797QW5", "912797QX3", "912797QZ8"), maturity_date = as.Date(c("2025-11-13", "2025-11-20", "2025-12-04")), par_value = c(50000000, 25000000, 25000000), unit_cost = c(99.88, 99.66, 99.28), unit_price = c(99.88, 99.66, 99.28), cost = c(49942920, 24915000, 24820000), fair_value = c(49942920, 24915000, 26034000))

nov10_2025_repo <- data.table(date = as.Date("2025-11-10"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = 4.30, maturity_date = as.Date("2025-11-12"), par_value = 2955915000, fair_value = 2955915000)
nov10_2025_ust <- data.table(date = as.Date("2025-11-10"), counterparty = "Bank 1", asset_type = "UST", cusip = c("912797QW5", "912797QX3", "912797QZ8"), maturity_date = as.Date(c("2025-11-13", "2025-11-20", "2025-12-04")), par_value = c(50000000, 25000000, 25000000), unit_cost = c(99.96, 99.74, 99.36), unit_price = c(99.96, 99.74, 99.36), cost = c(49978890, 24935000, 24840000), fair_value = c(49978890, 24935000, 26075000))

nov28_2025_repo <- data.table(date = as.Date("2025-11-28"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = 4.31, maturity_date = as.Date("2025-12-01"), par_value = 3297460000, fair_value = 3297460000)
nov28_2025_ust <- data.table(date = as.Date("2025-11-28"), counterparty = "Bank 1", asset_type = "UST", cusip = c("912797QZ8", "912797RA2", "912797RB0", "912797RC8", "912797RD6"), maturity_date = as.Date(c("2025-12-04", "2025-12-11", "2025-12-18", "2025-12-26", "2026-01-08")), par_value = c(125000000, 100000000, 100000000, 100000000, 75000000), unit_cost = c(99.81, 99.69, 99.55, 99.38, 99.12), unit_price = c(99.81, 99.69, 99.55, 99.38, 99.12), cost = c(124762500, 99690000, 99550000, 99380000, 74340000), fair_value = c(124762500, 99690000, 99550000, 99380000, 73950000))

dec17_2025_repo <- data.table(date = as.Date("2025-12-17"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = 4.30, maturity_date = as.Date("2025-12-18"), par_value = 3332568000, fair_value = 3332568000)
dec17_2025_ust <- data.table(date = as.Date("2025-12-17"), counterparty = "Bank 1", asset_type = "UST", cusip = c("912797RA2", "912797RB0", "912797RC8", "912797RD6", "912797RE4"), maturity_date = as.Date(c("2025-12-26", "2026-01-02", "2026-01-08", "2026-01-15", "2026-01-22")), par_value = c(100000000, 100000000, 100000000, 100000000, 100000000), unit_cost = c(99.88, 99.79, 99.69, 99.59, 99.48), unit_price = c(99.88, 99.79, 99.69, 99.59, 99.48), cost = c(99884610, 99793000, 99693000, 99592000, 99484000), fair_value = c(99884610, 99793000, 99693000, 99592000, 100348000))

dec31_2025_repo <- data.table(date = as.Date("2025-12-31"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = 4.31, maturity_date = as.Date("2026-01-02"), par_value = 2917823000, fair_value = 2917823000)
dec31_2025_ust <- data.table(date = as.Date("2025-12-31"), counterparty = "Bank 1", asset_type = "UST", cusip = c("912797RD6", "912797RE4", "912797RF1", "912797RG9", "912797RH7", "912797RJ3"), maturity_date = as.Date(c("2026-01-15", "2026-01-22", "2026-01-29", "2026-02-05", "2026-02-12", "2026-02-19")), par_value = c(100000000, 100000000, 100000000, 100000000, 125000000, 100000000), unit_cost = c(99.96, 99.86, 99.75, 99.63, 99.50, 99.37), unit_price = c(99.96, 99.86, 99.75, 99.63, 99.50, 99.37), cost = c(99964620, 99864000, 99754000, 99634000, 124379000, 99374000), fair_value = c(99964620, 99864000, 99754000, 99634000, 124829000, 99374000))

# =============================================================================
# COMBINE ALL DATA
# =============================================================================

# Combine all UST data (direct + repo collateral) for detailed dataset
dec27_2023_ust_combined <- rbind(dec27_2023_ust_direct, dec27_2023_repo_collateral)
dec29_2023_ust_combined <- rbind(dec29_2023_ust_direct, dec29_2023_repo_collateral)
jan12_ust_combined <- rbind(jan12_ust_direct, jan12_repo_collateral)
jan31_ust_combined <- rbind(jan31_ust_direct, jan31_repo_collateral)
feb05_ust_combined <- rbind(feb05_ust_direct, feb05_repo_collateral)
feb29_ust_combined <- rbind(feb29_ust_direct, feb29_repo_collateral)
mar12_ust_combined <- rbind(mar12_ust_direct, mar12_repo_collateral)
mar29_ust_combined <- rbind(mar29_ust_direct, mar29_repo_collateral)
apr22_ust_combined <- rbind(apr22_ust_direct, apr22_repo_collateral)
apr30_ust_combined <- rbind(apr30_ust_direct, apr30_repo_collateral)
may16_ust_combined <- rbind(may16_ust_direct, may16_repo_collateral)
may31_ust_combined <- rbind(may31_ust_direct, may31_repo_collateral)
jun04_ust_combined <- rbind(jun04_ust_direct, jun04_repo_collateral)
jun28_ust_combined <- rbind(jun28_ust_direct, jun28_repo_collateral)
jul26_ust_combined <- rbind(jul26_ust_direct, jul26_repo_collateral)
jul31_ust_combined <- rbind(jul31_ust_direct, jul31_repo_collateral)
sep18_ust_combined <- rbind(sep18_ust_direct, sep18_repo_collateral)
sep30_ust_combined <- rbind(sep30_ust_direct, sep30_repo_collateral)
oct11_ust_combined <- rbind(oct11_ust_direct, oct11_repo_collateral)
oct31_ust_combined <- rbind(oct31_ust_direct, oct31_repo_collateral)
nov25_ust_combined <- rbind(nov25_ust_direct, nov25_repo_collateral)
nov29_ust_combined <- rbind(nov29_ust_direct, nov29_repo_collateral)
dec02_ust_combined <- rbind(dec02_ust_direct, dec02_repo_collateral)
dec31_2024_ust_combined <- rbind(dec31_2024_ust_direct, dec31_2024_repo_collateral)

# For the summary repo tables (aggregate level)
dec27_2023_repo <- data.table(date = as.Date("2023-12-27"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = NA_real_, maturity_date = as.Date(NA), par_value = sum(dec27_2023_repo_collateral$par_value), fair_value = sum(dec27_2023_repo_collateral$fair_value))
dec29_2023_repo <- data.table(date = as.Date("2023-12-29"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = NA_real_, maturity_date = as.Date(NA), par_value = sum(dec29_2023_repo_collateral$par_value), fair_value = sum(dec29_2023_repo_collateral$fair_value))
jan12_repo <- data.table(date = as.Date("2024-01-12"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = NA_real_, maturity_date = as.Date(NA), par_value = sum(jan12_repo_collateral$par_value), fair_value = sum(jan12_repo_collateral$fair_value))
jan31_repo <- data.table(date = as.Date("2024-01-31"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = NA_real_, maturity_date = as.Date(NA), par_value = sum(jan31_repo_collateral$par_value), fair_value = sum(jan31_repo_collateral$fair_value))
feb05_repo <- data.table(date = as.Date("2024-02-05"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = NA_real_, maturity_date = as.Date(NA), par_value = sum(feb05_repo_collateral$par_value), fair_value = sum(feb05_repo_collateral$fair_value))
feb29_repo <- data.table(date = as.Date("2024-02-29"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = NA_real_, maturity_date = as.Date(NA), par_value = sum(feb29_repo_collateral$par_value), fair_value = sum(feb29_repo_collateral$fair_value))
mar12_repo <- data.table(date = as.Date("2024-03-12"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = NA_real_, maturity_date = as.Date(NA), par_value = sum(mar12_repo_collateral$par_value), fair_value = sum(mar12_repo_collateral$fair_value))
mar29_repo <- data.table(date = as.Date("2024-03-29"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = NA_real_, maturity_date = as.Date(NA), par_value = sum(mar29_repo_collateral$par_value), fair_value = sum(mar29_repo_collateral$fair_value))
apr22_repo <- data.table(date = as.Date("2024-04-22"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = NA_real_, maturity_date = as.Date(NA), par_value = sum(apr22_repo_collateral$par_value), fair_value = sum(apr22_repo_collateral$fair_value))
apr30_repo <- data.table(date = as.Date("2024-04-30"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = NA_real_, maturity_date = as.Date(NA), par_value = sum(apr30_repo_collateral$par_value), fair_value = sum(apr30_repo_collateral$fair_value))
may16_repo <- data.table(date = as.Date("2024-05-16"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = NA_real_, maturity_date = as.Date(NA), par_value = sum(may16_repo_collateral$par_value), fair_value = sum(may16_repo_collateral$fair_value))
may31_repo <- data.table(date = as.Date("2024-05-31"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = NA_real_, maturity_date = as.Date(NA), par_value = sum(may31_repo_collateral$par_value), fair_value = sum(may31_repo_collateral$fair_value))
jun04_repo <- data.table(date = as.Date("2024-06-04"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = NA_real_, maturity_date = as.Date(NA), par_value = sum(jun04_repo_collateral$par_value), fair_value = sum(jun04_repo_collateral$fair_value))
jun28_repo <- data.table(date = as.Date("2024-06-28"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = NA_real_, maturity_date = as.Date(NA), par_value = sum(jun28_repo_collateral$par_value), fair_value = sum(jun28_repo_collateral$fair_value))
jul26_repo <- data.table(date = as.Date("2024-07-26"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = NA_real_, maturity_date = as.Date(NA), par_value = sum(jul26_repo_collateral$par_value), fair_value = sum(jul26_repo_collateral$fair_value))
jul31_repo <- data.table(date = as.Date("2024-07-31"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = NA_real_, maturity_date = as.Date(NA), par_value = sum(jul31_repo_collateral$par_value), fair_value = sum(jul31_repo_collateral$fair_value))
sep18_repo <- data.table(date = as.Date("2024-09-18"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = NA_real_, maturity_date = as.Date(NA), par_value = sum(sep18_repo_collateral$par_value), fair_value = sum(sep18_repo_collateral$fair_value))
sep30_repo <- data.table(date = as.Date("2024-09-30"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = NA_real_, maturity_date = as.Date(NA), par_value = sum(sep30_repo_collateral$par_value), fair_value = sum(sep30_repo_collateral$fair_value))
oct11_repo <- data.table(date = as.Date("2024-10-11"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = NA_real_, maturity_date = as.Date(NA), par_value = sum(oct11_repo_collateral$par_value), fair_value = sum(oct11_repo_collateral$fair_value))
oct31_repo <- data.table(date = as.Date("2024-10-31"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = NA_real_, maturity_date = as.Date(NA), par_value = sum(oct31_repo_collateral$par_value), fair_value = sum(oct31_repo_collateral$fair_value))
nov25_repo <- data.table(date = as.Date("2024-11-25"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = NA_real_, maturity_date = as.Date(NA), par_value = sum(nov25_repo_collateral$par_value), fair_value = sum(nov25_repo_collateral$fair_value))
nov29_repo <- data.table(date = as.Date("2024-11-29"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = NA_real_, maturity_date = as.Date(NA), par_value = sum(nov29_repo_collateral$par_value), fair_value = sum(nov29_repo_collateral$fair_value))
dec02_repo <- data.table(date = as.Date("2024-12-02"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = NA_real_, maturity_date = as.Date(NA), par_value = sum(dec02_repo_collateral$par_value), fair_value = sum(dec02_repo_collateral$fair_value))
dec31_2024_repo <- data.table(date = as.Date("2024-12-31"), counterparty = "Bank 1", asset_type = "Repo", collateral = "US Treasury", coupon_rate = NA_real_, maturity_date = as.Date(NA), par_value = sum(dec31_2024_repo_collateral$par_value), fair_value = sum(dec31_2024_repo_collateral$fair_value))

# Create comprehensive detailed UST dataset
pyusd_ust_detailed <- rbind(
  dec27_2023_ust_combined, dec29_2023_ust_combined,
  jan12_ust_combined, jan31_ust_combined,
  feb05_ust_combined, feb29_ust_combined,
  mar12_ust_combined, mar29_ust_combined,
  apr22_ust_combined, apr30_ust_combined,
  may16_ust_combined, may31_ust_combined,
  jun04_ust_combined, jun28_ust_combined,
  jul26_ust_combined, jul31_ust_combined,
  sep18_ust_combined, sep30_ust_combined,
  oct11_ust_combined, oct31_ust_combined,
  nov25_ust_combined, nov29_ust_combined,
  dec02_ust_combined, dec31_2024_ust_combined,
  jan21_2025_ust, jan31_2025_ust, feb13_2025_ust, feb28_2025_ust, 
  mar18_2025_ust, mar31_2025_ust, apr10_2025_ust, apr30_2025_ust, 
  may08_2025_ust, may30_2025_ust, jun09_2025_ust, jun30_2025_ust,
  jul08_2025_ust, jul31_2025_ust, aug07_2025_ust, aug29_2025_ust, 
  sep08_2025_ust, sep30_2025_ust, oct10_2025_ust, oct15_2025_ust, 
  oct31_2025_ust, nov10_2025_ust, nov28_2025_ust, dec17_2025_ust, dec31_2025_ust
)

# Create comprehensive repo summary dataset
pyusd_repo <- rbind(
  dec27_2023_repo, dec29_2023_repo,
  jan12_repo, jan31_repo, feb05_repo, feb29_repo,
  mar12_repo, mar29_repo, apr22_repo, apr30_repo, 
  may16_repo, may31_repo, jun04_repo, jun28_repo, 
  jul26_repo, jul31_repo, sep18_repo, sep30_repo, 
  oct11_repo, oct31_repo, nov25_repo, nov29_repo, 
  dec02_repo, dec31_2024_repo, 
  jan21_2025_repo, jan31_2025_repo, feb13_2025_repo, feb28_2025_repo, 
  mar18_2025_repo, mar31_2025_repo, apr10_2025_repo, apr30_2025_repo, 
  may08_2025_repo, may30_2025_repo, jun09_2025_repo, jun30_2025_repo, 
  jul08_2025_repo, jul31_2025_repo, aug07_2025_repo, aug29_2025_repo, 
  sep08_2025_repo, sep30_2025_repo, oct10_2025_repo, oct15_2025_repo, 
  oct31_2025_repo, nov10_2025_repo, nov28_2025_repo, dec17_2025_repo, dec31_2025_repo
)

# =============================================================================
# AGGREGATE SUMMARY TABLES
# =============================================================================

# PYUSD Circulation Data
pyusd_circulation <- data.table(
  date = as.Date(c("2023-12-27", "2023-12-29",
                   "2024-01-12", "2024-01-31", "2024-02-05", "2024-02-29", 
                   "2024-03-12", "2024-03-29", "2024-04-22", "2024-04-30", 
                   "2024-05-16", "2024-05-31", "2024-06-04", "2024-06-28", 
                   "2024-07-26", "2024-07-31", "2024-09-18", "2024-09-30", 
                   "2024-10-11", "2024-10-31", "2024-11-25", "2024-11-29", 
                   "2024-12-02", "2024-12-31", "2025-01-21", "2025-01-31", 
                   "2025-02-13", "2025-02-28", "2025-03-18", "2025-03-31", 
                   "2025-04-10", "2025-04-30", "2025-05-08", "2025-05-30", 
                   "2025-06-09", "2025-06-30", "2025-07-08", "2025-07-31", 
                   "2025-08-07", "2025-08-29", "2025-09-08", "2025-09-30", 
                   "2025-10-10", "2025-10-15", "2025-10-31", "2025-11-10", 
                   "2025-11-28", "2025-12-17", "2025-12-31")),
  circulation = c(266046276, 264531846,
                  294908727, 301175241, 301175241, 304427933, 
                  222078294, 188485924, 202658227, 328083118, 
                  407447577, 454251277, 454509726, 510204106, 
                  599457546, 638945680, 736144505, 720152403, 
                  688115348, 583791579, 580018838, 551145414, 
                  495033046, 509395838, 511788197, 484456701, 
                  618455536, 753544744, 763245917, 747497079, 
                  813787542, 890506892, 872344019, 909579635, 
                  1001959216, 953684788, 892852832, 1040131414, 
                  1025702501, 1173383198, 1179945591, 2437877550, 
                  2556003250, 2652728424, 2824669787, 3130442608, 
                  3858115385, 3874530474, 3617530827)
)

# PYUSD Treasury Holdings (total UST including direct + repo collateral)
pyusd_ust <- data.table(
  date = as.Date(c("2023-12-27", "2023-12-29",
                   "2024-01-12", "2024-01-31", "2024-02-05", "2024-02-29", 
                   "2024-03-12", "2024-03-29", "2024-04-22", "2024-04-30", 
                   "2024-05-16", "2024-05-31", "2024-06-04", "2024-06-28", 
                   "2024-07-26", "2024-07-31", "2024-09-18", "2024-09-30", 
                   "2024-10-11", "2024-10-31", "2024-11-25", "2024-11-29", 
                   "2024-12-02", "2024-12-31", "2025-01-21", "2025-01-31", 
                   "2025-02-13", "2025-02-28", "2025-03-18", "2025-03-31", 
                   "2025-04-10", "2025-04-30", "2025-05-08", "2025-05-30", 
                   "2025-06-09", "2025-06-30", "2025-07-08", "2025-07-31", 
                   "2025-08-07", "2025-08-29", "2025-09-08", "2025-09-30", 
                   "2025-10-10", "2025-10-15", "2025-10-31", "2025-11-10", 
                   "2025-11-28", "2025-12-17", "2025-12-31")),
  ust_holdings = c(271162025, 270270484,
                   299666948, 308521803, 308749928, 311025637,
                   226656456, 192861776, 207098940, 335350890,
                   407446620, 453250278, 454507260, 500254200,
                   594453000, 633941100, 725123780, 696751020,
                   636337840, 565590980, 566855820, 524870580,
                   473991727, 487993500, 485299000, 455868000,
                   589905000, 729955000, 736518000, 729349000,
                   791216000, 865610000, 843605000, 864661000,
                   932766000, 929011000, 845607000, 1013469049,
                   994291000, 1128141000, 1134468750, 2392663250,
                   2494534500, 2050457000, 2776161920, 3056903890,
                   3794792500, 3831878610, 3542242620)
)

print("PYUSD data loaded successfully!")
print(paste("Detailed UST dataset rows:", nrow(pyusd_ust_detailed)))
print(paste("Repo summary dataset rows:", nrow(pyusd_repo)))
print(paste("Circulation data rows:", nrow(pyusd_circulation)))
print(paste("UST holdings summary rows:", nrow(pyusd_ust)))
