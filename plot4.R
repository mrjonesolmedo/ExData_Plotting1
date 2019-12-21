## Download data if doesn't exist locally
filename <- "dataset.zip"
if(!file.exists(filename)) {
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  success <- download.file(url, filename, method="curl")
  if (success != 0) {
    stop("Failed to download dataset")
  }
}

## Unzip data if hasn't been previously unzipped
dataFile <- "household_power_consumption.txt"
if(!file.exists(dataFile)) {
  unzip("dataset.zip")
}

## Read data files
data <- read.table(dataFile, header=TRUE, sep=";", na.strings="?")

# Parse "Date" and "Time" columns and create a new column of type POSIXlt
data$DateTime <- strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S", tz="Europe/Paris")
data$Date <- as.Date(data$DateTime)

# Extract date range of interest (2007-02-01 and 2007-02-02)
data <- data[data$Date == as.Date("2007-02-01") | data$Date == as.Date("2007-02-02"),]

## Construct plot
png(filename="plot4.png", width=480, height=480)
par(mfrow=c(2,2))
with(data, plot(DateTime, Global_active_power, type="l", xlab=NA, ylab="Global Active Power"))
with(data, plot(DateTime, Voltage, type="l", xlab="datetime", ylab="Voltage"))
with(data, plot(DateTime, Sub_metering_1, type="l", xlab=NA, ylab="Energy sub metering"))
with(data, lines(DateTime, Sub_metering_2, col="red"))
with(data, lines(DateTime, Sub_metering_3, col="blue"))
legend("topright", bty="n", lwd=c(1,1,1), col=c("black","red","blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
with(data, plot(DateTime, Global_reactive_power, type="l", xlab="datetime"), ylim=c(0, 0.5))
axis(side=2, at=c(0.0, 0.1, 0.2, 0.3, 0.4, 0.5))
dev.off()

