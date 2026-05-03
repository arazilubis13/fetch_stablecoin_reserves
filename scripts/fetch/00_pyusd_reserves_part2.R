library(data.table)

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

# Combine September UST data (direct + repo collateral)
sep18_ust_combined <- rbind(sep18_ust_direct, sep18_repo_collateral)
sep30_ust_combined <- rbind(sep30_ust_direct, sep30_repo_collateral)

# For the summary repo tables (aggregate level)
sep18_repo <- data.table(
  date = as.Date("2024-09-18"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = NA_real_,
  maturity_date = as.Date(NA),
  par_value = sum(sep18_repo_collateral$par_value),
  fair_value = sum(sep18_repo_collateral$fair_value)
)

sep30_repo <- data.table(
  date = as.Date("2024-09-30"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = NA_real_,
  maturity_date = as.Date(NA),
  par_value = sum(sep30_repo_collateral$par_value),
  fair_value = sum(sep30_repo_collateral$fair_value)
)

# Update pyusd_ust_detailed to include September data
pyusd_ust_detailed <- rbind(
  sep18_ust_combined,
  sep30_ust_combined,
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
pyusd_repo <- rbind(sep18_repo, sep30_repo, oct11_repo, oct31_repo, nov25_repo, nov29_repo, 
                    dec02_repo, dec31_repo, jan21_repo, jan31_repo, feb13_repo, feb28_repo, 
                    mar18_repo, mar31_repo, apr10_repo, apr30_repo, may08_repo, may30_repo, 
                    jun09_repo, jun30_repo, jul08_repo, jul31_repo, aug07_repo, aug29_repo, 
                    sep08_repo, sep30_repo, oct10_repo, oct15_repo, oct31_repo, nov10_repo, 
                    nov28_repo, dec17_repo, dec31_repo)

# Update total assets summary
total_assets <- data.table(
  date = as.Date(c("2024-09-18", "2024-09-30", "2024-10-11", "2024-10-31", "2024-11-25", 
                   "2024-11-29", "2024-12-02", "2024-12-31", "2025-01-21", "2025-01-31", 
                   "2025-02-13", "2025-02-28", "2025-03-18", "2025-03-31", "2025-04-10", 
                   "2025-04-30", "2025-05-08", "2025-05-30", "2025-06-09", "2025-06-30", 
                   "2025-07-08", "2025-07-31", "2025-08-07", "2025-08-29", "2025-09-08", 
                   "2025-09-30", "2025-10-10", "2025-10-15", "2025-10-31", "2025-11-10", 
                   "2025-11-28", "2025-12-17", "2025-12-31")),
  cash = c(11019925, 23224383, 51706508, 18199419, 13163018, 26274834, 21041319, 21402338, 
           26489197, 28588701, 28550536, 23589744, 26727917, 18148079, 22571542, 24896892, 
           28739019, 44918635, 69193216, 24673788, 47245832, 26662365, 31411501, 45242198, 
           45476841, 45214300, 61468750, 602271424, 48507867, 73538718, 63322885, 42651864, 
           75288207),
  repo = c(575723700, 585329040, 556631340, 485762760, 566855820, 450079080, 399256560, 
           487993500, 485299000, 455868000, 589905000, 729955000, 736518000, 729349000, 
           791216000, 865610000, 843605000, 864661000, 932766000, 929011000, 845607000, 
           1013469049, 919891000, 954338000, 960496000, 2218270000, 2319884000, 1875769000, 
           2675270000, 2955915000, 3297460000, 3332568000, 2917823000),
  ust = c(149400880, 111598980, 79777500, 79829400, 0, 74791500, 74735167, 0, 0, 0, 0, 0, 0, 
          0, 0, 0, 0, 0, 0, 0, 0, 0, 74400000, 173803000, 173972750, 174393250, 174650500, 
          174688000, 100891920, 100988890, 497332500, 499310610, 624419620),
  total = c(736144505, 720152403, 688115348, 583791579, 580018838, 551145414, 495033046, 
            509395838, 511788197, 484456701, 618455536, 753544744, 763245917, 747497079, 
            813787542, 890506892, 872344019, 909579635, 1001959216, 953684788, 892852832, 
            1040131414, 1025702501, 1173383198, 1179945591, 2437877550, 2556003250, 
            2652728424, 2824669787, 3130442608, 3858115385, 3874530474, 3617530827)
)

##########################################################

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

# December 2, 2024 - Repo collateral breakdown (Treasury securities held in reverse repo)
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
dec31_repo_collateral <- data.table(
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
dec31_ust_direct <- data.table(
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

# January 21, 2025 data
jan21_repo <- data.table(
  date = as.Date("2025-01-21"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.25,
  maturity_date = as.Date("2025-01-22"),
  par_value = 485299000,
  fair_value = 485299000
)

jan21_ust <- data.table(
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

# January 31, 2025 data
jan31_repo <- data.table(
  date = as.Date("2025-01-31"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.32,
  maturity_date = as.Date("2025-02-03"),
  par_value = 455868000,
  fair_value = 455868000
)

jan31_ust <- data.table(
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

# February 13, 2025 data
feb13_repo <- data.table(
  date = as.Date("2025-02-13"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.30,
  maturity_date = as.Date("2025-02-14"),
  par_value = 589905000,
  fair_value = 589905000
)

feb13_ust <- data.table(
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

# February 28, 2025 data
feb28_repo <- data.table(
  date = as.Date("2025-02-28"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.34,
  maturity_date = as.Date("2025-03-03"),
  par_value = 729955000,
  fair_value = 729955000
)

feb28_ust <- data.table(
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

# March 18, 2025 data
mar18_repo <- data.table(
  date = as.Date("2025-03-18"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.28,
  maturity_date = as.Date("2025-03-19"),
  par_value = 736518000,
  fair_value = 736518000
)

mar18_ust <- data.table(
  date = as.Date("2025-03-18"),
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

# March 31, 2025 data
mar31_repo <- data.table(
  date = as.Date("2025-03-31"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.36,
  maturity_date = as.Date("2025-04-01"),
  par_value = 729349000,
  fair_value = 729349000
)

mar31_ust <- data.table(
  date = as.Date("2025-03-31"),
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

# April 10, 2025 data
apr10_repo <- data.table(
  date = as.Date("2025-04-10"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.32,
  maturity_date = as.Date("2025-04-11"),
  par_value = 791216000,
  fair_value = 791216000
)

apr10_ust <- data.table(
  date = as.Date("2025-04-10"),
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

# April 30, 2025 data
apr30_repo <- data.table(
  date = as.Date("2025-04-30"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.35,
  maturity_date = as.Date("2025-05-01"),
  par_value = 865610000,
  fair_value = 865610000
)

apr30_ust <- data.table(
  date = as.Date("2025-04-30"),
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

# May 8, 2025 data
may08_repo <- data.table(
  date = as.Date("2025-05-08"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.34,
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
  coupon_rate = 4.31,
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
  coupon_rate = 4.31,
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
  coupon_rate = 4.31,
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
  cusip = "912797PY7",
  maturity_date = as.Date("2025-08-14"),
  par_value = 75000000,
  unit_cost = 99.20,
  unit_price = 99.20,
  cost = 74400000,
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
  counterparty = "Bank 1",
  asset_type = "UST",
  cusip = c("912797QE5", "912797QR6", "912797QT2"),
  maturity_date = as.Date(c("2025-09-04", "2025-09-25", "2025-10-09")),
  par_value = c(25000000, 100000000, 50000000),
  unit_cost = c(99.94, 99.27, 98.87),
  unit_price = c(99.94, 99.27, 98.87),
  cost = c(24984000, 99266000, 49435000),
  fair_value = c(24984000, 99266000, 49553000)
)

# September 8, 2025 data
sep08_repo <- data.table(
  date = as.Date("2025-09-08"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.29,
  maturity_date = as.Date("2025-09-09"),
  par_value = 960496000,
  fair_value = 960496000
)

sep08_ust <- data.table(
  date = as.Date("2025-09-08"),
  counterparty = "Bank 1",
  asset_type = "UST",
  cusip = c("912797QR6", "912797QT2", "912797QU9"),
  maturity_date = as.Date(c("2025-09-25", "2025-10-09", "2025-10-23")),
  par_value = c(100000000, 50000000, 25000000),
  unit_cost = c(99.44, 99.04, 98.63),
  unit_price = c(99.44, 99.04, 98.63),
  cost = c(99444000, 49519750, 24656250),
  fair_value = c(99446750, 49519750, 24656250)
)

# September 30, 2025 data
sep30_repo <- data.table(
  date = as.Date("2025-09-30"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.30,
  maturity_date = as.Date("2025-10-01"),
  par_value = 2218270000,
  fair_value = 2218270000
)

sep30_ust <- data.table(
  date = as.Date("2025-09-30"),
  counterparty = "Bank 1",
  asset_type = "UST",
  cusip = c("912797QT2", "912797QU9", "912797QV7"),
  maturity_date = as.Date(c("2025-10-09", "2025-10-23", "2025-11-06")),
  par_value = c(50000000, 25000000, 100000000),
  unit_cost = c(99.60, 99.19, 98.72),
  unit_price = c(99.60, 99.19, 98.72),
  cost = c(49799250, 24797250, 98723500),
  fair_value = c(49799250, 24797250, 99796750)
)

# October 10, 2025 data
oct10_repo <- data.table(
  date = as.Date("2025-10-10"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.30,
  maturity_date = as.Date("2025-10-14"),
  par_value = 2319884000,
  fair_value = 2319884000
)

oct10_ust <- data.table(
  date = as.Date("2025-10-10"),
  counterparty = "Bank 1",
  asset_type = "UST",
  cusip = c("912797QU9", "912797QV7", "912797QW5"),
  maturity_date = as.Date(c("2025-10-23", "2025-11-06", "2025-11-13")),
  par_value = c(25000000, 100000000, 50000000),
  unit_cost = c(99.72, 99.31, 99.22),
  unit_price = c(99.72, 99.31, 99.22),
  cost = c(24929500, 99307500, 49608500),
  fair_value = c(24929500, 99307500, 50413500)
)

# October 15, 2025 data
oct15_repo <- data.table(
  date = as.Date("2025-10-15"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.29,
  maturity_date = as.Date("2025-10-16"),
  par_value = 1875769000,
  fair_value = 1875769000
)

oct15_ust <- data.table(
  date = as.Date("2025-10-15"),
  counterparty = "Bank 1",
  asset_type = "UST",
  cusip = c("912797QU9", "912797QV7", "912797QW5"),
  maturity_date = as.Date(c("2025-10-23", "2025-11-06", "2025-11-13")),
  par_value = c(25000000, 100000000, 50000000),
  unit_cost = c(99.80, 99.40, 99.30),
  unit_price = c(99.80, 99.40, 99.30),
  cost = c(24949000, 99395000, 49652000),
  fair_value = c(24949000, 99395000, 50344000)
)

# October 31, 2025 data
oct31_repo <- data.table(
  date = as.Date("2025-10-31"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.31,
  maturity_date = as.Date("2025-11-03"),
  par_value = 2675270000,
  fair_value = 2675270000
)

oct31_ust <- data.table(
  date = as.Date("2025-10-31"),
  counterparty = "Bank 1",
  asset_type = "UST",
  cusip = c("912797QW5", "912797QX3", "912797QZ8"),
  maturity_date = as.Date(c("2025-11-13", "2025-11-20", "2025-12-04")),
  par_value = c(50000000, 25000000, 25000000),
  unit_cost = c(99.88, 99.66, 99.28),
  unit_price = c(99.88, 99.66, 99.28),
  cost = c(49942920, 24915000, 24820000),
  fair_value = c(49942920, 24915000, 26034000)
)

# November 10, 2025 data
nov10_repo <- data.table(
  date = as.Date("2025-11-10"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.30,
  maturity_date = as.Date("2025-11-12"),
  par_value = 2955915000,
  fair_value = 2955915000
)

nov10_ust <- data.table(
  date = as.Date("2025-11-10"),
  counterparty = "Bank 1",
  asset_type = "UST",
  cusip = c("912797QW5", "912797QX3", "912797QZ8"),
  maturity_date = as.Date(c("2025-11-13", "2025-11-20", "2025-12-04")),
  par_value = c(50000000, 25000000, 25000000),
  unit_cost = c(99.96, 99.74, 99.36),
  unit_price = c(99.96, 99.74, 99.36),
  cost = c(49978890, 24935000, 24840000),
  fair_value = c(49978890, 24935000, 26075000)
)

# November 28, 2025 data
nov28_repo <- data.table(
  date = as.Date("2025-11-28"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.31,
  maturity_date = as.Date("2025-12-01"),
  par_value = 3297460000,
  fair_value = 3297460000
)

nov28_ust <- data.table(
  date = as.Date("2025-11-28"),
  counterparty = "Bank 1",
  asset_type = "UST",
  cusip = c("912797QZ8", "912797RA2", "912797RB0", "912797RC8", "912797RD6"),
  maturity_date = as.Date(c("2025-12-04", "2025-12-11", "2025-12-18", "2025-12-26", "2026-01-08")),
  par_value = c(125000000, 100000000, 100000000, 100000000, 75000000),
  unit_cost = c(99.81, 99.69, 99.55, 99.38, 99.12),
  unit_price = c(99.81, 99.69, 99.55, 99.38, 99.12),
  cost = c(124762500, 99690000, 99550000, 99380000, 74340000),
  fair_value = c(124762500, 99690000, 99550000, 99380000, 73950000)
)

# December 17, 2025 data
dec17_repo <- data.table(
  date = as.Date("2025-12-17"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.30,
  maturity_date = as.Date("2025-12-18"),
  par_value = 3332568000,
  fair_value = 3332568000
)

dec17_ust <- data.table(
  date = as.Date("2025-12-17"),
  counterparty = "Bank 1",
  asset_type = "UST",
  cusip = c("912797RA2", "912797RB0", "912797RC8", "912797RD6", "912797RE4"),
  maturity_date = as.Date(c("2025-12-26", "2026-01-02", "2026-01-08", "2026-01-15", "2026-01-22")),
  par_value = c(100000000, 100000000, 100000000, 100000000, 100000000),
  unit_cost = c(99.88, 99.79, 99.69, 99.59, 99.48),
  unit_price = c(99.88, 99.79, 99.69, 99.59, 99.48),
  cost = c(99884610, 99793000, 99693000, 99592000, 99484000),
  fair_value = c(99884610, 99793000, 99693000, 99592000, 100348000)
)

# December 31, 2025 data
dec31_repo <- data.table(
  date = as.Date("2025-12-31"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = 4.31,
  maturity_date = as.Date("2026-01-02"),
  par_value = 2917823000,
  fair_value = 2917823000
)

dec31_ust <- data.table(
  date = as.Date("2025-12-31"),
  counterparty = "Bank 1",
  asset_type = "UST",
  cusip = c("912797RD6", "912797RE4", "912797RF1", "912797RG9", "912797RH7", "912797RJ3"),
  maturity_date = as.Date(c("2026-01-15", "2026-01-22", "2026-01-29", "2026-02-05", "2026-02-12", "2026-02-19")),
  par_value = c(100000000, 100000000, 100000000, 100000000, 125000000, 100000000),
  unit_cost = c(99.96, 99.86, 99.75, 99.63, 99.50, 99.37),
  unit_price = c(99.96, 99.86, 99.75, 99.63, 99.50, 99.37),
  cost = c(99964620, 99864000, 99754000, 99634000, 124379000, 99374000),
  fair_value = c(99964620, 99864000, 99754000, 99634000, 124829000, 99374000)
)

# Combine all UST data (direct + repo collateral) for detailed dataset
sep18_ust_combined <- rbind(sep18_ust_direct, sep18_repo_collateral)
sep30_ust_combined <- rbind(sep30_ust_direct, sep30_repo_collateral)
oct11_ust_combined <- rbind(oct11_ust_direct, oct11_repo_collateral)
oct31_ust_combined <- rbind(oct31_ust_direct, oct31_repo_collateral)
nov25_ust_combined <- rbind(nov25_ust_direct, nov25_repo_collateral)
nov29_ust_combined <- rbind(nov29_ust_direct, nov29_repo_collateral)
dec02_ust_combined <- rbind(dec02_ust_direct, dec02_repo_collateral)
dec31_ust_combined <- rbind(dec31_ust_direct, dec31_repo_collateral)

# For the summary repo tables (aggregate level)
sep18_repo <- data.table(
  date = as.Date("2024-09-18"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = NA_real_,
  maturity_date = as.Date(NA),
  par_value = sum(sep18_repo_collateral$par_value),
  fair_value = sum(sep18_repo_collateral$fair_value)
)

sep30_repo <- data.table(
  date = as.Date("2024-09-30"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = NA_real_,
  maturity_date = as.Date(NA),
  par_value = sum(sep30_repo_collateral$par_value),
  fair_value = sum(sep30_repo_collateral$fair_value)
)

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

nov25_repo <- data.table(
  date = as.Date("2024-11-25"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = NA_real_,
  maturity_date = as.Date(NA),
  par_value = sum(nov25_repo_collateral$par_value),
  fair_value = sum(nov25_repo_collateral$fair_value)
)

nov29_repo <- data.table(
  date = as.Date("2024-11-29"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = NA_real_,
  maturity_date = as.Date(NA),
  par_value = sum(nov29_repo_collateral$par_value),
  fair_value = sum(nov29_repo_collateral$fair_value)
)

dec02_repo <- data.table(
  date = as.Date("2024-12-02"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = NA_real_,
  maturity_date = as.Date(NA),
  par_value = sum(dec02_repo_collateral$par_value),
  fair_value = sum(dec02_repo_collateral$fair_value)
)

dec31_repo <- data.table(
  date = as.Date("2024-12-31"),
  counterparty = "Bank 1",
  asset_type = "Repo",
  collateral = "US Treasury",
  coupon_rate = NA_real_,
  maturity_date = as.Date(NA),
  par_value = sum(dec31_repo_collateral$par_value),
  fair_value = sum(dec31_repo_collateral$fair_value)
)

# Create comprehensive detailed UST dataset
pyusd_ust_detailed <- rbind(
  sep18_ust_combined,
  sep30_ust_combined,
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

# Create comprehensive repo summary dataset
pyusd_repo <- rbind(
  sep18_repo, sep30_repo, oct11_repo, oct31_repo, nov25_repo, nov29_repo, 
  dec02_repo, dec31_repo, jan21_repo, jan31_repo, feb13_repo, feb28_repo, 
  mar18_repo, mar31_repo, apr10_repo, apr30_repo, may08_repo, may30_repo, 
  jun09_repo, jun30_repo, jul08_repo, jul31_repo, aug07_repo, aug29_repo, 
  sep08_repo, sep30_repo, oct10_repo, oct15_repo, oct31_repo, nov10_repo, 
  nov28_repo, dec17_repo, dec31_repo
)

# Create total assets summary table
total_assets <- data.table(
  date = as.Date(c("2024-09-18", "2024-09-30", "2024-10-11", "2024-10-31", "2024-11-25", 
                   "2024-11-29", "2024-12-02", "2024-12-31", "2025-01-21", "2025-01-31", 
                   "2025-02-13", "2025-02-28", "2025-03-18", "2025-03-31", "2025-04-10", 
                   "2025-04-30", "2025-05-08", "2025-05-30", "2025-06-09", "2025-06-30", 
                   "2025-07-08", "2025-07-31", "2025-08-07", "2025-08-29", "2025-09-08", 
                   "2025-09-30", "2025-10-10", "2025-10-15", "2025-10-31", "2025-11-10", 
                   "2025-11-28", "2025-12-17", "2025-12-31")),
  cash = c(11019925, 23224383, 51706508, 18199419, 13163018, 26274834, 21041319, 21402338, 
           26489197, 28588701, 28550536, 23589744, 26727917, 18148079, 22571542, 24896892, 
           28739019, 44918635, 69193216, 24673788, 47245832, 26662365, 31411501, 45242198, 
           45476841, 45214300, 61468750, 602271424, 48507867, 73538718, 63322885, 42651864, 
           75288207),
  repo = c(575723700, 585329040, 556631340, 485762760, 566855820, 450079080, 399256560, 
           487993500, 485299000, 455868000, 589905000, 729955000, 736518000, 729349000, 
           791216000, 865610000, 843605000, 864661000, 932766000, 929011000, 845607000, 
           1013469049, 919891000, 954338000, 960496000, 2218270000, 2319884000, 1875769000, 
           2675270000, 2955915000, 3297460000, 3332568000, 2917823000),
  ust = c(149400880, 111598980, 79777500, 79829400, 0, 74791500, 74735167, 0, 0, 0, 0, 0, 0, 
          0, 0, 0, 0, 0, 0, 0, 0, 0, 74400000, 173803000, 173972750, 174393250, 174650500, 
          174688000, 100891920, 100988890, 497332500, 499310610, 624419620),
  total = c(736144505, 720152403, 688115348, 583791579, 580018838, 551145414, 495033046, 
            509395838, 511788197, 484456701, 618455536, 753544744, 763245917, 747497079, 
            813787542, 890506892, 872344019, 909579635, 1001959216, 953684788, 892852832, 
            1040131414, 1025702501, 1173383198, 1179945591, 2437877550, 2556003250, 
            2652728424, 2824669787, 3130442608, 3858115385, 3874530474, 3617530827)
)