/**
 * NETCDF4 file downloader for Global data
 * Reference: https://www.hacksparrow.com/using-node-js-to-download-files.html
 * madbarua 20181001
 */

var fs = require('fs');
var spawn = require('child_process').spawn;


// solar ratiation parameters
var solar_radiation = ['SI_EF_MAX_OPTIMAL,SI_EF_MAX_OPTIMAL_ANG,SI_EF_MAX_TILTED_ANG_ORT',
	'SI_EF_MIN_OPTIMAL,SI_EF_MIN_OPTIMAL_ANG,SI_EF_MIN_TILTED_ANG_ORT',
	'SI_EF_OPTIMAL,SI_EF_OPTIMAL_ANG,SI_EF_TILTED_ANG_ORT'];

// parameters: humidity, precipitation, temperature_min_max, wind_speed
var weather_vars = ['QV2M,RH2M,PRECTOT',
	'TQV,T10M_MIN,T2M_MIN',
	'TS_MIN,T10M_MAX,T2M_MAX',
	'TS_MAX,WS10M,WS10M_MAX',
	'WS10M_MIN,WS10M_RANGE,WS2M',
	'WS2M_MAX,WS2M_MIN,WS2M_RANGE',
	'WS50M,WS50M_MAX,WS50M_MIN',
	'WS50M_RANGE,WSC'];
	
var params = solar_radiation[0];	


// API URL 
// TO=DO: Fetch 'parameters' from dynamic input or file
// var FILE_URL = 'https://power.larc.nasa.gov/cgi-bin/v1/DataAccess.py?request=execute&identifier=Global&parameters=T2M,ALLSKY_SFC_SW_DWN,PS&userCommunity=AG&tempAverage=CLIMATOLOGY&outputList=NETCDF&user=anonymous';

var FILE_URL = 'https://power.larc.nasa.gov/cgi-bin/v1/DataAccess.py?request=execute&identifier=Global&parameters=' + 
	params[2] + 
	'&userCommunity=AG&tempAverage=CLIMATOLOGY&outputList=NETCDF&user=anonymous';
	
var FILE_URL = 'https://power.larc.nasa.gov/cgi-bin/v1/DataAccess.py?request=execute&identifier=Global&parameters=T2M,ALLSKY_SFC_SW_DWN,PS&userCommunity=AG&tempAverage=CLIMATOLOGY&outputList=NETCDF&user=anonymous';
	
	
console.log(FILE_URL);

// Data folder
var FILE_DATA_PATH = 'data/nasa-power'

// JSON filename to download from API URL
var FILE_CONFIG = 'config_node.json';

// Download file using curl
var download_file_curl = function(URL, FILENAME, DOWNLOAD) {
    console.log('--downloading ' + FILENAME + '...');

    // Create an instance of writable stream
    var file = fs.createWriteStream(__dirname + '/' + FILENAME);

    // Execute curl using child_process' spawn function
    var curl = spawn('curl', [URL]);
    
    // Add a 'data' event listener for the spawn instance
    curl.stdout.on('data', function(data) { 
        console.log('--loaded ' + FILENAME + ', size: ' + (parseFloat(file.bytesWritten) / 1000000) + 'MB');

        // Write chunks of data to file
        file.write(data); 

        // Recursively download NETCDF4 file inside the 1st downloaded JSON data
        if(DOWNLOAD !== undefined){
            if(DOWNLOAD){
                // Read file as JSON
                var jsonfile = require('./' + FILENAME);
                var pathNew = jsonfile.outputs.netcdf;
                console.log(pathNew);            

                download_file_curl(pathNew, 
                    FILE_DATA_PATH + '/' + pathNew.substring(pathNew.lastIndexOf('/') + 1, pathNew.length));
            }
        }
    });

    // Add an 'end' event listener to close the writeable stream
    curl.stdout.on('end', function(data) {
        file.end();
        console.log(FILENAME + ' downloaded to ' + __dirname);
    });

    // When the spawn child process exits, check if there were any errors and close the writeable stream
    curl.on('exit', function(code) {
        if (code != 0) {
            console.log('Failed: ' + code);
        }
    });
};


// Download the files
download_file_curl(FILE_URL, FILE_CONFIG, true);