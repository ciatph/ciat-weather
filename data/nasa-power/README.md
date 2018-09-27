# /data/nasa-power/*

Tests and demos for fetching data from [https://power.larc.nasa.gov/docs/v1/](https://power.larc.nasa.gov/docs/v1).


## Data Service (web api)

Below are sample URL queries for accessing the API. Custom URL queries can be built by customizing fields in the _**Parts of the Data Service URLs**_ section.

1. **SinglePoint URL** <br>
`https://power.larc.nasa.gov/cgi-bin/v1/DataAccess.py?request=execute&identifier=SinglePoint&parameters=T2M,PS,ALLSKY_SFC_SW_DWN&startDate=20160301&endDate=20160331&userCommunity=SSE&tempAverage=DAILY&outputList=JSON,ASCII&lat=36&lon=45&user=anonymous`

2. **Regional URL** <br>
`https://power.larc.nasa.gov/cgi-bin/v1/DataAccess.py?request=execute&identifier=Regional&parameters=T2M,ALLSKY_SFC_SW_DWN&startDate=19830701&endDate=19830705&userCommunity=SSE&tempAverage=DAILY&outputList=ASCII&bbox=-40,-70,-38,-66&user=anonymous`

	This returns a JSON file with an internal downloadable text link for the actual data at `outputs/ascii`. (See POWER\_Regional\_Daily_19830701\_19830705\_bc5497ea.txt).

3. **Global URL** <br>
`https://power.larc.nasa.gov/cgi-bin/v1/DataAccess.py?request=execute&identifier=Global&parameters=T2M,ALLSKY_SFC_SW_DWN,PS&userCommunity=SSE&tempAverage=CLIMATOLOGY&outputList=NETCDF&user=anonymous`

	This returns a JSON file with an internal downloadable text link for the actual data at `outputs/NETCFD`. (See https://power.larc.nasa.gov/downloads/POWER\_Global\_Climatology\_de741a56.nct).


### Parts of the Data Service URLs

For more information, see [https://power.larc.nasa.gov/docs/v1/a#web](https://power.larc.nasa.gov/docs/v1/a#web)  *Available Identifiers*.

1. **request** - its value always *execute*

2. **identifier** <br>
	- _**SinglePoint**_ <br>
		returns a time series based on a single lon and lat coordinate across time span provided. Response is JSON (by default) and data values are provided in the response JSON
	- _**Regional**_ <br>
	The Regional endpoint returns a time series based on a *bounding box of lower left (lat,lon) and upper right (lat,lon) coordinates* across the time span provided. The response is JSON by default but does not provide the data values in the default JSON response. However, if JSON data values are required the user must specify JSON in the `outputList` parameter and select the downloadble JSON file. Additional outputs are available if requested.
	- _**Global**_ <br>
	The Global endpoint returns long term climatological averages for the entire globe. (Rest of definition is similar to *Regional*)

3. **parameters** - these are comma-separated values (data parameters) that we want to retrieve from the API. Please view this [https://power.larc.nasa.gov/docs/v1/#parameters](https://power.larc.nasa.gov/docs/v1/#parameters) to view the long-list of available parameters.

	Common values (with similarities to IRRI's) are:
	- Solar Radiation
		- CLRSKY_DIFF: Clear Sky Diffuse Radiation On A Horizontal Surface
		- DIFF: Diffuse Radiation On A Horizontal Surface
		- DIFF_MAX: Maximum Diffuse Radiation On A Horizontal Surface
		- DIFF_MIN: Minimum Diffuse Radiation On A Horizontal Surface
		- DNR: Direct Normal Radiation
		- DNR_MAX: Maximum Direct Normal Radiation
		- DNR\_MAX\_DIFF: Maximum Difference From Monthly Averaged Direct Normal Radiation
		- DNR\_MIN: Minimum Direct Normal Radiation
		- DNR\_MIN\_DIFF: Minimum Difference From Monthly Averaged Direct Normal Radiation
	- Temperature Minimum
	- Temperature Max
	- Vapor Pressure
	- Wind Speed
	- Precipitation
	Number of parameters have a limit for each *identifier*
	 - SinglePoint, Regional = 20
	 - Global = 3

4. **startDate, endDate** - start and end date for data. Format is `YYYYMMDD`

5. **lat, lon** - latitude and longitude coordinates, if chosen `identifier` is _**Regional**_. 

6. **userCommunity** - group of categories. Selecting a user community will affect the units of the parameter and the temporal display of time series data (e.g. Agroclimatology will use Julian Day of Year)

	Available Values are: 
	- `SSE`: Surface meteorology and Solar Energy
	- `SB`: Sustainable Buildings
	- `AG`: Agroclimatology
	
7. **tempAvarage** -  the Temporal Average, and has only (1) value. 
	Possible values are:
	- DAILY: Daily average by year.
	- INTERANNUAL: Monthly and annual average By year.
	- CLIMATOLOGY: Long term monthly averages.

	Values for identifiers are:
	- SinglePoint, Regional = DAILY, INTERANNUAL, CLIMATOLOGY
	- Global = CLIMATOLOGY
8. **outputList** - JSON is the default output format for all identifiers unless specified.
	- SinglePoint, Regional = JSON, ASCII, CSV, ICASA, NETCDF
	- Global = JSON, ASCII, CSV, NETCDF, GEOTIFF
	
9. **user**


### Sample JavaScript query code
	$(document).ready( function () {
	
	//create POWER url	
	url = singlepoint URL
	
	//request data
	$.getJSON( url, function( data ) {
	  }).done( function ( data ) {
	     //access the data values within the json data response
	     features = data["features"];
	     properties = features[0].properties;
	     parameter = properties.parameter;
	
	     for ( var p in parameter ) {
	       var values = features[0].properties.parameter[p];
	         for ( var v in values ){
	           var powervalue = values[v];
	         }
	  });
	}); 


<br><hr><br>

@ciatph <br>
**Date Created:** 20180926 <br>
**Date Created:** 20180927