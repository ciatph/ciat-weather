var FILE_URL = 'https://power.larc.nasa.gov/cgi-bin/v1/DataAccess.py?request=execute&identifier=Global&parameters=T2M,ALLSKY_SFC_SW_DWN,PS&userCommunity=AG&tempAverage=CLIMATOLOGY&outputList=NETCDF&user=anonymous';
var FILE_SAVE_PATH = 'data.json';


/** Works on jpeg files 
 * https://www.npmjs.com/package/mt-files-downloader
*/
/*
var FILE_URL = 'https://vignette.wikia.nocookie.net/diablo/images/1/1c/HarrogathArt.jpg/revision/latest?cb=20130302111641';
const Downloader = require('mt-files-downloader');

var downloader = new Downloader();
var dl = downloader.download(FILE_URL, 'data.jpg').start();

dl.on('start', function(dl) {
    console.log('download started');
});

dl.on('error', function(dl) {
    console.log('An error was encountered: ' + dl.error.message);
});

dl.on('end', function(dl) {
    console.log('download finished');
});
*/


/** Method #2: Reads but not write data. JPEG only */
/*
var FILE_URL = 'https://vignette.wikia.nocookie.net/diablo/images/1/1c/HarrogathArt.jpg/revision/latest?cb=20130302111641';
var fs = require('fs');
var FastDownload = require('fast-download');
new FastDownload(FILE_URL, {}, function(error, dl){
    if (error){throw error;}
    console.log('started');
    dl.on('error', function(error){throw error;});
    dl.on('end', function(){console.log('ended');});
    //dl.pipe(fs.createReadStream('foo.bar'));
});
*/


/**
 * https://www.hacksparrow.com/using-node-js-to-download-files.html
 */
FILE_SAVE_PATH = 'mydata.json';
var fs = require('fs');
const Path = require('path');  
var exec = require('child_process').exec;
var spawn = require('child_process').spawn;
const path = Path.resolve(__dirname, 'images', 'code.jpg');
var size = 0;

// Function to download file using curl
var download_file_curl = function(URL, FILENAME, DOWNLOAD) {
    console.log('--downloading ' + FILENAME + '...');

    // extract the file name
    //var file_name = url.parse(URL).pathname.split('/').pop();
    // create an instance of writable stream
    var file = fs.createWriteStream(__dirname + '/' + FILENAME);

    // execute curl using child_process' spawn function
    var curl = spawn('curl', [URL]);
    // add a 'data' event listener for the spawn instance
    curl.stdout.on('data', function(data) { 
        size += 1;
        console.log('--loaded ' + FILENAME + ', size: ' + (parseFloat(file.bytesWritten) / 1000000) + 'MB');

        file.write(data); 

        if(DOWNLOAD !== undefined){
            if(DOWNLOAD){
                size = 0;
                var jsonfile = require('./' + FILENAME);
                var pathNew = jsonfile.outputs.netcdf;
                console.log(pathNew);            
                download_file_curl(pathNew, 
                    pathNew.substring(pathNew.lastIndexOf('/') + 1, pathNew.length));
            }
        }
    });
    // add an 'end' event listener to close the writeable stream
    curl.stdout.on('end', function(data) {
        file.end();
        console.log(FILENAME + ' downloaded to ' + __dirname);
    });
    // when the spawn child process exits, check if there were any errors and close the writeable stream
    curl.on('exit', function(code) {
        if (code != 0) {
            console.log('Failed: ' + code);
        }
    });
};


download_file_curl(FILE_URL, FILE_SAVE_PATH, true);

/*
const fs = require('fs');
const download = require('download');

var downloadFile = function(URL, FILENAME){
    console.log('--downloading ' + FILENAME + '...');

    download(URL).then(data => {
        console.log('loaded ' + FILENAME + '!');
        fs.writeFileSync(FILENAME, data);

        var jsonfile = require('./' + FILENAME);
        var pathNew = jsonfile.outputs.netcdf;
        console.log(pathNew);

        downloadFile(pathNew, 
            pathNew.substring(pathNew.lastIndexOf('/') + 1, pathNew.length));
    });
}


downloadFile(FILE_URL, FILE_SAVE_PATH);
*/


/**
 * https://www.npmjs.com/package/filedownloader
 */
/*
var Downloader = require("filedownloader");

var Dl = new Downloader({
    url: FILE_URL
}).on("start", function(){
    console.log("Download started") ;
}).on("progress", function (progress){
    console.log('Downloaded: ' + progress.pregress + '%'); 
}).on("error", function(e) {
    console.log('Some error occurred:' + e); 
}).on("end", function(){
    console.log('Download finished'); 
});
*/