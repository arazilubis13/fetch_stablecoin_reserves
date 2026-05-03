rm(list=ls())
# data sources
library(fredr)
library(quantmod)
# data manipulation
library(data.table)
library(tidyverse)
# Local Projections 
library(lpirfs)
# plotting
library(ggplot2)
library(scales)
library(patchwork)
library(stargazer)

# FRED (FED FUNDS/TREASURY YIELDS) -----

# Set your FRED API key
fredr_set_key("9aab804ff26c8f2441899013af134cba")

# Define the series IDs for Fed Funds rate and Treasury yields
series_ids <- c(
  "DFF",        # Fed Funds Effective Rate
  "DGS1MO",     # 1-Month Treasury
  "DGS3MO",     # 3-Month Treasury
  "DGS6MO",     # 6-Month Treasury
  "DGS1",       # 1-Year Treasury
  "DGS2",       # 2-Year Treasury
  "DGS10"       # 10-Year Treasury
)

# Define date range
start_date <- as.Date("2021-01-01")
end_date <- as.Date("2025-12-31")

# Pull data from FRED
data_list <- lapply(series_ids, function(id) {
  fredr(
    series_id = id,
    observation_start = start_date,
    observation_end = end_date,
    frequency = "d"  # daily frequency
  )
})

# Combine into a single data.table
dt <- rbindlist(data_list)

# Pivot to wide format with one row per date
dt_wide <- dcast(dt, date ~ series_id, value.var = "value")

# Rename columns for clarity
setnames(dt_wide, 
         old = c("DFF", "DGS1MO", "DGS3MO", "DGS6MO", "DGS1", "DGS2", "DGS10"),
         new = c("fed_funds", "treasury_1m", "treasury_3m", "treasury_6m", 
                 "treasury_1y", "treasury_2y", "treasury_10y"))

# Sort by date
setorder(dt_wide, date)

# View the data
print(dt_wide)

dt_wide <- na.omit(dt_wide)


# Summary statistics (as mentioned in your paper)
summary_stats <- dt_wide[, lapply(.SD, function(x) {
  list(
    mean = mean(x, na.rm = TRUE),
    sd = sd(x, na.rm = TRUE),
    min = min(x, na.rm = TRUE),
    max = max(x, na.rm = TRUE),
    n_obs = sum(!is.na(x))
  )
}), .SDcols = -"date"]

print(summary_stats)

# BTC/ETH -----

# Define ticker symbols
# BTC-USD = Bitcoin
# ETH-USD = Ethereum
tickers <- c("BTC-USD", "ETH-USD")

# Define date range
start_date <- "2021-01-01"
end_date <- "2025-12-31"

# Function to pull data for a single ticker
get_crypto_data <- function(ticker, start, end) {
  tryCatch({
    # Pull data from Yahoo Finance
    data <- getSymbols(ticker, 
                       src = "yahoo", 
                       from = start, 
                       to = end, 
                       auto.assign = FALSE)
    
    # Convert to data.table
    dt <- data.table(
      date = index(data),
      ticker = ticker,
      open = as.numeric(Op(data)),
      high = as.numeric(Hi(data)),
      low = as.numeric(Lo(data)),
      close = as.numeric(Cl(data)),
      volume = as.numeric(Vo(data)),
      adjusted = as.numeric(Ad(data))
    )
    
    return(dt)
  }, error = function(e) {
    message(paste("Error downloading", ticker, ":", e$message))
    return(NULL)
  })
}

# Pull data for all tickers
crypto_list <- lapply(tickers, get_crypto_data, 
                      start = start_date, 
                      end = end_date)

# Combine into single data.table
crypto_dt <- rbindlist(crypto_list)

# Sort by date and ticker
setorder(crypto_dt, date, ticker)

# View the data
print(head(crypto_dt, 20))

# Create wide format with just closing prices (common for analysis)
crypto_wide <- dcast(crypto_dt, date ~ ticker, value.var = "close")

