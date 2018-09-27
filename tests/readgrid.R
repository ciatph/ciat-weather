## Loads an R package if its already installed
## Downloads, installs and loads an R package if its not yet installed
## @param x: package name
## Usage: use usepackage(<package_name>) instead of library(package_name)
## madbarua; 20180927
usepackage <- function(x) {
  if (!is.element(x, installed.packages()[,1]))
    install.packages(x, dep = TRUE)
  require(x, character.only = TRUE)
}


usepackage('RColorBrewer')
usepackage('lattice')
usepackage('ncdf')

# ------------------------------

library(ncdf4)
library(ncdf4.helpers)
library(PCICt)

file <- "data/nasa-power/POWER_Global_Climatology_de741a56.nc"
data <- nc_open(file)

lon <- ncvar_get(data, 'lon')
lat <- ncvar_get(data, 'lat')

summary(lon)
summary(lat)

# display time units
data$dim$time$units
data$dim$time$calendar

# ------------------------------

# print variables
attributes(data)$names

# print variable names
attributes(data$var)$names

# inspect the attributes of a variable
ncatt_get(data, attributes(data$var)$names[1])

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
attr <- ncatt_get(data, 0)