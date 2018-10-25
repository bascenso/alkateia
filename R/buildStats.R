
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


## Build HTML table with war stats and individual stats
writeHTMLFile(list(clanWarTableTag, playerTableTag),
              list(statsDF[(statsDF$currentMember == "Yes"), !(names(statsDF) %in% c("tag", "currentMember"))], 
                   detailedMembersDF),
              templateFile, outputFile)


## Merge all player stats (war and individual), and save to XLXS file
allStatsDF <- merge(statsDF, detailedMembersDF, by.x = "tag", by.y = "tag", all.x = TRUE)
allStatsDF <- allStatsDF[, !names(allStatsDF) %in% c("name.y")]
allStatsDF <- allStatsDF[order(desc(allStatsDF$WARSCORE)), ]


write.xlsx2(allStatsDF, file = statsXLSfile, sheetName = "Dados", col.names = T, row.names = F, append = F)
write.xlsx2(t(as.data.frame(descs)), statsXLSfile, sheetName = "Dicionário", col.names = F, row.names = F, append = T)


## Create a new entry with the clan stats
clanStatsDF <- logClanStats(detailedMembersDF, clanStatsFile)


#===========================================================================
# THIS CODE MUST MOVE TO A FUNCTION!!!


# cast the DF to have the participation per war (only for current members)
onlyCurrentMembersDF <- warlogDF[warlogDF$tag %in% membersDF$tag, ]
warParticipationDF <- dcast(data = onlyCurrentMembersDF, 
                            formula = tag + name ~ as.character(as.Date(onlyCurrentMembersDF$warEnd)), 
                            value.var = "wins", 
                            fill = "MIA")

# Add battle misses
missesDF <- warlogDF[warlogDF$battlesPlayed == 0, ]
missesDF$warEnd <- as.character(as.Date(missesDF$warEnd))
missesDF$tag <- as.character(missesDF$tag)

for (i in 1:nrow(missesDF))
    warParticipationDF[warParticipationDF$tag == missesDF[i, ]$tag, missesDF[i, ]$warEnd] <- "-BF"

# Add members with no wars


# Add NA for wars where the member was not yet in the clan
# For each member and for each battle (date)
for (iMember in 1:nrow(warParticipationDF)) {

    for (iCol in 1:length(colnames(warParticipationDF))) {
        if (colnames(warParticipationDF)[iCol] == "tag" || colnames(warParticipationDF)[iCol] == "name") next

        joinDate <- detailedMembersDF[detailedMembersDF$tag == as.character(warParticipationDF[iMember, "tag"]), ]$joined
        warDate <- colnames(warParticipationDF)[iCol]

        if (warDate < joinDate) warParticipationDF[iMember, iCol] <- NA

    }
}
