## Downloads the "Daily" Global Climatology from the NASA POWER API into R memory by
## traversing the world map's bounding box at increments of 
## 5 x 5 region of 1 degree values, (i.e. 100 points total)
## (Described in 'Using create_icasa' section from https://ropensci.github.io/nasapower/articles/nasapower.html) 
##
## Merges loaded daily weather data into (1) master data frame and exports it to CSV
## ciatph; 20181010


## Libraries and dependencies
source("lib/usepackage.R")
usepackage('dplyr')
usepackage('nasapower')



# Object for downloading Daily Global weather data 
# Internal global variables (set during object creation and processing):
#   @param max_lon: maximum x-axis 
#   @param max_lat: maximum y-axis 
#   @param steps: number of steps to increment/decrement the x and y axis values
#   @param lons: list of x-axis values, inremented by @steps
#   @param lats: list of y-axis values, inremented by @steps
#   @param temp_bbox: global (whole) bounding box
#   @param bbox: current (sub) bounding box being processed
#   @param print: flag to skip downloading. Prints only console logs
#   @param data: merged data from all grid cells
# Usage: d <- dataloader()
#        d$set(10, 8, 2)
#        d$load()
dataloader <- function(max_lon = 10, max_lat = 8, steps = 2, 
                       start_lon = 1, start_lat = 1,
                       lons = c(), lats = c(), numcols = 0, numlats = 0,
                       bbox = c(), temp_bbox = c(), print = FALSE, data = NULL, log = ''){

  # Get the incremental indices from +/- max (start) to +/- max (end)
  # max: maximum start/end
  # inc: value to increment max
  # negstart: list starts with a negative value. Defaults to TRUE
  getindices <- function(max, inc, negstart = TRUE){
    values = seq(from = -max, to = max, by = inc)
    
    if(negstart == FALSE){
      values = values * -1
    }
    return (values)
  }
  
  
  # Set the downloader's internal settings' values
  # Automatically sets the bounding box (bbox) from given @length_x and length_y
  # @param length_x: length of (positive) side of the x axis
  # @param length_y: length of (positive) side of the y axis
  # @param steps: interval values to increment/decrement the length_x and length_y
  set <- function(length_x = 10, length_y = 8, inc = 2){
    # base length of logitude (columns)
    max_lon <<- length_x
    
    # base length of latitude (rows)
    max_lat <<- length_y 
    
    # cell increments
    steps <<- inc 
    
    # final data frame
    if(is.null(data))
      data <<- data.frame()
    
    # List of columns (longitude): X-axis
    lons <<- getindices(max_lon, inc)
    
    # List of rows (latitude): y-axis
    lats <<- getindices(max_lat, inc, FALSE)     
    
    # Set the default number of columns and rows to process
    # to the full number of lons and lats
    numcols <<- length(lons)
    numrows <<- length(lats)    
  }
  
  
  # Set the number of grid rows to process
  setnumrows <- function(x) numrows <<- x 
  
  
  # Set the number of grid columns to process
  setnumcols <- function(x) numcols <<- x 
  
  
  # Set y-index on which to start row (latitude)
  setstarty <- function(x) {
    start_lat <<- x 
  }
  
  
  # Set x-index on which to start column (longitude)
  setstartx <- function(x) {
    start_lon <<- x
  }  
  
  
  # Set flag to only print loading console logs (downloads data if FALSE)
  setprint <- function(x) print <<- x
  
  
  # Set the log output
  setlog <- function(x){
    log <<- x
  }
  

  # Return the list of x-axis values
  getx <- function() return (lons)
  
  
  # Return the list of y-axis values
  gety <- function() return (lats)
  
  
  # Get the number of grid columns to process
  getnumcols <- function() return (numcols)
  
  
  # Get the number of grid rows to process
  getnumrows <- function() return (numrows)
  
  
  # Get the starting x-coordinate
  getstartx <- function() return (start_lon)
  
  
  # Get the starting y-coordinate 
  getstarty <- function() return (start_lat)
  
  
  # Return the loaded data
  getdata <- function() return (data)
  
  
  # Return the bounding box (from set() method)
  getbbox <- function() return (c(lons[1], lats[1], -lats[1], -lons[1]))
  
  
  # Return the current subset bounding box being processed
  getbboxcurrent <- function() return (temp_bbox)
  
  
  # Get the current logs
  getlog <- function() return (log)
  
  
  # Get object settings
  getsettings <- function(){
    return(
      data.frame(
        cols_to_process = numcols,
        rows_to_process = numrows,
        steps = steps,
        print = print,
        bbox = toString(c(lons[1], lats[1], -lats[1], -lons[1])),
        bbox_current = toString(temp_bbox)
      )
    )
  }  
  
  
  # Export data to CSV
  export <- function(){
    if(!is.null(data) & print == FALSE){
      write.csv(data, file = "data.csv")
    }
    else{
      print('Cannot export data')
    }
  }
  

  # Load global daily weather data inside each incremental bounding box
  # @param parametrs: a list() of equal-numbered items per row
  load <- function(parameters = list()){
    # Initial bounding box (upper left region)
    # bbox <- c(-175, 85, -175, 90)
    
    # Initialize row data container
    temp_row <- data.frame()     
    echolog <- ''
    l <- list()
    
    # latitudes
    for(i in start_lat:((start_lat + numrows) - 1)){
      temp_col <- data.frame()
     
      # longitudes
      for(j in start_lon:((start_lon + numcols) - 1)){
        # Current bounding box window
        x1 <- lons[j]
        y1 <- lats[i]
        x2 <- lons[j]
        y2 <- lats[i]
        
        # Compute the bounding box window
        if(y1 < 0){
          y1 <- y1 - (-steps)
        }
        else{
          y1 <- y1 - steps
        }
        
        if(x2 < 0){
          x2 <- x2 - (-steps)
        }
        else{
          x2 <- x2 - steps
        }     
        
        
        # TO-DO: error on x-traversal from 0 to positive
        print(paste('***X1', x1, 'at index', j))
        
        
        # Set the current bounding box window to process
        temp_bbox <<- c(x1, y1, x2, y2)
        l[[length(l) + 1]] <- temp_bbox
        print(paste('col', j, ', row', i, ' :: ', toString(temp_bbox)))
        
        # Call to the NASA POWER API to download specified data
        for(k in 1:length(parameters)){
          print(paste("--processing", toString(params[[k]]), "at cell [", i, '][', j, ']', toString(temp_bbox)))

          # Do no process data download
          if(print == TRUE)
            break          
          
          daily_region_ag <- get_power(community = "AG",
            lonlat = temp_bbox, 
            pars = params[[k]],
            dates = c("1985-01-01", "1985-01-02"),
            temporal_average = "DAILY") 
          
          print(paste('>>> length', nrow(daily_region_ag)))
          
          # Initialize the empty data frame
          if(nrow(temp_col) == 0){
            temp_col <- rbind(temp_col, daily_region_ag)
          }
          else{
            # Append variable columns to the existing data
            # temp_col parameters start at index no. 8 and above 
            temp_col <- cbind(temp_col, daily_region_ag[, c(8:length(daily_region_ag))])
          }
        }
      }
      
      print(paste('::::::>> ENCODING ROW #', i))
      temp_row <- rbind(temp_row, temp_col)
    }    
    
    data <<- temp_row
    log <<- l
  }
  
  
  # Return this object's methods
  return(list(
    set = set,
    setnumrows = setnumrows,
    setnumcols = setnumcols,
    setstarty = setstarty,
    setstartx = setstartx,
    setprint = setprint,
    getx = getx,
    gety = gety,
    getbbox = getbbox,
    getbboxcurrent = getbboxcurrent,
    getnumrows = getnumrows,
    getnumcols = getnumcols,
    getstartx = getstartx,
    getstarty = getstarty,
    getdata = getdata,
    getlog = getlog,
    getsettings = getsettings,
    load = load,
    export = export
  ))
}


