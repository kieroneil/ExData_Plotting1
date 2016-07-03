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

# Create histogram of Global Active Power over the two day period.
# We can see that most of the values are in the 0 to 1.5 range.

# Save Plot1 histogram to png file
png("Plot1.png", width = 480, height = 480, units = "px")
hist(d1$Global_active_power, main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)", ylab = "Frequency",
     col = "red")
dev.off()

