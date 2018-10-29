
library(httr, quietly = T)
library(dplyr, quietly = T)
library(data.table, quietly = T)
library(jsonlite, quietly = T)
library(xlsx, quietly = T)
library(reshape2, quietly = T)

source("defs.R", encoding = "utf-8")
source("clans.R", encoding = "utf-8")
source("players.R", encoding = "utf-8")
source("stats.R", encoding = "utf-8")
source("HTMLTable.R", encoding = "utf-8")
source("dumpTables.R", encoding = "utf-8")


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
## Build war stats
##
message("Building stats...")
statsDF <- buildWarStats(warlogDF, membersDF, detailedMembersDF, "all")


## ===========================================================================================================
## Update player join dates
##
detailedMembersDF <- updateJoinDates(detailedMembersDF, playerFile)


## ===========================================================================================================
## Build war participation map
##
warParticipationDF <- buildWarMap(warlogDF, detailedMembersDF, nwars = "all")



## Build HTML table with war stats and individual stats
writeHTMLFile(list(clanWarTableTag, playerTableTag, warMapTag),
              list(statsDF[(statsDF$currentMember == "Yes"), !(names(statsDF) %in% c("tag", "currentMember"))], 
                   detailedMembersDF, 
                   warParticipationDF[, names(warParticipationDF) != "tag"]),
              templateFile, outputFile)


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


## Create a new entry with the clan stats
clanStatsDF <- logClanStats(detailedMembersDF, clanStatsFile)
