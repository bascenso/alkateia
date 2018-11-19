
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


## ===========================================================================================================
## Load clan data
##

options("stringsAsFactors" = FALSE)

# Get my clan member list
message("Loading clan member list...")
membersDF <- getClanMembers(myclantag, token)

# Get detailed member info
message("Loading detailed member info...")
detailedMembersDF <- getClanMemberDetails(myclantag, token)

# Get clan warlog and append to file
message("Loading war log...")
warlogDF <- getClanWarlog(myclantag, token, warlogFile)

# Update data retrieval timestamp
result <- storeLastUpdate(dataPath)


## ===========================================================================================================
## Store local files
##

## Player join dates
detailedMembersDF <- updateJoinDates(detailedMembersDF, playerFile)

## Clan stats
clanStatsDF <- logClanStats(detailedMembersDF, clanStatsFile)



## ===========================================================================================================
## Build stats
##
message("Building stats...")

## War stats
statsDF <- buildWarStats(warlogDF, membersDF, detailedMembersDF, "all")

## War participation map
warParticipationDF <- buildWarMap(warlogDF, detailedMembersDF, nwars = "all")

## Performance evolution map
evolutionDF <- buildEvolutionMap(warlogDF, membersDF, detailedMembersDF, nperiod = 3, warsPerPeriod = 15)



## ===========================================================================================================
## Generate HTML table files
##
result <- dumpHTMLFile(
        c("warStats", "playerStats", "warMap", "playerEvolution"),
        list(statsDF[(statsDF$currentMember == "Yes"), !(names(statsDF) %in% c("tag", "currentMember"))], 
             detailedMembersDF, 
             warParticipationDF[, names(warParticipationDF) != "tag"],
             evolutionDF[, names(evolutionDF) != "tag"]),
        c(FALSE, FALSE, TRUE, FALSE),
        dataPath
)


## Dump tables to file
result <- dumpTables(list(statsDF[(statsDF$currentMember == "Yes"), !(names(statsDF) %in% c("tag", "currentMember"))], 
                          detailedMembersDF, 
                          warParticipationDF[, names(warParticipationDF) != "tag"]),
                     c("warstats", "memberstats", "warmap"), dataPath)


## Merge all player stats (war and individual), and save to XLXS file
allStatsDF <- merge(statsDF, detailedMembersDF, by.x = "tag", by.y = "tag", all.x = TRUE)
allStatsDF <- allStatsDF[, !names(allStatsDF) %in% c("name.y")]
allStatsDF <- allStatsDF[order(desc(allStatsDF$WARSCORE)), ]


write.xlsx2(allStatsDF, file = statsXLSfile, sheetName = "Dados", col.names = T, row.names = F, append = F)
write.xlsx2(t(as.data.frame(descs)), statsXLSfile, sheetName = "Dicionário", col.names = F, row.names = F, append = T)

