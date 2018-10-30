## ===========================================================================================================
## Functions to build the HTML file


# TEST: writeHTMLFile(allStatsDF, templateFile, outputFile)

## ===========================================================================================================
## Function writeHTMLFile(stats, template, output) - writes the HTML file replacing the tag with the table
##      tableTag - list of table tags to replace in the template
##      stats - list of DFs with the data (must have the same order as the tags)
##      useImages - list of TRUE/FALSE indicating wheather to use images or not for the table
##      templateFile - HTML template to replace the table code
##      outputFile - file to output the result (template + table data)

writeHTMLFile <- function(tableTag, stats, useImages, template, output) {
    
    if (!file.exists(template)) {
        warning(paste(template, ":: Template file not found."))
        return("");
    }
    
    if (length(tableTag) == 0 || length(stats) == 0 || length(stats) != length(tableTag)) {
        warning("writeHTML file not possible: arguments of 0 or different length")
        return("")
    }
    
    # Read the template
    con <- file(template, open = "r") # Don't use enconding here
    htmlCode <- readLines(con, encoding = "UTF-8")
    close(con)
    
    # Generate new HTML replacing the tags with the table data
    for (i in 1:length(tableTag)) {
        htmlCode <- sub(tableTag[[i]], buildHTMLTable(stats[[i]], useImages[i]), htmlCode)
    }
    
    # Write output file
    con <- file(output, open = "w")
    writeLines(htmlCode, con, useBytes = T)
    close(con)
}


## ===========================================================================================================
## Function buildHTMLTable(statsTable) - builds the HTML table string
##      statsTable - DF with the data
##      useImages - wheather to convert some strings to images
##
buildHTMLTable <- function (statsTable, useImages = FALSE) {

    if (nrow(statsTable) < 1) return ("Dados não disponíveis...")
    
    prettyNames <- t(data.frame(clanCols))
    
    ## TAG <table></table> must be in the template

    ## TABLE HEAD
    innerHTML <- "<thead>"
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

            if (j == 1) { # first cell with class = lalign
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
    
    innerHTML
}




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
