library(data.table)
library(stringr)
library(ggplot2)

files = list.files(path="C:/Users/X1 Carbon i7-7500/Dropbox/stablecoins/aavescan/",
                   pattern = ".csv", full.names = T)


data_list <- lapply(files, function(f) {
  dt <- fread(f)
  dt[, stablecoin := str_extract(f, "(?<=ethereum-)[^-]+(?=-history)")]
  dt[, date := as.Date(targetDate)]
  return(dt)
})


# Combine all data
all_data <- rbindlist(data_list)

ggplot(data=all_data, mapping=aes(x=date, y=currentVariableBorrowRate, color=symbol, group=symbol))+ 
  geom_line() + 
  labs(title="Aave Ethereum Borrowing rates of Stablecoins",
       x="Date",y="%", color=NULL) + 
  theme_classic()+
  theme(legend.position = c(0.2, 0.9),family="CMU Serif")
####################################################


get_sofr_data <- function(start_date = "2020-01-01", 
                          end_date = Sys.Date(), 
                          rate_type = "rate") {
  
  base_url <- "https://markets.newyorkfed.org/api/rates/secured/sofr/search.csv"
  
  # Construct URL
  api_url <- sprintf("%s?startDate=%s&endDate=%s&type=%s",
                     base_url, start_date, end_date, rate_type)
  
  # Pull data
  dt <- fread(api_url)
  
  # Clean column names
  clean_names <- function(names) {
    names <- tolower(names)                          # Convert to lowercase
    names <- gsub("percentile", "pct", names)        # Shorten percentile to pct
    names <- gsub("\\s*\\(%\\)", "", names)          # Remove (%)
    names <- gsub("\\s*\\(\\$billions\\)", "", names) # Remove ($Billions)
    names <- gsub("\\s*\\(y/n\\)", "", names)        # Remove (Y/N)
    names <- gsub("\\s+", "_", names)                # Replace spaces with underscores
    names <- gsub("1st", "1", names)                 # Clean ordinals
    names <- gsub("25th", "25", names)
    names <- gsub("75th", "75", names)
    names <- gsub("99th", "99", names)
    names <- gsub("30-day", "30day", names)          # Remove hyphens in day averages
    names <- gsub("90-day", "90day", names)
    names <- gsub("180-day", "180day", names)
    names <- gsub("-", "_", names)                   # Replace remaining hyphens
    names <- gsub("_+", "_", names)                  # Remove multiple underscores
    names <- gsub("^_|_$", "", names)                # Remove leading/trailing underscores
    return(names)
  }
  
  setnames(dt, clean_names(names(dt)))
  
  # Convert date column
  dt[, effective_date := as.Date(effective_date, format="%m/%d/%Y")]
  
  # Sort by date
  setorder(dt, effective_date)
  
  return(dt)
}

# Use the function
sofr_data <- get_sofr_data(start_date = "2020-01-01", 
                           end_date = "2025-12-01")

names(sofr_data)

plot_sofr = data.table::melt(sofr_data, id.vars='effective_date', 
                 measure.vars=c("1_pct", "25_pct", 
                                "rate","75_pct", "99_pct"),
                 variable.name="percentile",
                 value.name='value')

ggplot(data=plot_sofr, aes(x=effective_date,y=value,color=percentile,grou=percentile)) + 
  geom_line() + 
  labs(title="SOFR Rates",
       x="Date", y="%", color=NULL) + 
  theme_classic() + 
  theme(legend.position=c(0.2, 0.9),
        family="CMU Serif")