# Rename columns
setnames(crypto_wide, 
         old = c("BTC-USD", "ETH-USD"),
         new = c("btc_price", "eth_price"))

print(head(crypto_wide, 20))

# Summary statistics
summary_stats <- crypto_dt[, .(
  mean_close = mean(close, na.rm = TRUE),
  sd_close = sd(close, na.rm = TRUE),
  min_close = min(close, na.rm = TRUE),
  max_close = max(close, na.rm = TRUE),
  mean_volume = mean(volume, na.rm = TRUE),
  n_obs = .N
), by = ticker]

print(summary_stats)

# Calculate daily returns
crypto_dt[, return := (close / shift(close, 1) - 1) * 100, by = ticker]

# Return statistics
return_stats <- crypto_dt[!is.na(return), .(
  mean_return = mean(return),
  sd_return = sd(return),
  min_return = min(return),
  max_return = max(return)
), by = ticker]

print(return_stats)


# STABLECOINS ----

files = list.files(path="C:/Users/X1 Carbon i7-7500/Dropbox/stablecoins/coingecko/",
                   pattern = ".*-usd-max\\.csv$", full.names = T)

data_list <- lapply(files, function(f) {
  dt <- fread(f)
  dt[, stablecoin := sub(".*/(\\w+)-.*", "\\1", f)]
  dt[, date := as.Date(snapped_at)]
  return(dt)
})

# Combine all data
all_data <- rbindlist(data_list)

all_data = all_data[stablecoin %in% c("usdt", "usdc", "tusd", "busd", "fdusd", "pyusd")]
mcap <- all_data[date >= "2021-01-01", .(sc_mcap = sum(market_cap)/1e9), by = "date"]
mcap[, sc_mcap_flow5d := (sc_mcap - shift(sc_mcap, 5))]
View(mcap)

# Merge all data
df <-  Reduce(function(x, y) merge(x, y, by = "date", all.x = TRUE),
              list(dt_wide, crypto_wide, mcap))

# END DATA CLEANING -----

# PLOT DATA ----

tbill_names = names(df)[grep("treasury", names(df))]

plot_dt <- df[, .SD, .SDcols = c("date", "fed_funds", tbill_names )]
plot_dt = data.table::melt(plot_dt, id.vars = "date", variable.name = "rate_type", 
     value.name = "rate")

p_tbill = ggplot(plot_dt, aes(x=date, y=rate, fill=rate_type, color=rate_type)) + geom_line() +
  labs(title = "Treasury Yields", x = "Date", y = "%", color = NULL) +
  theme_classic() + 
  theme(text=element_text(size=16,  family="CMU Serif"))

p_tbill

plot_dt <- df[, .SD, .SDcols = c("date", "btc_price", "eth_price")]
plot_dt <- data.table::melt(plot_dt, id.vars = "date", 
                            variable.name = "Crypto Asset", 
                            value.name = "price")

p_crypto <- ggplot(plot_dt, aes(x = date, y = price, color = `Crypto Asset`)) +
  geom_line(linewidth = 1) +
  facet_wrap(~ `Crypto Asset`, ncol = 1, scales = "free_y") +
  scale_y_continuous(labels = comma) +
  scale_color_manual(values = c("BTC" = "#F7931A", "ETH" = "#627EEA")) +
  ggtitle("Crypto Prices") +
  xlab("Date") + ylab("Price ($)") +
  theme_classic() +
  theme(
    text = element_text(size = 16, family = "CMU Serif"),
    legend.position = "none"
  )


plot_dt <- df[, c("date", "sc_mcap_flow5d")]

p_sc_mcap_flow <- ggplot(plot_dt, aes(x = date, y = sc_mcap_flow5d)) +
  geom_bar(stat = "identity", width = 5) + 
  labs(title = "Stablecoin Marketcap 5-day Flows", x = "Date", y = "Billions") + 
  theme_classic() +
  theme(
    text = element_text(size = 16, family = "CMU Serif"),
    legend.position = "none",
    
    panel.grid.major = element_line(color = "gray80"),
    panel.grid.minor = element_line(color = "gray90")
    
  )

