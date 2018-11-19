## ===========================================================================================================
## Function logClanStats(detailedMembersDF, clanStatsfile)
##      detailedMembersDF - data frame with all the members individual stats
##      clanStatsFile - file path to load/save the log
##
## Builds the clan stats and logs to the file defined in the global variable 'clanStatsFile'

logClanStats <- function(detailedMembersDF, clanStatsFile) {
    
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
            avgCardsCollected = round(mean(detailedMembersDF$clanCardsCollected)),
            avgAge = round(mean(detailedMembersDF$age))
        ))
        
        saveRDS(clanStatsDF, clanStatsFile)
        
    }
    
    clanStatsDF
}


## ===========================================================================================================
## Function updateJoinDates(detailedMembersDF, playerFile)
##      detailedMembersDF - data frame with all the members individual stats
##      playerFile - RDS file path with the player join dates
##
updateJoinDates <- function(detailedMembersDF, playerFile) {
    
    if (!file.exists(playerFile)) return (detailedMembersDF)
    
    playerInfo <- readRDS(playerFile)
    
    detailedMembersDF <- merge(detailedMembersDF, playerInfo[, c("tag", "joined")], by.x = "tag", by.y = "tag", all.x = T, all.y = F)
    
    newMembers <- detailedMembersDF[is.na(detailedMembersDF$joined), ]
    
    # If new members exist, set their join date to today
    if (nrow(newMembers) > 0) {
        newMembers$joined <- Sys.Date()
        playerInfo <- rbind(playerInfo, newMembers[, c("tag", "name", "joined")])
        
        for (i in 1:nrow(newMembers)) {
            detailedMembersDF[detailedMembersDF$tag == newMembers[i, "tag"], ]$joined <- Sys.Date()
        }
    }
    
    # If any member changed its name, set the new name
    for (i in 1:nrow(detailedMembersDF)) {
        playerTag <- detailedMembersDF$tag[i]
        newname <- detailedMembersDF$name[i]
        
        oldname <- playerInfo[playerInfo$tag == playerTag, "name"]
        
        if (newname != oldname)
            playerInfo[playerInfo$tag == playerTag, "name"] <- newname
        
    }
    
    # Save the new data (name changes and new joins)
    saveRDS(playerInfo, playerFile)
    
    #compute age as nr. days from joined date to today
    detailedMembersDF$age <- as.numeric(Sys.Date() - detailedMembersDF$joined)
    
    detailedMembersDF
    
}
