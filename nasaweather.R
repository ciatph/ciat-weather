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
variables[[2]] <- c(
  "T2MDEW",
  "T2M_MAX",
  "T2M_MIN",
   "T2M" 
)

# weather variable: wind speed
# "WS2M_MIN", #X
# "WS10M_MIN", #x
# "WS2M_MAX", #x
# "WS10M_MAX", #x
# "WS50M_RANGE", #x
# "WS2M_RANGE", #x
# "WS10M_RANGE", #x
# "WS2M" #x
variables[[3]] <- c(
  "WD10M",
  "WD50M",
  "WS10M"
)

# Append weather variables into (1) long list() with equal no. of items
params <- formatinput(variables, 3)

# Initialize the data loader object
d <- dataloader()

# Set global bounding box (world map's bounding box)
d$set(180, 90, 3)

# Optional: Set number of grid cell to process
d$setnumcols(2)
d$setnumrows(1)
# d$setprint(TRUE)

# Load weather parameters
d$load(params)

# Export data to CSV
d$export()

