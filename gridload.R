source("lib/usepackage.R")
usepackage('jsonlite')

## Load a default json file then read its contents to download
## the netcdf file
## ciatph; 20181001

# Download preliminary json file
url <- 'https://power.larc.nasa.gov/cgi-bin/v1/DataAccess.py?request=execute&identifier=Global&parameters=T2M,ALLSKY_SFC_SW_DWN,PS&userCommunity=AG&tempAverage=CLIMATOLOGY&outputList=NETCDF&user=anonymous'
print(paste("Loading file", url, "..."))
download.file(url, 'config_r.json', method='curl')

# Read into JSON object
print(paste("Reading JSON..."))
g <- fromJSON('config_r.json')

# Download the NETCDF4 content
filepath <- g$outputs$netcdf
print(paste("NETCDF file", filepath))

# Find the netcdf4 filename
r <- gregexpr(pattern='/', filepath)
filename <- substring(filepath, r[[1]][length(r[[1]])] + 1, nchar(filepath))

# Download the netcdf4 file
print(paste("Loading", filename))
download.file(filepath, filename, method='curl')