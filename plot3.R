## Download and unzip data set to the working directory
filename <- "household_power_consumption.txt"
if( !file.exists(filename) ) {
  temp <- tempfile()
  download.file( "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", temp )
  unzip( temp, filename )
  unlink( temp )
}

## Read the column names and save them as vector
columns <- unname( unlist( read.table( file   = "./household_power_consumption.txt",
                                       header = FALSE,
                                       sep    = ";",
                                       nrows  = 1 )))

## Read the part of the data set from dates 2007-02-01 and 2007-02-02
dataset <- read.table( file = "./household_power_consumption.txt",
                       header           = FALSE,
                       sep              = ";",
                       skip             = 66637,
                       nrows            = 2880,
                       col.names        = columns,
                       stringsAsFactors = FALSE,
                       na.strings       = "?" )

## Replace columns 'Date' and 'Time' with single column 'datetime' in POSIXct format
require(dplyr)
dataset <- dataset %>%
  mutate(datetime = as.POSIXct( strptime( paste(Date, Time, sep=" "), "%d/%m/%Y %H:%M:%S" ))) %>%
  select(10, 3:9)

## Open PNG file graphics device
png( filename  = "plot3.png",
     width     = 480,
     height    = 480,
     units     = "px",
     pointsize = 12,
     bg        = "transparent"
)

## Draw plot 3
colors <- c("black", "red", "blue")
with( dataset,
      list( plot( x    = datetime,
                  y    = Sub_metering_1,
                  col  = colors[1],
                  type = "l",
                  xlab = "",
                  ylab = "Energy sub metering" ),
            
            lines( x   = datetime,
                   y   = Sub_metering_2,
                   col = colors[2] ),
            
            lines( x   = datetime,
                   y   = Sub_metering_3,
                   col = colors[3] ),
            
            legend( "topright",
                    legend = columns[7:9],
                    col    = colors,
                    lty    = 1 )
      )
)

## Close the graphics device
dev.off()