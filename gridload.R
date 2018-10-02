source("lib/usepackage.R")
usepackage('jsonlite')

## Load a default json file then read its contents to download
## the netcdf file
## ciatph; 20181001

# solar ratiation parameters
solar_radiation <- c(
	'SI_EF_MAX_OPTIMAL,SI_EF_MAX_OPTIMAL_ANG,SI_EF_MAX_TILTED_ANG_ORT',
	'SI_EF_MIN_OPTIMAL,SI_EF_MIN_OPTIMAL_ANG,SI_EF_MIN_TILTED_ANG_ORT',
	'SI_EF_OPTIMAL,SI_EF_OPTIMAL_ANG,SI_EF_TILTED_ANG_ORT')

# parameters: humidity, precipitation, temperature_min_max, wind_speed
weather_vars <- c(
	'QV2M,RH2M,PRECTOT', #
	'TQV,T10M_MIN,T2M_MIN', #
	'TS_MIN,T10M_MAX,T2M_MAX',#
	'TS_MAX,WS10M,WS10M_MAX', #
	'WS10M_MIN,WS10M_RANGE,WS2M',
	'WS2M_MAX,WS2M_MIN,WS2M_RANGE',
	'WS50M,WS50M_MAX,WS50M_MIN',
	'WS50M_RANGE,WSC')	# error fetch

param <- weather_vars

for(i in 1:length(param)) {
	# Download preliminary json file
	# url <- 'https://power.larc.nasa.gov/cgi-bin/v1/DataAccess.py?request=execute&identifier=Global&parameters=T2M,ALLSKY_SFC_SW_DWN,PS&userCommunity=AG&tempAverage=CLIMATOLOGY&outputList=NETCDF&user=anonymous'
	url <- paste0('https://power.larc.nasa.gov/cgi-bin/v1/DataAccess.py?request=execute&identifier=Global&parameters=',
		param[i], '&userCommunity=AG&tempAverage=CLIMATOLOGY&outputList=NETCDF&user=anonymous')

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
}