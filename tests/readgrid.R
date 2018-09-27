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

file <- "data/nasa-api/POWER_Global_Climatology_de741a56.nc"
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
ncatt_get(data, attributes(data$var)$names[2])

# get the matrix data for a variable 
t <- ncvar_get(data, attributes(data$var)$names[2])

# print the dimensions [lon, lat, time]
dim(t)

