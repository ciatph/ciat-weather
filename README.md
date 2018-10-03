# ciat-weather
Experiment scripts and data for automating download and acquisition of weather data from various opensource weather API's. README's containing notes for accessing and usage of various data sets are included in each respective directories in `/data/*`.


### Data Directories

1. **/data/nasa-power** <br>
Contains notes and demo for accessing the NASA POWER API at [https://power.larc.nasa.gov/docs/v1/](https://power.larc.nasa.gov/docs/v1). 


### Files

1. **gridload.R** <br>
Load a default json *(config_r.json)* file then read its URL content to download the netcdf file.

2. **index.js** <br>
Load a default json *(config_node.json)* file then read its URL content to download the netcdf file.

3. **main_r.bat** <br>
Initiates the download of the default json file and its  and its NCDF file content using **R** (R must have been installed in your PC).

4. **main_nodejs.bat** <br>
Initiates the download of the default json file and its NCDF file content using **NodeJS** (NodeJS must have been installed in your PC).

5. **/tests/readgrid.R** <br>
Experimental script for reading and parsing gridded data set (NETCDF files). <br>
	- Open RStudio, set the working directory `setwd()` to the cloned project directory.
	- Set the `NCDF` filename `file_name` inside the script.
	- Run `source("tests/readgrid.R")` from the RStudio console

6. **/lib/usepackage.R** <br>
R utility script that loads an R package if its already installed. Downloads, installs and loads an R package if its not yet installed. <br>

	Usage: use `usepackage('package_name')` instead of `library(package_name)`

### Usage

1. Clone or download this repository into your desktop.

2. **Downloading NETCDF file using NodeJS** <br>
	- Navigate using the commandline into this project directory.
	- Run `node index.js` or, 
	- Just click `main_nodejs.bat`
	
3. **Downloading NETCDF file using R** <br>
	- Set this directory `setwd()` as the working directory.
	- In *R Studio*. In R Studio's console, run `source('gridload.R')` 
	- Alternatively, open `main_r.bat` using a text editor and set your R's bin path (this is where Rscript.exe can be found). 

		Click `main_r.bat`

4. Wait for the NETCDF files to finish downloading.



### External Links

1. [**Trello**](https://trello.com/b/FmBr8lTS) project board *(private)*.

<br><hr><br>

@ciatph <br>
**Date Created:** 20180926 <br>
**Date Created:** 20180927