:: R executable path
:: Edit pathtorexe depending on your Rscript.exe installation path
:: main_r.bat -initiates the download of the default json file and its  and its NCDF file content
:: Uses 'R'
:: ciatph; 20181001
set pathtorexe="C:\Program Files\R\R-3.4.4\bin\x64\"

%pathtorexe%Rscript.exe gridload.R
pause