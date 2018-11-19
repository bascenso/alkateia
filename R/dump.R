#
#' function storeLastUpdate() - writes the current date to the lastupdate file
#' 
#' @param locationFolder folder to place the file
#'
storeLastUpdate <- function(locationFolder) {
    
    outFile <- paste(locationFolder, "/", "lastupdate.html", sep = "")
    con <- file(outFile, open = "w", encoding = "UTF-8")
    
    writeLines(paste("<h5>Última actualização de dados: ", format(Sys.time(), "%d de %B de %Y, %Hh%M"), "<h5>", sep = ""), con)
    
    close(con)
    
    TRUE
}


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

## ===========================================================================================================
## Function dumpHTMLFile(tNames, tList, useImages, locationFolder) - dumps the tables as HTML files
##      tNames - list of tables names to use in file names
##      tList - list of DFs with the data (must have the same order as the names)
##      useImages - list of TRUE/FALSE indicating wheather to use images or not for the table
##      locationFolder - folder to write the output files
##
## Dumps a list of tables to HTML files

dumpHTMLFile <- function(tNames, tList, useImages, locationFolder) {

    if (!file.exists(locationFolder)) {
        warning(paste(locationFolder, ":: Folder not found."))
        return("")
    }
    
    if (length(tNames) == 0 || length(tList) == 0 || length(tNames) != length(tList)) {
        warning("write HTML file not possible: arguments of 0 or different length")
        return("")
    }
    
    # Generate new HTML replacing the tags with the table data
    for (i in 1:length(tNames)) {
        htmlCode <- buildHTMLTable(tNames[i], tList[[i]], useImages[i])
    
        # Write output file
        outFile <- paste(locationFolder, "/", tolower(tNames[i]), ".html", sep = "")
        con <- file(outFile, open = "w")

        writeLines(htmlCode, con, useBytes = T)
        close(con)
    }
    
    i
}

## ===========================================================================================================
## Function buildHTMLTable(statsTable) - builds the HTML table string
##      tName - name of the table to use in the id
##      statsTable - DF with the data
##      useImages - wheather to convert some strings to images
##
buildHTMLTable <- function (tName, statsTable, useImages = FALSE) {
    
    if (nrow(statsTable) < 1) return ("Dados não disponíveis...")
    
    prettyNames <- t(data.frame(clanCols))
    
    ## TAG <table>
    innerHTML <- paste("<table id='", tName, "' cellspacing='0' cellpadding='0'>", sep = "")

    ## TABLE HEAD
    innerHTML <- paste(innerHTML, "<thead>", sep = "\n")
    innerHTML <- paste(innerHTML, "<tr>", sep = "\n")
    
    for(i in 1:length(names(statsTable))) {
        iName = match(names(statsTable)[i], prettyNames)
        prettyName <- ifelse(is.na(iName), names(statsTable)[i], prettyNames[iName, 2])
        
        colName <- paste("<th><span>", prettyName, "</span></th>", sep = "")
        innerHTML <- paste(innerHTML, colName, sep = "\n")
    }
    
    innerHTML <- paste(innerHTML, "</tr>", sep = "\n")
    innerHTML <- paste(innerHTML, "</thead>", sep = "\n")
    
    
    ## TABLE BODY / ROWS
    innerHTML <- paste(innerHTML, "<tbody>", sep = "\n")
    
    for (i in 1:nrow(statsTable)) { # for each row
        
        innerHTML <- paste(innerHTML, "<tr>", sep = "\n")
        
        for (j in 1:ncol(statsTable)) { # for each cell
            
            if (j == 1 || names(statsTable[j]) == "name") { # first cell with class = lalign
                cellData <- paste("<td class='lalign'>", statsTable[i, j], "</td>", sep = "")
                
            } else if (is.na(statsTable[i, j])) {
                cellData <- paste("<td class ='valueNA'>", statsTable[i, j], "</td>", sep = "")
                
            } else if (useImages) {
                cellData <- getImage(as.character(statsTable[i, j]))
                
            } else {
                cellData <- paste("<td>", statsTable[i, j], "</td>", sep = "")
            }
            
            innerHTML <- paste(innerHTML, cellData, sep = "\n")
        }
        
        innerHTML <- paste(innerHTML, "</tr>", sep = "\n")
    }
    
    innerHTML <- paste(innerHTML, "</tbody>", sep = "\n")
    innerHTML <- paste(innerHTML, "</table>", sep = "\n")
    
    innerHTML
}



#' Function getImage() - returns the correct image for each result in the war
#' 
#' @param value result of the player in the war. May be {MIA, -BF, 0, 1, 2}
#' @return returns the HTML for the correct image
#' @author Bruno Ascenso
#' 
getImage <- function(value) {
    
    retString <- switch(value,
                        "MIA" = paste("<td class ='valueMIA'>", value, "</td>", sep = ""),
                        "-BF" = paste("<td class ='valueBF'>", "<img class='warIcon' src='img/cw-war-miss.png'>", "</td>", sep = ""),
                        "0"   = paste("<td class ='valueBF'>", "<img class='warIcon' src='img/cw-war-loss.png'>", "</td>", sep = ""),
                        "1"   = paste("<td class ='valueBF'>", "<img class='warIcon' src='img/cw-war-win.png'>", "</td>", sep = ""),
                        "2"   = paste("<td class ='valueBF'>", "<img class='warIcon' src='img/cw-war-win.png'><img class='warIcon' src='img/cw-war-win.png'>", "</td>", sep = ""),
                        paste("<td>", value, "</td>", sep = "")
    )
    retString
}
