
library(httr, quietly = T)
library(dplyr, quietly = T)
library(data.table, quietly = T)
library(jsonlite, quietly = T)
library(xlsx, quietly = T)

source("defs.R")
source("clans.R", encoding="utf-8")
source("players.R", encoding="utf-8")
source("HTMLTable.R", encoding="utf-8")


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

# Get the battle totals
s <- split(warlogDF, warlogDF$tag)
statsDF <- data.frame(t(data.frame(lapply(s, function(x) {
                                            colSums(x[, c("cardsEarned", "battlesPlayed", "wins", "collectionDayBattlesPlayed")])
                                            }
                                        ))))


# Add tag and name
statsDF$tag <- sub("X.", "#", rownames(statsDF))

statsDF$name <- rep(NA, nrow(statsDF))

for (i in 1:nrow(statsDF)) {
    player = as.character(statsDF$tag[i])
    occ = match(player, warlogDF$tag)
    statsDF$name[i] <- as.character(warlogDF$name[occ])
}

# Add number of participations in wars for each member
participations <- data.frame(table(unlist(warlogDF$tag)))
statsDF <- merge(statsDF, participations, by.x = "tag", by.y = "Var1", all = TRUE)
setnames(statsDF, "Freq", "warsEntered")

## Add current members with no participations
for (i in 1:nrow(membersDF)) {
    if(!any(membersDF$tag[i] == statsDF$tag)) {
        statsDF <- rbind(statsDF, list(tag = membersDF$tag[i], name = membersDF$name[i], cardsEarned = 0,
                                       battlesPlayed = 0, wins = 0, collectionDayBattlesPlayed = 0, warsEntered = 0))
    }
}

## Add final battle misses and collection battle misses
statsDF$finalBattleMisses <- rep(0L, nrow(statsDF))

for (i in 1:nrow(statsDF)) {
    statsDF$finalBattleMisses[i] <- nrow(warlogDF[(warlogDF$tag == statsDF$tag[i] & warlogDF$battlesPlayed == 0), ])
}

statsDF$collectionBattleMisses <- (statsDF$warsEntered * 3) - statsDF$collectionDayBattlesPlayed

## Add win percentage
statsDF$winRate <- round(statsDF$wins / statsDF$battlesPlayed, 2) * 100

## Add flag for current members
statsDF$currentMember <- rep("No", nrow(statsDF))
for (i in 1:nrow(statsDF)) {
    if (statsDF$tag[i] %in% membersDF$tag) { statsDF$currentMember[i] <- "Yes"}
}

# Sort and reorder columns
statsDF <- statsDF[c(1, 6, 11, 7, 5, 2:4, 9, 8, 10)]

## ================ Compute PLAYER SCORE
## Score / points added:
## - 500 cards earned = 1 point
## - 1 war day victory = 5 points
## - 1 war day victory (all time) - 0.5 points
## - 2000 cards collected (all time) - 1 point
##
## Score / points removed:
## - Final battle misses: 10 * misses + 3 ^ misses - 1
##                      0         12         28         56        120        292
## - Collection battle misses: (1 + misses / 2) ^ 2 - 1
##                      0   1   3   5   8  11  15  19  24  29  35  41  48  55  63
## - War miss: (misses / 4) ^ 2
##                      0, 0.1, 0.3, 0.6, 1, 1.6


statsDF$WARSCORE <- rep (0L, nrow(statsDF))

totalWars <- max(statsDF$warsEntered) # Not the best solution; need to deal with this later

for (i in 1:nrow(statsDF)) {
    
    # Check if it's an existing member
    if (nrow(detailedMembersDF[detailedMembersDF$tag == statsDF[i, ]$tag, ]) == 0) next
    
    memberWarDayWins = detailedMembersDF[detailedMembersDF$tag == statsDF[i, ]$tag, ]$warDayWins
    memberClanCardsCollected = detailedMembersDF[detailedMembersDF$tag == statsDF[i, ]$tag, ]$clanCardsCollected
    
    statsDF$WARSCORE[i] <- round(statsDF$cardsEarned[i] / 500 
                              + statsDF$wins[i] * 5 
                              + memberWarDayWins / 2
                              + memberClanCardsCollected / 2000
                              - 10 * statsDF$finalBattleMisses[i] + 3 ^ statsDF$finalBattleMisses[i] - 1
                              - (1 + statsDF$collectionBattleMisses[i] / 2) ^ 2 - 1
                              - ((totalWars - statsDF$warsEntered[i]) / 4) ^ 2
                              )
}




## ===========================================================================================================
## Update player join dates
##
if (file.exists(playerFile)) {
    playerInfo <- readRDS(playerFile)

    detailedMembersDF <- merge(detailedMembersDF, playerInfo[, c("tag", "joined")], by.x = "tag", by.y = "tag", all.x = T, all.y = F)
    
    newMembers <- detailedMembersDF[is.na(detailedMembersDF$joined), ]

    if (nrow(newMembers) > 0) {
        newMembers$joined <- Sys.Date()
        playerInfo <- rbind(playerInfo, newMembers[, c("tag", "name", "joined")])
        saveRDS(playerInfo, playerFile)
    }
    
    detailedMembersDF$age <- Sys.Date() - detailedMembersDF$joined
    
}

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




## ===========================================================================================================
## Build clan stats and append to file
##

if (file.exists(clanStatsFile)) {
    clanStatsDF <- readRDS(clanStatsFile)

} else {
    clanStatsDF <- data.frame()
}

## Two entries must be at least 12 hours appart and on different days
mostRecent <- clanStatsDF$timestamp[nrow(clanStatsDF)]

if (julian(Sys.time(), mostRecent) > 0.5 && wday(mostRecent) != wday(Sys.time())) {
   
    clanStatsDF <- rbind(clanStatsDF, data.frame(
        timestamp = Sys.time(),
        nMembers = nrow(detailedMembersDF),
        roleColeader = nrow(detailedMembersDF[detailedMembersDF$role == 'coLeader', ]),
        roleElder = nrow(detailedMembersDF[detailedMembersDF$role == 'elder', ]),
        roleMember = nrow(detailedMembersDF[detailedMembersDF$role == 'member', ]),
        avgLevel = round(mean(detailedMembersDF$expLevel), 2),
        avgTrophies = round(mean(detailedMembersDF$trophies)),
        avgBestTrophies = round(mean(detailedMembersDF$bestTrophies)),
        avgWins = round(mean(detailedMembersDF$totalWins)),
        avgBattleCount = round(mean(detailedMembersDF$battleCount)),
        avgChallengeMaxWins = round(mean(detailedMembersDF$challengeMaxWins), 1),
        avgDonations = round(mean(detailedMembersDF$totalDonations)),
        avgWarDayWins = round(mean(detailedMembersDF$warDayWins), 1),
        avgCardsCollected = round(mean(detailedMembersDF$clanCardsCollected))
    ))
    
    saveRDS(clanStatsDF, clanStatsFile)
}
