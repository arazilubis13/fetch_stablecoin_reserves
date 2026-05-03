library(data.table)

# May 8, 2025 data
may08_repo <- data.table(
  date = as.Date("2025-05-08"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.26,
  maturity_date = as.Date("2025-05-09"),
  par_value = 843605000,
  fair_value = 843605000
)

may08_ust <- data.table(
  date = as.Date("2025-05-08"),
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

# May 30, 2025 data
may30_repo <- data.table(
  date = as.Date("2025-05-30"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.31,
  maturity_date = as.Date("2025-06-02"),
  par_value = 864661000,
  fair_value = 864661000
)

may30_ust <- data.table(
  date = as.Date("2025-05-30"),
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

# June 9, 2025 data
jun09_repo <- data.table(
  date = as.Date("2025-06-09"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.25,
  maturity_date = as.Date("2025-06-10"),
  par_value = 932766000,
  fair_value = 932766000
)

jun09_ust <- data.table(
  date = as.Date("2025-06-09"),
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

# June 30, 2025 data
jun30_repo <- data.table(
  date = as.Date("2025-06-30"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.38,
  maturity_date = as.Date("2025-07-01"),
  par_value = 929011000,
  fair_value = 929011000
)

jun30_ust <- data.table(
  date = as.Date("2025-06-30"),
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

# July 8, 2025 data
jul08_repo <- data.table(
  date = as.Date("2025-07-08"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.30,
  maturity_date = as.Date("2025-07-09"),
  par_value = 845607000,
  fair_value = 845607000
)

jul08_ust <- data.table(
  date = as.Date("2025-07-08"),
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

# July 31, 2025 data
jul31_repo <- data.table(
  date = as.Date("2025-07-31"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.33,
  maturity_date = as.Date("2025-08-01"),
  par_value = 1013469049,
  fair_value = 1013469049
)

jul31_ust <- data.table(
  date = as.Date("2025-07-31"),
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

# August 7, 2025 data
aug07_repo <- data.table(
  date = as.Date("2025-08-07"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.30,
  maturity_date = as.Date("2025-08-08"),
  par_value = 919891000,
  fair_value = 919891000
)

aug07_ust <- data.table(
  date = as.Date("2025-08-07"),
  counterparty = "Bank 1",
  asset_type = "UST",
  cusip = "912797QF7",
  maturity_date = as.Date("2025-10-16"),
  par_value = 75000000,
  unit_cost = 99.17,
  unit_price = 99.20,
  cost = 74378750,
  fair_value = 74400000
)

# August 29, 2025 data
aug29_repo <- data.table(
  date = as.Date("2025-08-29"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.30,
  maturity_date = as.Date("2025-09-02"),
  par_value = 954338000,
  fair_value = 954338000
)

aug29_ust <- data.table(
  date = as.Date("2025-08-29"),
  counterparty = c("Bank 1", "Bank 1"),
  asset_type = "UST",
  cusip = c("912797QF7", "912797QQ3"),
  maturity_date = as.Date(c("2025-10-16", "2025-11-13")),
  par_value = c(75000000, 100000000),
  unit_cost = c(99.17, 99.01),
  unit_price = c(99.49, 99.18),
  cost = c(74378750, 99014106),
  fair_value = c(74619000, 99184000)
)

# September 8, 2025 data
sep08_repo <- data.table(
  date = as.Date("2025-09-08"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.36,
  maturity_date = as.Date("2025-09-09"),
  par_value = 960496000,
  fair_value = 960496000
)

sep08_ust <- data.table(
  date = as.Date("2025-09-08"),
  counterparty = c("Bank 1", "Bank 1"),
  asset_type = "UST",
  cusip = c("912797QF7", "912797QQ3"),
  maturity_date = as.Date(c("2025-10-16", "2025-11-13")),
  par_value = c(75000000, 100000000),
  unit_cost = c(99.17, 99.01),
  unit_price = c(99.58, 99.29),
  cost = c(74378750, 99014106),
  fair_value = c(74685750, 99287000)
)

# September 30, 2025 data
sep30_repo <- data.table(
  date = as.Date("2025-09-30"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.18,
  maturity_date = as.Date("2025-10-01"),
  par_value = 2218270000,
  fair_value = 2218270000
)

sep30_ust <- data.table(
  date = as.Date("2025-09-30"),
  counterparty = c("Bank 1", "Bank 1"),
  asset_type = "UST",
  cusip = c("912797QF7", "912797QQ3"),
  maturity_date = as.Date(c("2025-10-16", "2025-11-13")),
  par_value = c(75000000, 100000000),
  unit_cost = c(99.17, 99.01),
  unit_price = c(99.83, 99.52),
  cost = c(74378750, 99014106),
  fair_value = c(74873250, 99520000)
)

# October 10, 2025 data
oct10_repo <- data.table(
  date = as.Date("2025-10-10"),
  counterparty = c("Bank 1", "Bank 2"),
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = c(4.05, 4.12),
  maturity_date = as.Date("2025-10-14"),
  par_value = c(2218884000, 101000000),
  fair_value = c(2218884000, 101000000)
)

oct10_ust <- data.table(
  date = as.Date("2025-10-10"),
  counterparty = c("Bank 1", "Bank 1"),
  asset_type = "UST",
  cusip = c("912797QF7", "912797QQ3"),
  maturity_date = as.Date(c("2025-10-16", "2025-11-13")),
  par_value = c(75000000, 100000000),
  unit_cost = c(99.17, 99.01),
  unit_price = c(99.98, 99.68),
  cost = c(74378750, 99014106),
  fair_value = c(74983500, 99667000)
)

# October 15, 2025 data
oct15_repo <- data.table(
  date = as.Date("2025-10-15"),
  counterparty = c("Bank 1", "Bank 2"),
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = c(4.22, 4.25),
  maturity_date = as.Date("2025-10-16"),
  par_value = c(1609700000, 266069000),
  fair_value = c(1609700000, 266069000)
)

oct15_ust <- data.table(
  date = as.Date("2025-10-15"),
  counterparty = c("Bank 1", "Bank 1"),
  asset_type = "UST",
  cusip = c("912797QF7", "912797QQ3"),
  maturity_date = as.Date(c("2025-10-16", "2025-11-13")),
  par_value = c(75000000, 100000000),
  unit_cost = c(99.17, 99.01),
  unit_price = c(100.00, 99.69),
  cost = c(74378750, 99014106),
  fair_value = c(75000000, 99688000)
)

# October 31, 2025 data
oct31_repo <- data.table(
  date = as.Date("2025-10-31"),
  counterparty = c("Bank 1", "Bank 2"),
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = c(4.14, 4.14),
  maturity_date = as.Date("2025-11-03"),
  par_value = c(2100270000, 575000000),
  fair_value = c(2100270000, 575000000)
)

oct31_ust <- data.table(
  date = as.Date("2025-10-31"),
  counterparty = c("Bank 1", "Bank 2"),
  asset_type = "UST",
  cusip = c("912797QQ3", "912797QQ3"),
  maturity_date = as.Date("2025-11-13"),
  par_value = c(100000000, 1000000),
  unit_cost = c(99.01, 99.86),
  unit_price = c(99.89, 99.89),
  cost = c(99014106, 998615),
  fair_value = c(99893000, 998920)
)

# November 10, 2025 data
nov10_repo <- data.table(
  date = as.Date("2025-11-10"),
  counterparty = c("Bank 1", "Bank 1", "Bank 2"),
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = c(3.85, 3.92, 3.90),
  maturity_date = as.Date("2025-11-12"),
  par_value = c(300000000, 2081075000, 574840000),
  fair_value = c(300000000, 2081075000, 574840000)
)

nov10_ust <- data.table(
  date = as.Date("2025-11-10"),
  counterparty = c("Bank 1", "Bank 2"),
  asset_type = "UST",
  cusip = c("912797QQ3", "US912797QQ39"),
  maturity_date = as.Date("2025-11-13"),
  par_value = c(100000000, 1000000),
  unit_cost = c(99.01, 99.86),
  unit_price = c(99.99, 99.99),
  cost = c(99014106, 998615),
  fair_value = c(99989000, 999890)
)

# November 28, 2025 data
nov28_repo <- data.table(
  date = as.Date("2025-11-28"),
  counterparty = c("Bank 1", "Bank 1", "Bank 2"),
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = c(4.06, 3.80, 4.06),
  maturity_date = as.Date("2025-12-01"),
  par_value = c(2178213000, 85747000, 1033500000),
  fair_value = c(2178213000, 85747000, 1033500000)
)

nov28_ust <- data.table(
  date = as.Date("2025-11-28"),
  counterparty = c("Bank 1", "Bank 1"),
  asset_type = "UST",
  cusip = c("912797RL3", "912797SE8"),
  maturity_date = as.Date(c("2026-02-05", "2026-01-06")),
  par_value = c(250000000, 250000000),
  unit_cost = c(99.11, 99.41),
  unit_price = c(99.31, 99.62),
  cost = c(247765799, 248536771),
  fair_value = c(248282500, 249050000)
)

# December 17, 2025 data
dec17_repo <- data.table(
  date = as.Date("2025-12-17"),
  counterparty = c("Bank 1", "Bank 1", "Bank 2"),
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = c(3.64, 3.58, 3.64),
  maturity_date = as.Date("2025-12-18"),
  par_value = c(2138281000, 62157000, 1132130000),
  fair_value = c(2138281000, 62157000, 1132130000)
)

dec17_ust <- data.table(
  date = as.Date("2025-12-17"),
  counterparty = c("Bank 1", "Bank 1", "Bank 2"),
  asset_type = "UST",
  cusip = c("912797RL3", "912797SE8", "912797SE8"),
  maturity_date = as.Date(c("2026-02-05", "2026-01-06", "2026-01-06")),
  par_value = c(250000000, 250000000, 1000000),
  unit_cost = c(99.11, 99.41, 99.80),
  unit_price = c(99.51, 99.81, 99.81),
  cost = c(247765799, 248536771, 997992),
  fair_value = c(248785000, 249527500, 998110)
)

# December 31, 2025 data
dec31_repo <- data.table(
  date = as.Date("2025-12-31"),
  counterparty = c("Bank 1", "Bank 1", "Bank 2"),
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = c(3.80, 3.50, 3.80),
  maturity_date = as.Date("2026-01-02"),
  par_value = c(1782180000, 126215000, 1009428000),
  fair_value = c(1782180000, 126215000, 1009428000)
)

dec31_ust <- data.table(
  date = as.Date("2025-12-31"),
  counterparty = c("Bank 1", "Bank 1", "Bank 2", "Bank 2"),
  asset_type = "UST",
  cusip = c("912797RL3", "912797SE8", "912797SE8", "912797SS7"),
  maturity_date = as.Date(c("2026-02-05", "2026-01-06", "2026-01-06", "2026-02-24")),
  par_value = c(250000000, 250000000, 1000000, 125000000),
  unit_cost = c(99.11, 99.41, 99.80, 99.44),
  unit_price = c(99.67, 99.96, 99.96, 99.48),
  cost = c(247765799, 248536771, 997992, 124303889),
  fair_value = c(249165000, 249905000, 999620, 124350000)
)

# Combine all data
pyusd_repo <- rbind(may08_repo, may30_repo, jun09_repo, jun30_repo, jul08_repo, jul31_repo, 
                    aug07_repo, aug29_repo, sep08_repo, sep30_repo, oct10_repo, oct15_repo, 
                    oct31_repo, nov10_repo, nov28_repo, dec17_repo, dec31_repo)

pyusd_ust <- rbind(may08_ust, may30_ust, jun09_ust, jun30_ust, jul08_ust, jul31_ust, 
                   aug07_ust, aug29_ust, sep08_ust, sep30_ust, oct10_ust, oct15_ust, 
                   oct31_ust, nov10_ust, nov28_ust, dec17_ust, dec31_ust)

# Total assets summary
total_assets <- data.table(
  date = as.Date(c("2025-05-08", "2025-05-30", "2025-06-09", "2025-06-30", "2025-07-08", 
                   "2025-07-31", "2025-08-07", "2025-08-29", "2025-09-08", "2025-09-30", 
                   "2025-10-10", "2025-10-15", "2025-10-31", "2025-11-10", "2025-11-28", 
                   "2025-12-17", "2025-12-31")),
  cash = c(28739019, 44918635, 69193216, 24673788, 47245832, 26662365, 31411501, 45242198, 
           45476841, 45214300, 61468750, 602271424, 48507867, 73538718, 63322885, 42651864, 
           75288207),
  repo = c(843605000, 864661000, 932766000, 929011000, 845607000, 1013469049, 919891000, 
           954338000, 960496000, 2218270000, 2319884000, 1875769000, 2675270000, 2955915000, 
           3297460000, 3332568000, 2917823000),
  ust = c(0, 0, 0, 0, 0, 0, 74400000, 173803000, 173972750, 174393250, 174650500, 174688000, 
          100891920, 100988890, 497332500, 499310610, 624419620),
  total = c(872344019, 909579635, 1001959216, 953684788, 892852832, 1040131414, 1025702501, 
            1173383198, 1179945591, 2437877550, 2556003250, 2652728424, 2824669787, 
            3130442608, 3858115385, 3874530474, 3617530827)
)


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

# Combine October UST data (direct + repo collateral)
oct11_ust_combined <- rbind(oct11_ust_direct, oct11_repo_collateral)
oct31_ust_combined <- rbind(oct31_ust_direct, oct31_repo_collateral)

# For the summary repo tables (aggregate level)
oct11_repo <- data.table(
  date = as.Date("2024-10-11"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = NA_real_,
  maturity_date = as.Date(NA),
  par_value = sum(oct11_repo_collateral$par_value),
  fair_value = sum(oct11_repo_collateral$fair_value)
)

oct31_repo <- data.table(
  date = as.Date("2024-10-31"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = NA_real_,
  maturity_date = as.Date(NA),
  par_value = sum(oct31_repo_collateral$par_value),
  fair_value = sum(oct31_repo_collateral$fair_value)
)

# Update pyusd_ust_detailed to include October data
pyusd_ust_detailed <- rbind(
  oct11_ust_combined,
  oct31_ust_combined,
  nov25_ust_combined,
  nov29_ust_combined,
  dec02_ust_combined,
  dec31_ust_combined,
  jan21_ust, jan31_ust, feb13_ust, feb28_ust, mar18_ust, mar31_ust,
  apr10_ust, apr30_ust, may08_ust, may30_ust, jun09_ust, jun30_ust,
  jul08_ust, jul31_ust, aug07_ust, aug29_ust, sep08_ust, sep30_ust,
  oct10_ust, oct15_ust, oct31_ust, nov10_ust, nov28_ust, dec17_ust, dec31_ust
)

# Update summary tables
pyusd_repo <- rbind(oct11_repo, oct31_repo, nov25_repo, nov29_repo, dec02_repo, dec31_repo, 
                    jan21_repo, jan31_repo, feb13_repo, feb28_repo, mar18_repo, mar31_repo, 
                    apr10_repo, apr30_repo, may08_repo, may30_repo, jun09_repo, jun30_repo, 
                    jul08_repo, jul31_repo, aug07_repo, aug29_repo, sep08_repo, sep30_repo, 
                    oct10_repo, oct15_repo, oct31_repo, nov10_repo, nov28_repo, dec17_repo, 
                    dec31_repo)

# Update total assets summary
total_assets <- data.table(
  date = as.Date(c("2024-10-11", "2024-10-31", "2024-11-25", "2024-11-29", "2024-12-02", 
                   "2024-12-31", "2025-01-21", "2025-01-31", "2025-02-13", "2025-02-28", 
                   "2025-03-18", "2025-03-31", "2025-04-10", "2025-04-30", "2025-05-08", 
                   "2025-05-30", "2025-06-09", "2025-06-30", "2025-07-08", "2025-07-31", 
                   "2025-08-07", "2025-08-29", "2025-09-08", "2025-09-30", "2025-10-10", 
                   "2025-10-15", "2025-10-31", "2025-11-10", "2025-11-28", "2025-12-17", 
                   "2025-12-31")),
  cash = c(51706508, 18199419, 13163018, 26274834, 21041319, 21402338, 26489197, 28588701, 
           28550536, 23589744, 26727917, 18148079, 22571542, 24896892, 28739019, 44918635, 
           69193216, 24673788, 47245832, 26662365, 31411501, 45242198, 45476841, 45214300, 
           61468750, 602271424, 48507867, 73538718, 63322885, 42651864, 75288207),
  repo = c(556631340, 485762760, 566855820, 450079080, 399256560, 487993500, 485299000, 
           455868000, 589905000, 729955000, 736518000, 729349000, 791216000, 865610000, 
           843605000, 864661000, 932766000, 929011000, 845607000, 1013469049, 919891000, 
           954338000, 960496000, 2218270000, 2319884000, 1875769000, 2675270000, 2955915000, 
           3297460000, 3332568000, 2917823000),
  ust = c(79777500, 79829400, 0, 74791500, 74735167, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
          0, 0, 74400000, 173803000, 173972750, 174393250, 174650500, 174688000, 100891920, 
          100988890, 497332500, 499310610, 624419620),
  total = c(688115348, 583791579, 580018838, 551145414, 495033046, 509395838, 511788197, 
            484456701, 618455536, 753544744, 763245917, 747497079, 813787542, 890506892, 
            872344019, 909579635, 1001959216, 953684788, 892852832, 1040131414, 1025702501, 
            1173383198, 1179945591, 2437877550, 2556003250, 2652728424, 2824669787, 
            3130442608, 3858115385, 3874530474, 3617530827)
)