library(data.table)

# Manually enter the data
dt <- data.table(
  Date = c("March 12, 2024", "March 29, 2024", 
           "April 22, 2024", "April 30, 2024",
           "May 16, 2024", "May 31, 2024",
           "June 4, 2024", "June 28, 2024",
           "July 26, 2024", "July 31, 2024",
           "August 27, 2024", "August 30, 2024",
           "September 18, 2024", "September 30, 2024",
           "October 11, 2024", "October 31, 2024"),
  BUSD_Circulation = c(84511464, 84511464,
                       70511464, 70511464,
                       70511464, 70511464,
                       70511464, 70511464,
                       69511464, 69511464,
                       69511464, 69511464,
                       69511464, 69511464,
                       69511464, 68223497),
  Treasury_Securities_RRP = c(85397525, 85598489,
                              71188860, 71272500,
                              71123580, 71280660,
                              71322480, 71250060,
                              70250580, 70256580,
                              70215780, 70246380,
                              70122960, 70236180,
                              70041360, 68912220),
  Cash_USD = c(936035, 935781,
               935938, 935831,
               935984, 935439,
               935597, 935311,
               935457, 936100,
               935383, 935772,
               935696, 935725,
               935567, 935952),
  Total_Redemption_Assets = c(86333560, 86534270,
                              72124798, 72208331,
                              72059564, 72216099,
                              72258077, 72185371,
                              71141037, 71192680,
                              71151163, 71182152,
                              71058656, 71171905,
                              70976927, 69848172)
)

# Calculate over-collateralization
dt[, Over_Collateralization_USD := Total_Redemption_Assets - BUSD_Circulation]
dt[, Over_Collateralization_Pct := round(((Total_Redemption_Assets / BUSD_Circulation) - 1) * 100, 2)]

# Convert date and sort
dt[, Date := as.Date(Date, format = "%B %d, %Y")]
setorder(dt, Date)
dt[, Date := format(Date, "%B %d, %Y")]

# Save to CSV
output_path <- "/mnt/user-data/outputs/busd_reserve_attestations.csv"
fwrite(dt, output_path)

# Print results
cat(sprintf("Total records: %d\n", nrow(dt)))
print(dt)