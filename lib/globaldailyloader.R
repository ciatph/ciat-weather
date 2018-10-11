## Downloads the "Daily" Global Climatology from the NASA POWER API into R memory by
## traversing the world map's bounding box at increments of 
## 5 x 5 region of 1 degree values, (i.e. 100 points total)
## (Described in 'Using create_icasa' section from https://ropensci.github.io/nasapower/articles/nasapower.html) 
##
## Merges loaded daily weather data into (1) master data frame and exports it to CSV
## ciatph; 20181010


## Libraries and dependencies
source("usepackage.R")
usepackage('nasapower')



# Object for downloading Daily Global weather data 
# Usage: d <- dataloader()
#        d$set(10, 8, 2)
#        d$load()
dataloader <- function(length_x = 10, length_y = 8, steps = 2, data = NULL){

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
  set <- function(length_x = 10, length_y = 8, steps = 2, numrows = 0, numcols = 0, data = NULL){
    # base length of logitude (columns)
    max_lon <<- length_x
    
    # base length of latitude (rows)
    max_lat <<- length_y 
    
    # cell increments
    inc <<- steps 
    
    # final data frame
    if(is.null(data))
      data <<- data.frame()
    
    # List of columns (longitude): X-axis
    lons <<- getindices(max_lon, inc)
    
    # List of rows (latitude): y-axis
    lats <<- getindices(max_lat, inc, FALSE)     
    
    # Set the default number of columns and rows to process
    numcols <<- length(lons)
    numrows <<- length(lats)    
  }
  
  
  # Set the number of grid rows to process
  setnumrows <- function(x) numrows <<- x + 2
  
  
  # Set the number of grid columns to process
  setnumcols <- function(x) numcols <<- x + 2
  

  # Return the list of x-axis values
  getx <- function() return (lons)
  
  
  # Return the list of y-axis values
  gety <- function() return (lats)
  
  
  # Get the number of grid columns to process
  getnumcols <- function() return (numcols)
  
  
  # Get the number of grid rows to process
  getnumrows <- function() return (numrows)
    
  
  # Return the loaded data
  getdata <- function() return (data)
  
  
  # Return the bounding box (from set() method)
  getbbox <- function() return (c(lons[1], lats[1], -lats[1], -lons[1]))
  

  # Load global daily weather data inside each incremental bounding box
  load <- function(){
    # Initial bounding box (upper left region)
    bbox <- c(-175, 85, -175, 90)
    #bbox <- c(-180, 85, -175, 90)
    
    # testing bounds
    ttbox <- c(-10, 8, -8, 10)
    ttbox
    
    for(i in 2:(numrows - 1)){
      echo <- ''
      
      for(j in 2:(numcols - 1)){
        echo <- (paste0(echo, '[', lats[i], ',', lons[j], ']'))
        print(c(lons[j], lats[i], -lats[i], -lons[j]))
        
        
      }
      
      print(echo)
    }    
  }
  
  
  # Return this object's methods
  return(list(
    set = set,
    setnumrows = setnumrows,
    setnumcols = setnumcols,
    getx = getx,
    gety = gety,
    getbbox = getbbox,
    getnumrows = getnumrows,
    getnumcols = getnumcols,
    getdata = getdata,
    load = load    
  ))
}


##
## Supplementary functions
## -----------------------------------------------------------------


# Returns a formatted list of vectors into a list of vectors with
# equal number of elements in each group
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
        print(paste('Encode normal', itemslist[[i]][j], col_inc, j))
        # Encode item into a temporary vector list
        temp[col_inc] <- itemslist[[i]][j]
        
        if(col_inc == max){
          print(paste('--keep', temp))
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
          # if there are less items than @max
          if(j == length(itemslist[[i]]) & length(temp) > 0 & i == length(itemslist)){
            print(paste('--KEEP!', temp))
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
