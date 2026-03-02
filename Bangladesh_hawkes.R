# Libraries
library(dplyr)
library(lubridate)
library(PtProcess)

set.seed(123)

# Load ACLED data
acled_data <- read.csv("c:/Users/zejpo/OneDrive/Documents/Work/Political Violence/acled_data.csv")

# Process ACLED data and extract coordinates
events_data <- acled_data %>%
  filter(sub_event_type %in% c("Mob violence", "Violent demonstration")) %>%
  mutate(event_date = as.POSIXct(event_date, format = "%d-%b-%y")) %>%
  distinct(admin3, event_date, .keep_all = TRUE)

# Ensure no missing values in coordinates
events_data <- events_data %>%
  filter(!is.na(longitude) & !is.na(latitude))

# Filter the data to include only events between June 5, 2024, and August 5, 2024
events_data <- events_data %>%
  filter(event_date >= as.POSIXct("2024-06-05") & event_date <= as.POSIXct("2024-08-05"))

# Check the number of events in the specified period
print(paste("Number of events between June 5, 2024, and August 5, 2024:", nrow(events_data)))

# Prepare spatio-temporal dataset
events_data <- events_data %>%
  select(longitude, latitude, event_date) %>%
  rename(x = longitude, y = latitude, time = event_date)

# Scale the data
events_data$x <- scale(events_data$x)
events_data$y <- scale(events_data$y)
events_data$time <- scale(as.numeric(events_data$time))

# Check the scaled data
print(head(events_data))

# Define the simplified Hawkes process model with robust checks
hawkes_model <- function(params, data) {
  mu <- params[1]
  alpha <- params[2]
  beta <- params[3]
  times <- data$time
  x <- data$x
  y <- data$y
  n <- length(times)
  lambda <- rep(mu, n)
  for (i in 2:n) {
    for (j in 1:(i-1)) {
      spatial_dist <- sqrt((x[i] - x[j])^2 + (y[i] - y[j])^2)
      lambda[i] <- lambda[i] + alpha * exp(-beta * (times[i] - times[j])) * exp(-spatial_dist)
    }
  }
  if (any(!is.finite(lambda)) || any(lambda <= 0)) {
    print("Non-finite or non-positive lambda encountered")
    return(rep(Inf, n))
  }
  return(lambda)
}

# Fit the simplified Hawkes process model with progress monitoring
params <- c(mu = 0.1, alpha = 0.5, beta = 1.0)
fit <- optim(params, function(p) {
  lambda <- hawkes_model(p, events_data)
  if (any(lambda == Inf)) return(Inf)
  log_likelihood <- -sum(log(lambda))
  print(paste("Current log-likelihood:", log_likelihood))
  return(log_likelihood)
}, method = "Nelder-Mead", control = list(maxit = 2000, trace = 1, REPORT = 10))

# Print model summary
print(fit)