p_sc_mcap_flow

# Redo Stablecoin Calculation: 

files = list.files(path="C:/Users/X1 Carbon i7-7500/Dropbox/stablecoins/coingecko/",
                   pattern = ".*-usd-max\\.csv$", full.names = T)

data_list <- lapply(files, function(f) {
  dt <- fread(f)
  dt[, stablecoin := sub(".*/(\\w+)-.*", "\\1", f)]
  dt[, date := as.Date(snapped_at)]
  return(dt)
})

# Combine all data
all_data <- rbindlist(data_list)
all_data = all_data[stablecoin %in% c("usdt", "usdc", "tusd", "busd", "fdusd", "pyusd")]


mcap <- all_data[date >= "2021-01-01", .(sc_mcap = sum(market_cap)/1e9), by = c("date", "stablecoin")]
mcap[, sc_mcap_flow5d := (sc_mcap - shift(sc_mcap, 5,type = "lag")), by = "stablecoin"]

mcap_all <- mcap[date >= "2021-01-01", .(sc_mcap_flow5d = sum(sc_mcap_flow5d)), by = "date"]
View(mcap_all)


plot_dt <- mcap_all[, c("date", "sc_mcap_flow5d")]

ggplot(plot_dt, aes(x = date, y = sc_mcap_flow5d)) +
  geom_bar(stat = "identity", width = 5) + 
  labs(title = "Stablecoin Marketcap 5-day Flows", x = "Date", y = "Billions") + 
  theme_classic() +
  theme(
    text = element_text(size = 16, family = "CMU Serif"),
    legend.position = "none",
    
    panel.grid.major = element_line(color = "gray80"),
    panel.grid.minor = element_line(color = "gray90")
    
  )

mcap <- all_data[date >= "2021-01-01", .(sc_mcap = sum(market_cap)/1e9), by = c("date", "stablecoin")]
mcap[, sc_mcap_flow5d := (sc_mcap - shift(sc_mcap, 5)), by = "stablecoin"]
mcap[, stablecoinGroup := dplyr::case_when(stablecoin == "usdt" ~ "USDT",
                                    stablecoin == "usdc" ~ "USDC",
                                    .default = "Other")][, stablecoinGroup := factor(stablecoinGroup, levels = c("USDT", "USDC", "Other"))]

p_sc_mcap_group <- ggplot(mcap, aes(x = date, y = sc_mcap_flow5d, group = stablecoinGroup, fill = stablecoinGroup)) +
  geom_bar(stat = "identity", width = 5) + 
  labs(title = "Stablecoin Marketcap 5-day Flows", x = "Date", y = "Billions", fill = NULL) + 
  theme_classic() +
  theme(
    text = element_text(size = 16, family = "CMU Serif"),
    legend.position = c(0.7, 0.2),
    
    
    panel.grid.major = element_line(color = "gray80"),
    panel.grid.minor = element_line(color = "gray90")
    
  )



# Univariate Local Projections --------------

# Calculate standard deviation of sc_mcap_flow5d
sd_flow <- sd(df$sc_mcap_flow5d, na.rm = TRUE)
cat("Standard deviation of flow:", sd_flow, "\n")
cat("2 SD approximately:", 2 * sd_flow, "\n")
# Create lagged treasury rate
df <- df[!is.na(treasury_3m)]
df[, treasury_3m_lag1 := shift(treasury_3m, 1)]
df = df[date >= "2021-01-11" & date <= "2025-03-14"]


stargazer(df, type = "text")

