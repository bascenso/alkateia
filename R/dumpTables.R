
dumpTables <- function(tableList, tableNames, dataFolder) {

    if (length(tableList) == 0) return ("")

    if (!file.exists(dataFolder)) return ("")
    
    # Dump each data frame in the list
    for (i in 1:length(tableList)) {

        if (is.na(tableNames[i]))
            path <- paste(dataFolder, "no_name", sep = "")
        else
            path <- paste(dataFolder, names[i], sep = "")
        
        # Dump to csv
        filePath <- paste(path, ".csv", sep = "")
        write.csv2(tableList[i], file = filePath, append = FALSE)
        
        # Dump to xls
        filePath <- paste(path, ".csv", sep = "")
        write.xlsx2(tableList[i], file = filePath, sheetName = "Info", col.names = T, row.names = F, append = F)

    }

    i    
}