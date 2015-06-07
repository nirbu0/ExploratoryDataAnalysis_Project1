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

# Concatante Date and Time variables
start <- as.integer( as.POSIXct( strptime ( paste( FilteredData[1,1], FilteredData[1,2]), "%d/%m/%Y %H:%M:%S" ) ) )
to <- (as.integer( as.POSIXct( strptime ( paste( FilteredData[,1], FilteredData[,2]), "%d/%m/%Y %H:%M:%S" ) ) ) - start)
ga <- as.numeric(as.character(FilteredData[,3]))

sub1 <- as.numeric(as.character(FilteredData$"Sub_metering_1"))
sub2 <- as.numeric(as.character(FilteredData$"Sub_metering_2"))
sub3 <- as.numeric(as.character(FilteredData$"Sub_metering_3"))

# Creating the Plot
png("./plot3.png", width = 480, height = 480)

plot( to, sub1, type = "l", col="black", xlab="", ylab="Energy sub metering", xaxt='n' )
lines( to, sub2, type = "l", col="red" )
lines( to, sub3, type = "l", col="blue" )
axis(1, at=c(to[1], to[length(to)/2], to[length(to)]), labels=c("Thu","Fri", "Sat") )
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=c(1,1), col=c("black", "red", "blue") )#, lwd=c(2.5,2.5)))

dev.off()

#Restore working directory
setwd(orig_wd)
