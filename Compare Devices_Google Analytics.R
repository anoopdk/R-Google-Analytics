#Comparision of devised in Google Analytics using R
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
                           metrics = c("sessions", "avgSessionDuration"),
                           dimensions = c("date", "deviceCategory"),
                           max = 6000)
#plot sessions with deviceCategory
ggplot(gadata, aes(deviceCategory, sessions)) +   
  geom_bar(aes(fill = deviceCategory), stat="identity")

#plot avgSessionDuration with deviceCategory
ggplot(gadata, aes(deviceCategory, avgSessionDuration)) +   
  geom_bar(aes(fill = deviceCategory), stat="identity")