# Use the manually created lag
# Create leads and lags manually by indexing
df[, treasury_lead1_manual := c(treasury_3m[-1], NA)]
df[, treasury_lag1_manual := c(NA, treasury_3m[-.N])]
df[, treasury_3m_lag1 := treasury_lag1_manual]


# Set up data.table to collect LP estimates. 
lp_results <- data.table(
  horizon = 0:30,
  beta = NA_real_,
  se = NA_real_,
  lower_ci = NA_real_,
  upper_ci = NA_real_,
  pval = NA_real_
)



# Run LP
for (h in 0:30) {
  print(h)
  
  # Create manual lead for horizon h
  if (h == 0) {
    df[, y_h := treasury_3m - treasury_3m_lag1]
  } else {
    # Create h-period ahead lead of treasury yields
    # This removes the first h observations and appends h NAs at the end
    # Example: if h=5 and treasury_3m = [1,2,3,4,5,6,7,8,9,10]
    # treasury_3m[-(1:5)] removes first 5 elements → [6,7,8,9,10]
    # rep(NA, 5) creates 5 NAs → [NA, NA, NA, NA, NA]
    # Combined: [6,7,8,9,10,NA,NA,NA,NA,NA]
    # So row 1 gets value from row 6 (5 days ahead), row 6 gets NA
    df[, treasury_leadh := c(treasury_3m[-(1:h)], rep(NA, h))]
    
    # Calculate dependent variable for local projection
    # y_h represents the change in treasury yield from t-1 to t+h
    # This is the cumulative yield change over the (h+1)-day window
    df[, y_h := treasury_leadh - treasury_3m_lag1]
  }
  
  model <- lm(y_h ~ sc_mcap_flow5d, data = df)
  
  coef_sum <- summary(model)$coefficients
  # Get both confidence intervals
  ci_95 <- confint(model, "sc_mcap_flow5d", level = 0.95)
  ci_67 <- confint(model, "sc_mcap_flow5d", level = 0.67)
  
  lp_results[horizon == h, `:=`(
    beta = coef_sum["sc_mcap_flow5d", "Estimate"],
    se = coef_sum["sc_mcap_flow5d", "Std. Error"],
    pval = coef_sum["sc_mcap_flow5d", "Pr(>|t|)"],
    lower_ci_95 = ci_95[1],
    upper_ci_95 = ci_95[2],
    lower_ci_67 = ci_67[1],
    upper_ci_67 = ci_67[2]
  )]
}
# Scale to $3.5B shock
shock_size <- 3.5  # $3.5 billion
lp_results[, `:=`(
  beta_scaled = beta * shock_size,
  lower_ci_95_scaled = lower_ci_95 * shock_size,
  upper_ci_95_scaled = upper_ci_95 * shock_size,
  lower_ci_67_scaled = lower_ci_67 * shock_size,
  upper_ci_67_scaled = upper_ci_67 * shock_size,
  se_scaled = se * shock_size 
)]

# View results
print(lp_results[, .(horizon, beta_scaled, se_scaled, pval, 
                     lower_ci_95_scaled, upper_ci_95_scaled,
                     lower_ci_67_scaled, upper_ci_67_scaled)])

# Plot scaled results with both CIs
p_irf = ggplot(lp_results, aes(x = horizon, y = beta_scaled)) +
  geom_ribbon(aes(ymin = lower_ci_95_scaled, ymax = upper_ci_95_scaled), 
              alpha = 0.15, fill = "blue") +
  geom_ribbon(aes(ymin = lower_ci_67_scaled, ymax = upper_ci_67_scaled), 
              alpha = 0.3, fill = "blue") +
  geom_line(color = "blue", linewidth = 1) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  geom_point(data = lp_results[pval < 0.05], color = "blue", size = 2) +
  labs(
    title = "Local Projection IRF: Impact of $3.5B Stablecoin Inflow on 3M Treasury",
    subtitle = paste0("Shock size: $3.5B (~", round(shock_size / sd_flow, 1), " SD, where SD = $", round(sd_flow, 2), "B)"),
    x = "Horizon (days)",
    y = expression(Delta ~ "in 3M Treasury Yield (percentage points)"),
    caption = "Shaded areas show 67% (dark) and 95% (light) confidence intervals. Blue dots indicate p < 0.05"
  ) +
  theme_classic() +
  theme(
    plot.title = element_text(size = 12, face = "bold"),
    plot.subtitle = element_text(size = 10),
    
    panel.grid.major = element_line(color = "gray80"),
    panel.grid.minor = element_line(color = "gray90")
    
  )

