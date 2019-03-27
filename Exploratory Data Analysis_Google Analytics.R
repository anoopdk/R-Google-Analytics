#Exploratory Data Analysis on Google Analytics using R
install.packages("googleAuthR")
install.packages("googleAnalyticsR")
install.packages("ggplot2")

# load libraries
library("googleAuthR")
library("googleAnalyticsR")
library("ggplot2")

# authorize connection with Google Analytics servers
ga_auth()

gadata <- google_analytics(viewId = 1234567,     # view ID changed
                           date_range = c(
                             today() - 30, 	# start date
                             today()		# end date
                           ), 
                           metrics = c("sessions"),
                           dimensions = c("date"),
                           max = 5000)

# descriptive stats
min(gadata$sessions)
max(gadata$sessions)
mean(gadata$sessions)
median(gadata$sessions)
sd(gadata$sessions)

# plot histogram
hist(gadata$sessions)

# summary of dataset
summary(gadata)

# basic plot
plot(gadata$date,gadata$sessions, type="l")

# days with min and max number of sessions
subset(gadata, gadata$sessions == max(gadata$sessions))
subset(gadata, gadata$sessions == min(gadata$sessions))

# days with number of sessions above the mean
subset(gadata, gadata$sessions >= mean(gadata$sessions))