##
## Supplementary functions
## -----------------------------------------------------------------


# Returns a formatted list() of vectors into a list() of vectors with
# equal number of items in each group/category
# @param itemslist: a list() of vectors; variables[[1]] = c(), [[2]] = c(), ...
# @param: maxItems: number of items to contain in each list() inside the masterlist
formatinput <- function(itemslist, maxItems = 3){
  masterlist <- list()
  row_inc <- 1
  col_inc <- 1
  max <- maxItems
  
  temp <- c()
  
  for(i in 1:length(itemslist)){
    for(j in 1:length(itemslist[[i]])){
      if(col_inc <= max){
        # Encode item into a temporary vector list
        temp[col_inc] <- itemslist[[i]][j]
        
        if(col_inc == max){
          # Encode the temporary vector list into the master list
          masterlist[[row_inc]] <- temp
          
          # Reset tempoary containers and counters
          temp <- c()
          col_inc <- 1
          
          # Increment row counter
          row_inc <- row_inc + 1
        }
        else{
          # Increment column counter
          col_inc <- col_inc + 1
          
          # Encode the temporary vector list into the master list
          # if there are less items than @max and there are no more
          # rows to process
          if(j == length(itemslist[[i]]) & length(temp) > 0 & i == length(itemslist)){
            masterlist[[row_inc]] <- temp
            
            temp <- c()
            col_inc <- 1
            row_inc <- row_inc + 1
          }          
        }
      }
    }
  }
  
  return (masterlist)
}
