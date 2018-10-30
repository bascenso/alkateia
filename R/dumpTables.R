## ===========================================================================================================
## Function dumpTables(tableList, tableNames, dataFolder)
##      tableList - list of data frames to dump to file
##      tableNames - names of the tables to dump used to create the file names
##      dataFolder - folder to dump the tables
##
## Dumps a list of tables to file, both in csv and xlsx formats

dumpTables <- function(tableList, tableNames, dataFolder) {

    if (length(tableList) == 0) return ("")

    if (!file.exists(dataFolder)) return ("")
    
    # Dump each data frame in the list
    for (i in 1:length(tableList)) {

        if (is.na(tableNames[i])) {
            path <- paste(dataFolder, "/no_name", sep = "")
        } else {
            path <- paste(dataFolder, "/", tableNames[i], sep = "")
        }
        
        # Dump to csv
        filePath <- paste(path, ".csv", sep = "")
        write.csv2(tableList[[i]], file = filePath, row.names = FALSE)
        
        # Dump to xls
        filePath <- paste(path, ".xlsx", sep = "")
        write.xlsx2(tableList[i], file = filePath, sheetName = "Info", col.names = T, row.names = F, append = F)

    }

    i    
}