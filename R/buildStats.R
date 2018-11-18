
suppressPackageStartupMessages(library(httr))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(jsonlite))
suppressPackageStartupMessages(library(xlsx))
suppressPackageStartupMessages(library(reshape2))

source("defs.R", encoding = "utf-8")
source("clans.R", encoding = "utf-8")
source("players.R", encoding = "utf-8")
source("stats.R", encoding = "utf-8")
source("dumpTables.R", encoding = "utf-8")

options("stringsAsFactors" = FALSE)

## ================ Get my clan member list
message("Loading clan member list...")
membersDF <- getClanMembers(myclantag, token)


## ================ Get my clan warlog and append to file
message("Loading war log...")
warlogDF <- getClanWarlog(myclantag, token, warlogFile)


## ================ Get detailed member info
message("Loading detailed member info...")
detailedMembersDF <- getClanMemberDetails(myclantag, token)



## ===========================================================================================================
## Update player join dates
##
detailedMembersDF <- updateJoinDates(detailedMembersDF, playerFile)


## ===========================================================================================================
## Build war stats
##
message("Building stats...")
statsDF <- buildWarStats(warlogDF, membersDF, detailedMembersDF, "all")


## ===========================================================================================================
## Build war participation map
##
warParticipationDF <- buildWarMap(warlogDF, detailedMembersDF, nwars = "all")


## ===========================================================================================================
## Build performance evolution map
##
evolutionDF <- buildEvolutionMap(warlogDF, membersDF, detailedMembersDF, nperiod = 3, warsPerPeriod = 15)


## ===========================================================================================================
## Create a new entry with the clan stats
##
clanStatsDF <- logClanStats(detailedMembersDF, clanStatsFile)


## Build HTML table files
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


#write.xlsx2(allStatsDF, file = statsXLSfile, sheetName = "Dados", col.names = T, row.names = F, append = F)
#write.xlsx2(t(as.data.frame(descs)), statsXLSfile, sheetName = "Dicionário", col.names = F, row.names = F, append = T)

