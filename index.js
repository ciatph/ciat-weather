/**
 * NETCDF4 file downloader for Global data
 * Reference: https://www.hacksparrow.com/using-node-js-to-download-files.html
 * madbarua 20181001
 */

var fs = require('fs');
var spawn = require('child_process').spawn;


// API URL 
// TO=DO: Fetch 'parameters' from dynamic input or file
var FILE_URL = 'https://power.larc.nasa.gov/cgi-bin/v1/DataAccess.py?request=execute&identifier=Global&parameters=T2M,ALLSKY_SFC_SW_DWN,PS&userCommunity=AG&tempAverage=CLIMATOLOGY&outputList=NETCDF&user=anonymous';

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