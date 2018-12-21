
suppressPackageStartupMessages(library(httr))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(jsonlite))
suppressPackageStartupMessages(library(xlsx))
suppressPackageStartupMessages(library(reshape2))

source("defs.R", encoding = "utf-8")
source("gameAPI.R", encoding = "utf-8")
source("storage.R", encoding = "utf-8")
source("maps.R", encoding = "utf-8")
source("dump.R", encoding = "utf-8")

setwd("c:/Data/11.GitRepos/alkateia/R/")

## ===========================================================================================================
## Get clan data and build stats
##
options("stringsAsFactors" = FALSE)


clan <- list(tag = myclantag, name = "Alkateia PT")

clan$members <- getClanMembers(clan$tag, token)
clan$memberInfo <- getClanMemberDetails(clan$members$tag, token)
clan$warlog <- getClanWarlog(clan$tag, token, warlogFile)
clan$lastupdate <- Sys.time()

clan$memberInfo <- updateJoinDates(clan$memberInfo, playerFile)
clan$stats <- logClanStats(clan$memberInfo, clanStatsFile)

clan$warStats <- buildWarStats(clan, "all")


## War participation map
warParticipationDF <- buildWarMap(clan, nwars = "all")

## Performance evolution map
evolutionDF <- buildEvolutionMap(clan, nperiod = 3, warsPerPeriod = 15)


# ============================================================================================================
# NEW CODE
.__exclude <- function() {

    clan$tables <- list()
    clan$tables[[1]] <- prepareWarstatsTable(clan)
    names(clan$tables) <- "warstats"
    
    
    prepareWarstatsTable <- function(cl) {
        
        removeCols <- c("tag", "currentMember")
        nwars <- max(cl$warStats$warsEntered)
        
        theTable <- cl$warStats[cl$warStats$currentMember == "Yes", !(names(cl$warStats) %in% removeCols)]
        
        theTable$pctStatus <- rep("HIGH", nrow(theTable))
        theTable[theTable$pctLastPeriod < 80, "pctStatus"] <- "MEDIUM"
        theTable[theTable$pctLastPeriod < 45, "pctStatus"] <- "LOW"
        
        for (i in 1:nrow(theTable)) {
            theTable$imgPct[i] <- switch(theTable$pctStatus[i],
                                         HIGH = "img/high.png",
                                         MEDIUM = "img/med.png",
                                         LOW = "img/low.png")
        }
        
        
        theTable$scoreStatus <- rep("GREAT", nrow(theTable))
        theTable[theTable$WARSCORE < 7.5 * nwars, "scoreStatus"] <- "HIGH"
        theTable[theTable$WARSCORE < 5 * nwars, "scoreStatus"] <- "MEDIUM"
        theTable[theTable$WARSCORE < 2.5 * nwars, "scoreStatus"] <- "LOW"
        theTable[theTable$WARSCORE < 0, "scoreStatus"] <- "DANGER"
        
        theTable$imgScore <- rep ("", nrow(theTable))
        for (i in 1:nrow(theTable)) {
            theTable$imgScore <- NULL
        }
    }

}
# END NEW CODE


## ===========================================================================================================
## Generate HTML table files
##
result <- dumpHTMLFile(
        c("warStats", "playerStats", "warMap", "playerEvolution"),
        list(
            clan$warStats[(clan$warStats$currentMember == "Yes"), !(names(clan$warStats) %in% c("tag", "currentMember"))], 
            clan$memberInfo, 
            warParticipationDF[, names(warParticipationDF) != "tag"],
            evolutionDF[, names(evolutionDF) != "tag"]
        ),
        c(FALSE, FALSE, TRUE, FALSE),
        dataPath
)

result <- storeLastUpdate(clan, dataPath)



## Dump tables to file
result <- dumpTables(list(clan$warStats[(clan$warStats$currentMember == "Yes"), !(names(clan$warStats) %in% c("tag", "currentMember"))], 
                          clan$memberInfo,
                          warParticipationDF[, names(warParticipationDF) != "tag"]),
                     c("warstats", "memberstats", "warmap"), dataPath)


## Merge all player stats (war and individual), and save to XLXS file
allStatsDF <- merge(clan$warStats, clan$memberInfo, by.x = "tag", by.y = "tag", all.x = TRUE)
allStatsDF <- allStatsDF[, !names(allStatsDF) %in% c("name.y")]
allStatsDF <- allStatsDF[order(desc(allStatsDF$WARSCORE)), ]


write.xlsx2(allStatsDF, file = statsXLSfile, sheetName = "Dados", col.names = T, row.names = F, append = F)
write.xlsx2(t(as.data.frame(descs)), statsXLSfile, sheetName = "Dicionário", col.names = F, row.names = F, append = T)

