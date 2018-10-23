## Main program proper
## Load NASA POWER API weather variables into (1) masterlist and export them to CSV
## ciatph; 20181011

source("lib/globaldailyloader.R")


# List of NASA POWER weather variables per category
variables <- list()

# weather variable: precipitation
variables[[1]] <- c(
  "PRECTOT",
  "PS",
  "RH2M"
)

# weather variable: temperature
#   #"T2M_RANGE", #X
#variables[[2]] <- c(
#  "T2MDEW",
#  "T2M_MAX",
#  "T2M_MIN"
#  # NA "T2M"
#)

# weather variable: wind speed
# "WS2M_MIN", #X
# "WS10M_MIN", #x
# "WS2M_MAX", #x
# "WS10M_MAX", #x
# "WS50M_RANGE", #x
# "WS2M_RANGE", #x
# "WS10M_RANGE", #x
# "WS2M" #x
#variables[[2]] <- c(
#  "WD10M",
#  "WD50M"
  # NA "WS2M"
  # NA "WS10M"
#)

# Append weather variables into (1) long list() with equal no. of items
params <- formatinput(variables, 3)

# Initialize the data loader object
d <- dataloader()

# Set global bounding box (world map's bounding box)
d$set(180, 90, 4) #4.8

# Optional: Set number of grid cell to process
d$setnumcols(3)
d$setnumrows(2)

# Set TRUE if we only want to see the printed bounding boxes
# Does not download data if set to TRUE
# d$setprint(TRUE)

# Optional: set column and row index to start
# d$setstartx(length(d$getx()) - 3)
# d$setstarty(length(d$gety()) - 3)
# d$setstartx(match(c(-4), d$getx()))

# Load weather parameters
d$load(params)

# Export data to CSV
d$export()

