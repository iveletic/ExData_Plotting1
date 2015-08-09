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
png( filename  = "plot4.png",
     width     = 480,
     height    = 480,
     units     = "px",
     pointsize = 12,
     bg        = "transparent"
)

## Create plot 4
colors <- c("black", "red", "blue")
layout(matrix(c(1,2,3,4), 2, 2, byrow = TRUE))
with( dataset,
      list( plot( x    = datetime,
                  y    = Global_active_power,
                  type = "l",
                  xlab = "",
                  ylab = "Global Active Power" ),
  
            plot( x    = datetime,
                  y    = Voltage,
                  type = "l",
                  xlab = "datetime",
                  ylab = "Voltage" ),
  
            plot( x    = datetime,
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
                    legend  = columns[7:9],
                    col     = colors,
                    lty     = 1,
                    box.lty = 0 ),

            plot( x    = datetime,
                  y    = Global_reactive_power,
                  type = "l" )
      )
)

## Close the graphics device
dev.off()