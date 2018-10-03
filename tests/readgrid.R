source(paste0(getwd(), "/lib/usepackage.R"))

## Experimental script for reading and parsing grided ncdf files
## ciatph; 20181001
# ------------------------------

usepackage('ncdf4')
usepackage('ncdf4.helpers')
usepackage('PCICt')

# data path and file name of NCDF file
file_path <- "/data/nasa-power/"
file_name <- "POWER_Global_Climatology_1edb96c5.nc"
print(paste0(getwd(), file_path, file_name))

file <- paste0(getwd(), file_path, file_name)
data <- nc_open(file)

lon <- ncvar_get(data, 'lon')
lat <- ncvar_get(data, 'lat')

summary(lon)
summary(lat)

# display time units
t_units <- data$dim$time$units
t_calendar <- data$dim$time$calendar
print(paste("--TIME Units", t_units))
print(paste("--TIME Calendar", t_calendar))

# ------------------------------

# print variables
variables <- attributes(data)$names
print(paste("--variables", variables))


# print variable names
var_names <- attributes(data$var)$names
print(paste("--VARIABLE NAMES", var_names))

# inspect the attributes of a variable
var_attr <- ncatt_get(data, attributes(data$var)$names[1])
print(paste("--attributes of variable #1", var_attr))

# get the matrix data for a variable 
d <- ncvar_get(data, attributes(data$var)$names[1])

# print the dimensions [lon, lat, time]
dim(t)

# retrieve the latitude and longitude values
# attributes(data$dim)$names
d_lon <- ncvar_get(data, attributes(data$dim)$names[1])
d_lat <- ncvar_get(data, attributes(data$dim)$names[2])

# make the lat and lon as headers
dimnames(d) <- list(lon=d_lon, lat=d_lat)

# get the global attributes
g_attr <- ncatt_get(data, 0)
print(paste("--GLOBAL ATTRIBUTES", g_attr))

# print contents
head(d)