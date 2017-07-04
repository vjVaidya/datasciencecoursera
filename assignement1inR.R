## practical exercise in R
## directory is the character of the vector of length 1 indicating location of the CSV files
## directory <- setwd("C:/Users/im_g/workspace/datasciencecoursera/specdata")
pollutantmean <- function(directory, pollutant, id = 1:332){
  ## stores the csv file names as a list
  ## listOfFiles <- (Sys.glob("*.csv"))
  ## extract each filename as a list
  allFiles <- list.files(path = directory, full.names = TRUE)
  ## read the files one by one
  ## read.csv(files[id])
  ## pollutant is a character vector of length 1 indicating the name of the pollutant for which we calculate the mean i.e. Sulphate or Nitrate
  ## id is the integer vector indicating the monitor ID numbers
  ## the mean of the pollutant across all monitors list in the id vector ignoring NA withour roundoff is to be returned
  selectedData <- data.frame()
  for (i in id){
    selectedData <- rbind (selectedData, read.csv(files[i]))
  }
  if (pollutant == 'sulfate'){
    mean(selectedData$sulfate, na.rm = TRUE)
  } else if (pollutant == 'nitrate'){
    mean(selectedData$nitrate, na.rm = TRUE)
  }
}

