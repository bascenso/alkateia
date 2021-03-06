
suppressPackageStartupMessages(library(httr))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(jsonlite))
#suppressPackageStartupMessages(library(xlsx))
suppressPackageStartupMessages(library(reshape2))

source("defs.R", encoding = "utf-8")
source("gameAPI.R", encoding = "utf-8")
source("storage.R", encoding = "utf-8")
source("maps.R", encoding = "utf-8")
source("dump.R", encoding = "utf-8")

## PC 1 folder
##setwd("c:/Drive/OneDrive/11.GitRepos/alkateia/R/")

## PC 2 folder (THIS ONE)
setwd("C:/Users/basce/Documents/Repos/alkateia/R")

## ===========================================================================================================
## Get clan data and build stats
##
options("stringsAsFactors" = FALSE)


clan <- list(tag = myclantag, name = "Alkateia PT")

clan$members <- getClanMembers(clan$tag, token)
clan$memberInfo <- getClanMemberDetails(clan$members$tag, token)
#clan$warlog <- getClanWarlog(clan$tag, token, warlogFile)
clan$warlog <- readRDS(warlogFile)
clan$riverRaceLog <- getClanRiverRaceLog(clan$tag, token, riverRaceLogFile)
clan$lastupdate <- Sys.time()

clan$memberInfo <- updateJoinDates(clan$memberInfo, playerFile)
clan$stats <- logClanStats(clan$memberInfo, clanStatsFile)


## War stats
cat("Building war stats... ")

clan$warStats <- buildWarStats(clan, nwars = 50)

## War participation map
warParticipationDF <- buildWarMap(clan, nwars = 50)

## Performance evolution map
evolutionDF <- buildEvolutionMap(clan, nperiod = 3, warsPerPeriod = 15)

cat("OK\n")

## RiverRace Stats
cat("Building river race stats... ")

clan$riverRaceStats <- buildRiverRaceStats(clan, nraces = 20)

clan$riverRaceStats$totalWarScore <- clan$riverRaceStats$totalFame + clan$riverRaceStats$totalRepairPoints
clan$riverRaceStats <- clan$riverRaceStats[order(desc(clan$riverRaceStats$totalWarScore)), ]

# Combine score for cw1 + cw2
# Not used anymore
#for (i in 1:nrow(clan$riverRaceStats)) {
#    if (nrow(clan$warStats[clan$warStats$tag == clan$riverRaceStats[i, ]$tag, ]) > 0)
#        clan$riverRaceStats[i, ]$totalWarScore <- clan$riverRaceStats[i, ]$totalWarScore + clan$warStats[clan$warStats$tag == clan$riverRaceStats[i, ]$tag, ]$WARSCORE
#}


cat("OK\n")



## ===========================================================================================================
## Generate HTML table files
##
cat("Generating files... ")

result <- dumpHTMLFile(
        c("warStats", "playerStats", "warMap", "playerEvolution", "riverRaceStats"),
        list(
            clan$warStats[(clan$warStats$currentMember == "Yes"), !(names(clan$warStats) %in% c("tag", "currentMember"))], 
            clan$memberInfo, 
            warParticipationDF[, names(warParticipationDF) != "tag"],
            evolutionDF[, names(evolutionDF) != "tag"],
            clan$riverRaceStats
        ),
        useImages = c(FALSE, FALSE, TRUE, FALSE, FALSE),
        dataPath
)

result <- storeLastUpdate(clan, dataPath)


## Dump tables to file
result <- dumpTables(list(clan$warStats[(clan$warStats$currentMember == "Yes"), !(names(clan$warStats) %in% c("tag", "currentMember"))], 
                          clan$memberInfo,
                          warParticipationDF[, names(warParticipationDF) != "tag"]),
                     c("warstats", "memberstats", "warmap"), dataPath)


## Merge all player stats (war and individual), and save to XLSX file
allStatsDF <- merge(clan$warStats, clan$memberInfo, by.x = "tag", by.y = "tag", all.x = TRUE)
allStatsDF <- allStatsDF[, !names(allStatsDF) %in% c("name.y")]
allStatsDF <- allStatsDF[order(desc(allStatsDF$WARSCORE)), ]


## write.xlsx2(allStatsDF, file = statsXLSfile, sheetName = "Dados", col.names = T, row.names = F, append = F)
## write.xlsx2(t(as.data.frame(descs)), statsXLSfile, sheetName = "Dicionário", col.names = F, row.names = F, append = T)

## cat("OK\n")