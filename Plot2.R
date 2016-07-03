rm(list=ls())
# setwd("~/Analytics Course/03_ExploratoryDataAnalysis/Project")

# libraries
library(dplyr)
library(lubridate)

# File has header, and separater is ;
# NA strings are currently encoded as "?" and need to be converted to NA.
d_raw <- read.table("household_power_consumption.txt", 
                    header = TRUE, sep = ";",
                    na.strings = "?")

# Make a copy of the raw data to work with
d <- d_raw
# Change the Date variable to a lubridate Date type
d$Date <- dmy(d$Date)

# Filter the copy for only 2007-02-01 & 2007-02-02
d1 <- filter(d, year(Date) == 2007 & month(Date) == 2 & day(Date) %in% c(1,2))

# Remove d; it's just taking up space and won't be re-used
rm(d)

# Create line chart of Global Active Power over time
# We can see that there is a distinct pattern of 
# high usage two times per day.

# Get the DateTime in the right format
d2 <- mutate(d1, Date = as.character(Date), Time = as.character(Time))
d3 <- mutate(d2, DateTime = paste(Date, Time))
d4 <- mutate(d3, DateTime = ymd_hms(DateTime))
# Create plot of Global Active Power over time
png("Plot2.png", width = 480, height = 480, units = "px")
with(d4, plot(DateTime, Global_active_power, type = "l", 
              ylab = "Global Active Power (kilowatts)"))
dev.off()
