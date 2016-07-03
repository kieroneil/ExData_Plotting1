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

# Get the DateTime in the right format
d2 <- mutate(d1, Date = as.character(Date), Time = as.character(Time))
d3 <- mutate(d2, DateTime = paste(Date, Time))
d4 <- mutate(d3, DateTime = ymd_hms(DateTime))

# Open png device
png("Plot4.png", width = 480, height = 480, units = "px")
# Initial setup
par(mfrow= c(2,2))

# Plot 1 - Global Active Power over Time
hist(d1$Global_active_power, main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)", ylab = "Frequency",
     col = "red")

# plot 2 - Voltage over Time
d1$Time <- hms(d1$Time)
d1$DateTime <- d1$Date + d1$Time
with(d1, plot(DateTime, Voltage, col = "black"))

# Plot 3 - Sub-metering over time
# Create axis ranges
x_range = range(d4$DateTime)
y_range <- range(d4$Sub_metering_1)
# Create Plot
plot(x_range, y_range, type="n", xlab="Time (days)",
     ylab="Energy Sub-metering" ) 
lines(x=d4$DateTime, y=d1$Sub_metering_1, col = "black")
lines(x=d4$DateTime, y=d1$Sub_metering_2, col = "red", lwd=2)
lines(x=d4$DateTime, y=d1$Sub_metering_3, col = "blue", lwd=2)
legend("topright", c("Sub-metering 1", "Sub-metering 2", "Sub-metering 3"),
       col=c("black", "red", "blue"), text.col = "black",
       bg="beige", lty=c(1,1,1), lwd=c(1,2,2))

# Plot 4 - Global Reactive Power of Time
with(d4, plot(DateTime, Global_reactive_power, type = "l", col = "black"))
dev.off()

