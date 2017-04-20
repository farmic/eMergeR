# r alternative to PST's 'e-merge' program to merge e-prime output files. Note that it parses the .txt files rather than the edat files!

# the function is a rather simple addition to the edatparser function by ahebrank, which is taking care of the actual parsing of the .txt files :)

# The eMergeR function searches the currently set working directory for all files which names contain the string(s) specified in the 'filenamecontains' argument, 
# parses them using ahebrank's edatparser function, adds header-info (Subject, Session, etc) and eventually returns a dataframe with all the files parsed and merged.
# Optionally, the output dataframe can be saved (in the working directory) as a .csv file.

# the default value of the filenamecontains argument is set to ".txt" so that calling eMergeR() tells the function to simply merge all .txt files found in the currently set working directory. 
  

eMergeR <- function(filenameContains = ".txt", saveFile = F, fileName = "eMergeRd.csv") {
    
    if(!require(edatparser)){
      devtools::install_github('ahebrank/edatparser')
      library(edatparser)
    }
    
    files <- list.files(pattern = filenameContains)
    
    do.call(rbind,lapply(files, function(x) {
      e <- edat(x)
      
      header <- as.data.frame(t(e$header_info))
      names(header)
      headercut <- header[,which(names(header) == "SessionDate"):length(names(header))]
      
      dat <- as.data.frame(e)
      
      dat <- cbind(headercut, dat) }) )
    
    if (saveFile == T ){  write.csv(df, fileName)}
  }

# examples: 

df <- eMergeR() # merge all .txt files in the working directory

df <- eMergeR("VAS") # merge all files for which the filename contains "VAS"
# note that in the above example: if the edat2 files are also in the folder they'll be included and the function will throw errors as it can't parse them.

df <- eMergeR(glob2rx("*VAS*.txt")) # merge all files for which the filename contains both "VAS" and ".txt" (using glob2rx to construct reg expr, * is a wildcard)


eMergeR(glob2rx("*VAS*.txt"), saveFile = T, fileName = "othernamethandefault.csv") # merge files with "VAS" and ".txt" in their name and safe results as .csv with set name.

 