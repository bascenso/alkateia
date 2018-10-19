## ===========================================================================================================
## Functions to build the HTML file


# TEST: writeHTMLFile(allStatsDF, templateFile, outputFile)

## ===========================================================================================================
## Function writeHTMLFile(stats, template, output) - writes the HTML file replacing the tag with the table
##      statsTable - DF with the data
##      templateFile - HTML template to replace the table code
##      outputFile - file to output the result (template + table data)

writeHTMLFile <- function(stats, template, output) {
    
    if (!file.exists(template)) {
        warning(paste(template, ":: Template file not found."))
        return("");
    }
    
    # Read the template
    con <- file(template, open = "r")
    htmlCode <- readLines(con)
    close(con)
    
    # Generate new HTML replacing the tag with the table
    htmlNewCode <- sub(customTableTag, buildHTMLTable(stats), htmlCode)
    
    # Write output file
    con <- file(output, open = "w")
    writeLines(htmlNewCode, con)
    close(con)
}

## ===========================================================================================================
## Function buildHTMLTable(statsTable) - builds the HTML table string
##      statsTable - DF with the data

buildHTMLTable <- function (statsTable) {

    if (nrow(statsTable) < 1) return ("Dados não disponíveis...")
    
    prettyNames <- t(data.frame(clanCols))
    
    
    ## INITIAL TAG
    innerHTML <- "<table id='keywords' cellspacing='0' cellpadding='0'>"
    
    ## TABLE HEAD
    innerHTML <- paste(innerHTML, "<thead>", sep = "\n")
    innerHTML <- paste(innerHTML, "<tr>", sep = "\n")
    
    for(i in 1:length(names(statsTable))) {
        iName = match(names(statsTable)[i], prettyNames)
        prettyName <- ifelse(is.na(iName), names(statsTable)[i], tNames[iName, 2])
        
        colName <- paste("<th>", prettyName, "</th>", sep = "")
        innerHTML <- paste(innerHTML, colName, sep = "\n")
    }
    
    innerHTML <- paste(innerHTML, "</tr>", sep = "\n")
    innerHTML <- paste(innerHTML, "</thead>", sep = "\n")

        
    ## TABLE BODY / ROWS
    innerHTML <- paste(innerHTML, "<tbody>", sep = "\n")
    
    for (i in 1:nrow(statsTable)) { # for each row
        innerHTML <- paste(innerHTML, "<tr>", sep = "\n")

        for (j in 1:ncol(statsTable)) { # for each cell
            if (j == 1) # first cell with class = lalign
                cellData <- paste("<td class='lalign'>", statsTable[i, j], "</td>", sep = "")
            else
                cellData <- paste("<td>", statsTable[i, j], "</td>", sep = "")

            innerHTML <- paste(innerHTML, cellData, sep = "\n")
        }

        innerHTML <- paste(innerHTML, "</tr>", sep = "\n")
    }
    
    innerHTML <- paste(innerHTML, "</tbody>", sep = "\n")
    
    ## CLOSING TAG
    innerHTML <- paste(innerHTML, "</table>", sep = "\n")
    
    innerHTML
}