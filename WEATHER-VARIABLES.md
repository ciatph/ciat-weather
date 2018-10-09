## Weather Variables List
The following are a list of weather variables From the NASA POWER API, with reference to [https://power.larc.nasa.gov/data-access-viewer/](https://power.larc.nasa.gov/data-access-viewer/).


### QUERY Parameters

1. **User Community**: Agriclimatology
2. **Temporal Average**: Climatology
3. **Lon/Lat**: 16.7109, 120.4145 (in decimal degrees)
4. **Time Extent**:
5. **Output File Format**: ASCII


### VARIABLES (Parameters)

1. **Meteorology** (Moisture and Other)
	- PRECTOT: Precipitation
	- PS: Surface Pressure
	- RH2M: Relative Humidity at 2 Meters 

			PRECTOT,PS,RH2M

2. **Meteorology** (Temperature)
	- T2M_RANGE: Temperature Range at 2 Meters
	- T2MDEW: Dew/Frost Points at 2 Meters                        
	- T2M_MAX: Maximum Temperature at 2 Meters                       
	- T2M_MIN: Minimum Temperature at 2 Meters                       
	- T2M: Temperature at 2 Meters 
	
			T2M_RANGE,T2MDEW,T2M_MAX,T2M_MIN,T2M           
	
3. **Meteorology** (Wind)    
	- WS2M_MIN: Minimum Wind Speed at 2 Meters
	- WS10M_MIN: Minimum Wind Speed at 10 Meters
	- WS2M_MAX: Maximum Wind Speed at 2 Meters
	- WS10M_MAX: Maximum Wind Speed at 10 Meters
	- WS50M_RANGE: Wind Speed Range at 50 Meters          
	- WS2M_RANGE: Wind Speed Range at 2 Meters
	- WS10M_RANGE: Wind Speed Range at 10 Meters
	- WD10M: Wind Direction at 10 Meters (Meteorological Convention)
	- WD50M: Wind Direction at 50 Meters (Meteorological Convention)
	- WS10M: Wind Speed at 10 Meters
	- WS2M: Wind Speed at 2 Meters                                     

			WS2M_MIN,WS10M_MIN,WS2M_MAX,WS10M_MAX,WS50M_RANGE,WS2M_RANGE,WS10M_RANGE,WD10M,WD50M,WS10M,WS2M

### Summary of Variables

	p_precip <- c(
	  "PRECTOT",
	  "PS",
	  "RH2M"
	)
	
	p_temp <- c(
	  "T2M_RANGE",
	  "T2MDEW",
	  "T2M_MAX",
	  "T2M_MIN",
	  # "T2M" 
	)
	
	p_wind <- c(
	  "WS2M_MIN",
	  "WS10M_MIN",
	  "WS2M_MAX",
	  "WS10M_MAX",
	  "WS50M_RANGE",
	  "WS2M_RANGE",
	  "WS10M_RANGE",
	  "WD10M",
	  "WD50M",
	  "WS10M",
	  "WS2M"
	)



## Getting Data

DAILY, INTERANNUAL, CLIMATOLOGY data can only be pulled from _**Single Point**_ and _**Regional**_ identifiers. _**Global**_ can only have CLIMATOLOGY.


### 1. Using API (web)

1. **GLOBAL Climatology** <br>
Global Climatology data only has monthly and annual averages for each parameter.

	See *POWER\_Global\_Climatology\_495ed1cc.txt* <br> (127MB)

		https://power.larc.nasa.gov/cgi-bin/v1/DataAccess.py?request=execute&identifier=Global&parameters=T2M,PRECTOT,RH2M&userCommunity=AG&tempAverage=CLIMATOLOGY&outputList=GEOTIFF&user=anonymous

2. **Daily Data for a Regional Area** <br>
Daily Data contains daily values for each parameter on the specified date range and on each lon, lat.

	See *POWER\_Regional\_Daily_19830701\_19840701\_92f8e4b0.txt* <br> (773KB)

	`lonlat` cannot be set to the world's bounding box `(-180, -90, 180, 90)`. _**Max bounding box is 10 x 10 degrees of 1/2 x 1/2 degree data, i.e., 100 points maximum in total.**_

		https://power.larc.nasa.gov/cgi-bin/v1/DataAccess.py?request=execute&identifier=Regional&parameters=T2M,ALLSKY_SFC_SW_DWN&startDate=19830701&endDate=19840701&userCommunity=AG&tempAverage=DAILY&outputList=ASCII&bbox=-40,-70,-38,-66&user=anonymous


### 2. Using R

1. **GLOBAL Climatology** <br>
	Same format as with the downloaded *POWER\_Global\_Climatology\_495ed1cc.txt* from web. **temporal_average value can only be CLIMATOLOGY, no Daily.**

	R cached downloaded data size (101 MB)

		climatology_ag <- get_power(community = "AG",
			pars = c("T2M", "PRECTOT", "RH2M"),
		    temporal_average = "CLIMATOLOGY")
		
		climatology_ag

2. **Daily Data for a Regional Area** <br>
Daily Data contains daily values for each parameter on the specified date range and on each lon, lat.

	`temporal_average` value can be `CLIMATOLOGY`, `INTERANNUAL` or `DAILY`. 

	`lonlat` cannot be set to the world's bounding box `(-180, -90, 180, 90)`. _**Max bounding box is 10 x 10 degrees of 1/2 x 1/2 degree data, i.e., 100 points maximum in total.**_

		daily_region_ag <- get_power(community = "AG",
			lonlat = c(150.5, -28.5 , 153.5, -25.5), #south east Queensland region
		    pars = c("T2M", "PRECTOT", "RH2M"),
		    dates = c("1985-01-01", "1985-01-02"),
		    temporal_average = "DAILY")
		
		daily_region_ag


## Creating Spatial Objects

1. **Converting Regional Data to a raster object**

		library(raster)
		# Use split to create a list of data frames split by YYYYMMDD
		daily_region_ag <- split(daily_region_ag, daily_region_ag$YYYYMMDD)
		
		# Remove date information from data frame, list names will carry YYYYMMDD
		daily_region_ag <-
		  lapply(daily_region_ag, function(x)
		    x[(!names(x) %in% c("YEAR", "MM", "DD", "DOY", "YYYYMMDD"))])
		
		# Create a list of raster bricks from each YYYYMMDD data frame
		raster_list <- lapply(daily_region_ag, rasterFromXYZ,
		                      crs = "+proj=eqc +lat_ts=0 +lat_0=0 +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs ")
		
		stack_names <- paste0(names(raster_list), rep(c("_RH2M", "_T2M"), 2))
		
		raster_stack <- stack(unlist(raster_list))
		names(raster_stack) <- stack_names
		
		# plot all items in the stack
		plot(raster_stack)


2. **Converting Global Climatology to a raster Object**

		# create RasterBricks for the individual parameters and drop the parameter field
		RH2M <- rasterFromXYZ(subset(climatology_ag, PARAMETER == "RH2M")[, -3])
		T2M <- rasterFromXYZ(subset(climatology_ag, PARAMETER == "T2M")[, -3])
		PRECIP <- rasterFromXYZ(subset(climatology_ag, PARAMETER == "PRECTOT")[, -3])
		
		plot(RH2M$ANN)
		plot(T2M$ANN)
		plot(PRECIP$ANN)

<br>

@ciatph <br>
**Date Created**: 20181009 <br>
**Date Modified**: 20181009 