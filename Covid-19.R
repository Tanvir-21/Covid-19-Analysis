library(covid19.analytics)
library(dplyr)
library(prophet)
library(lubridate)
library(ggplot2)

#Data

tsc <- covid19.data(case = 'ts-confirmed')

tsc <- tsc %>% 
  filter(Country.Region == 'Bangladesh')
tsc <- data.frame(t(tsc))

tsc <- cbind(rownames(tsc), data.frame(tsc, row.names = NULL))

colnames(tsc) <- c('Date', 'Confirmed')

tsc <- tsc[-c(1:4),]

tsc$Date <- ymd(tsc$Date)
tsc$Confirmed <- as.character(tsc$Confirmed)
tsc$Confirmed <- as.numeric(tsc$Confirmed)

str(tsc)

#plot
P <- ggplot(tsc, aes(Date,Confirmed))+
  geom_point()

P
#forecasting 
ds <- tsc$Date
y <- tsc$Confirmed
df <- data.frame(ds,y)

m <- prophet(df)

#prediction 
future <- make_future_dataframe(m,periods = 28)
forecast <- predict(m, future)

#plotting forecast 
plot(m,forecast)
dyplot.prophet(m, forecast)
