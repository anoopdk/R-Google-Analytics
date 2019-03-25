
#Used Google Analytics API and R for the data wrangling. 

#Install essential packages
install.packages(
  c(
    "googleAnalyticsR", # our interface with GA
    "tidyverse",        # a must have for R scripting
    "stringr",          # handy string functions
    "lubridate",        # handy date and time functions
    "ggthemes",         # pretty plot themes
    "ggrepel",          # non-obstructive plot labels
    "scales"            # custom plot scales
  ), 
#all of these packages may not be used but essential for 
#all sort of viz and analysis purposes
  dependencies = T      # install dependencies
)

ga_auth()  # authorize the current R session
ga_auth(new_user = TRUE)  # force new aurization
sources_raw = google_analytics(
  viewId = 1234567,     # replace this with your view ID
  date_range = c(
    today() - 30, 	# start date
    today()		# end date
  ),
  metrics = c(
    "sessions",
    "users",
    "transactions",
    "transactionRevenue"
  ),
  dimensions = c(
    "channelGrouping"   # pull the default channel grouping as the only dimension
  ))
#Data Clean Up
# now let's make some calculations on the sessions/users share and conversion rates
sources_clean = sources_raw %>%
  mutate(
    session_share = sessions / sum(sessions),
    sales_share = transactions / sum(transactions),
    revenue_share = transactionRevenue / sum(transactionRevenue)
  ) %>%
  arrange(-session_share) %>%
  transmute(
    channel = channelGrouping,
    sessions,
    users,
    sales = transactions,
    revenue = transactionRevenue,
    session_share,
    session_addup = cumsum(session_share),
    sales_share,
    sales_addup = cumsum(sales_share),
    revenue_share,
    revenue_addup = cumsum(revenue_share),
    cr_sessions = transactions / sessions,
    cr_users = transactions / users,
    rps = revenue / sessions,
    rpu = revenue / users
  )
#Plotting the graph using ggplot
#Reference URL - https://ggplot2.tidyverse.org/#learning-ggplot2
sources_clean %>%
  filter(sales >= 10) %>%   # show only the channels with 10+ sales
  ggplot(
    aes(
      x = session_share,
      y = sales_share,
      color = channel
    )
  ) +
  geom_abline(slope = 1, alpha = 1/10) +
  geom_point(alpha = 5/7) +
  theme_minimal(base_family = "Helvetica Neue") +
  theme(legend.position = "none") +
  scale_x_continuous(name = "Share of sessions", limits = c(0, NA), labels = percent) +
  scale_y_continuous(name = "Share of sales", limits = c(0, NA), labels = percent) +
  scale_color_few(name = "Channel") +
  scale_fill_few() +
  ggtitle(
    "Sessions and sales distribution for top channels",
    subtitle = "Based on the Google Analytics data"
  ) +
  geom_label_repel(alpha = 1/2, aes(label = channel), show.legend = F)  

#Complete...