# Print summary
cat("\n=== SUMMARY ===\n")
cat("Shock size: $3.5B stablecoin inflow\n")
cat("Standard deviation of flow:", round(sd_flow, 2), "B\n")
cat("Shock in SD units:", round(shock_size / sd_flow, 2), "\n\n")
cat("Impact on 3M Treasury yield:\n")
cat("  Immediate (h=0):", round(lp_results[horizon == 0, beta_scaled], 3), "pp\n")
cat("  Peak impact:", round(lp_results[which.max(abs(beta_scaled)), beta_scaled], 3), 
    "pp at horizon", lp_results[which.max(abs(beta_scaled)), horizon], "\n")
cat("  30-day impact:", round(lp_results[horizon == 30, beta_scaled], 3), "pp\n")


# SAVE FIGURES -----

empty_plot = ggplot() + theme_classic()
page1 <- (p_tbill | p_crypto) /
         (p_sc_mcap_flow | p_sc_mcap_group) /
          (p_irf | empty_plot)

cairo_pdf("C:/Users/X1 Carbon i7-7500/Dropbox/stablecoins/output.pdf", 
          width = 10, height = 10)

page1
dev.off()


# LP LP-IRF Package -----

# Create the dependent variable: change in 3-month Treasury
# Δy^3M_{t+h} = y^3M_{t+h} - y^3M_{t-1}
# df[, treasury_3m_lag1 := shift(treasury_3m, 1)]
# df[, delta_treasury_3m := treasury_3m - treasury_3m_lag1]
# 
# # Remove rows with NAs in key variables
# df_clean <- df[!is.na(delta_treasury_3m) & !is.na(sc_mcap_flow5d)]
# 
# # Set up horizons (h = 0 to 30 days)
# horizons <- 0:30
# 
# # Create a data.frame with just the variables you need
# data_for_lp <- data.frame(
#   y = df_clean$delta_treasury_3m,
#   x = df_clean$sc_mcap_flow5d
# )
# 
# 
# endog_data <- df_clean[, .(delta_treasury_3m, sc_mcap_flow5d)]
# 
# # Run local projection
# lp_results <- lp_lin(
#   endog_data = endog_data,
#   lags_endog_lin = 1,
#   trend = 0,
#   shock_type = 0,      # Shock to first variable
#   confint = 1.96,
#   hor = 30
# )
# 
# summary(lp_results)
# 
# # View and plot results
# print(lp_results)
# plot(lp_results)
# 
# 
# # Extract coefficients for each horizon
# irf_table <- data.table(
#   horizon = 0:30,
#   beta = lp_results$irf_lin_mean,
#   lower_ci = lp_results$irf_lin_low,
#   upper_ci = lp_results$irf_lin_up
# )
# 
# print(irf_table)
# 
# # Custom plot
# 
# ggplot(irf_table, aes(x = horizon, y = beta)) +
#   geom_line(color = "blue", size = 1) +
#   geom_ribbon(aes(ymin = lower_ci, ymax = upper_ci), alpha = 0.2, fill = "blue") +
#   geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
#   labs(
#     title = "Local Projection: Impact of Stablecoin Flow on 3-Month Treasury",
#     x = "Horizon (days)",
#     y = "Change in 3M Treasury (bps)",
#     caption = "Shaded area represents 95% confidence interval"
#   ) +
#   theme_classic()