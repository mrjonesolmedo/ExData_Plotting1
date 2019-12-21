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
png(filename="plot2.png", width=480, height=480)
with(data, plot(DateTime, Global_active_power, type="l", xlab=NA, ylab="Global Active Power (kilowatts)"))
dev.off()

