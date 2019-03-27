## A script to automated pull of Google search console analytics using R.  
## Credits: searchConsoleR package created by Mark Edmondson (http://markedmondson.me)
##
## This script downloads and writes data to .csv file
##
## load the required libraries 
install.packages("googleAuthR")
install.packages("searchConsoleR")
library(googleAuthR)
library(searchConsoleR)

## Authorize script with Google Developer Console.  
service_token <-gar_auth_service("C:\Users\anoop\Downloads\r_search_console_data.json")

## Set todays date. Since we are considering only todays data, end date will be equal to start date
start <- Sys.Date()
end <- start

## set website to your URL
website <- "http://www.motivationiq.fitness"

## Download the date and query data
download_data <- c('date','query')

## web Google search
type <- c('web')

## Explore options of ?search_analytics in the R console

## Will consider 6000 as row limit
searchquery <- search_analytics(siteURL = website,
                                startDate = start, 
                                endDate = end, 
                                dimensions = download_data,
                                searchType = type, 
                                rowLimit = 5000)



## Specify Output filepath
filepath <-"C:\Users\anoop\Downloads\rdata\"

## filename 
filename <- paste("sconsoledata", start, sep = "_")

## full filepath + filename with .csv
output <- paste(filepath, filename, ".csv", sep = "")

## Write data to an output file
write.csv(searchquery, output, row.names = FALSE)

## Complete
