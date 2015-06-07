
#load needed packages(install only if needed)
#install.packages('sqldf')
library(sqldf)

#save original working directory
orig_wd <- getwd()

# Change working directory
if(!file.exists("./ED"))
  dir.create("./ED")
setwd("./ED")

# Url at which the data set is located
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# Download zip file
download.file(fileUrl, destfile="household_power_consumption.zip", method="auto", quiet = FALSE, mode = "wb",
              cacheOK = TRUE)

#unzip the data file
unzip(zipfile="./household_power_consumption.zip", exdir=".")

# Read data set after unzipping the data file
data <- read.csv2("household_power_consumption.txt", header = TRUE, sep = ";",na.strings = "?")

# Filtering the data for Feb. 1 and 2, 2007 only
FilteredData <- sqldf("SELECT * from data WHERE Date = '1/2/2007' OR Date = '2/2/2007'")

# Creating the Plot
png("./plot1.png", width = 480, height = 480)

hist(as.numeric(as.character(FilteredData[,3])), col = "RED",
     xlab = "Global Active Power(kilowatts)",
     main = "Global Active Power")

dev.off()

#Restore working directory
setwd(orig_wd)
