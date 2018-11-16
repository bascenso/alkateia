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
## Function buildWarStats(warlogDF, membersDF, detailedMembersDF, nwars = "all")
##      warlogDF - data frame with the log of all war participation
##      membersDF - data frame with all the members of the clan
##      detailedMembersDF - data frame with all the members individual stats. needed to compute warscore
##      nwars - build the stats with this many last wars; Default is all wars available
##

buildWarStats <- function(warlogDF, membersDF, detailedMembersDF, nwars = "all") {

    warCount <- length(unique(warlogDF$warId))
    wars <- warlogDF
    
    if (nwars == "all") nwars <- warCount
    
    if (nwars <= 0 || nwars > warCount) {
        warning("Invalid number of wars. Defaulting to 'all'.")
        nwars <- warCount
    }
    
    if (nwars < warCount) {
        warDates <- unique(warlogDF$warId)
        warDates <- warDates[order(unique(warlogDF$warEnd), decreasing = TRUE)]
        warDates <- warDates[1:nwars]
        
        wars <- warlogDF[warlogDF$warId %in% warDates, ]
    }

    # Get the battle totals per player

    s <- split(wars, wars$tag)
    statsDF <- data.frame(t(data.frame(lapply(s, function(x) {
        colSums(x[, c("cardsEarned", "battlesPlayed", "wins", "collectionDayBattlesPlayed")])
        } ))))
    
    # Add tag and name
    statsDF$tag <- sub("X.", "#", rownames(statsDF))
    
    statsDF$name <- rep(NA, nrow(statsDF))
    
    # Match first the names in the membersDF to ensure current names
    for (i in 1:nrow(statsDF)) {
        player <- as.character(statsDF$tag[i])
        occ <- match(player, membersDF$tag)
        statsDF$name[i] <- as.character(membersDF$name[occ])
    }
    
    # For players not in the clan, match their name in the warlog
    for (i in 1:nrow(statsDF)) {
        if (is.na(statsDF$name[i])) {
            player <- as.character(statsDF$tag[i])
            occ <- match(player, wars$tag)
            statsDF$name[i] <- as.character(wars$name[occ])
        }
    }
    
    
    # Add number of participations in wars for each member
    participations <- data.frame(table(unlist(wars$tag)))
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
    
        ## Any entry with 0 battles played counts as a miss (does not capture players with 2 battles that played only 1)
    for (i in 1:nrow(statsDF)) {
        statsDF$finalBattleMisses[i] <- nrow(wars[(wars$tag == statsDF$tag[i] & wars$battlesPlayed == 0), ])
    }
    
    statsDF$collectionBattleMisses <- (statsDF$warsEntered * 3) - statsDF$collectionDayBattlesPlayed

    
    ## Add win percentage
    statsDF$winRate <- round(statsDF$wins / statsDF$battlesPlayed, 2) * 100
    
    ## Add flag for current members
    statsDF$currentMember <- rep("No", nrow(statsDF))
    for (i in 1:nrow(statsDF)) {
        if (statsDF$tag[i] %in% membersDF$tag) 
            statsDF$currentMember[i] <- "Yes"
    }
    
    # Add player score column 
    statsDF <- computePlayerScore(statsDF, detailedMembersDF, nwars)

    # Reorder columns and sort by WARSCORE
    statsDF <- statsDF[c(1, 6, 11, 7, 5, 2:4, 9, 8, 10, 12)]
    statsDF <- statsDF[order(desc(statsDF$WARSCORE)), ]

    statsDF
}


## ===========================================================================================================
## Function buildEvolutionMap(warlogDF, membersDF, detailedMembersDF, nmonth = 3)
##      warlogDF - data frame with the log of all war participation
##      membersDF - data frame with all the members of the clan
##      detailedMembersDF - data frame with all the members individual stats. needed to compute warscore
##      nperiod - number of last periods to include in the map; tipically period = month
##      warsPerPeriod - number of wars in each period; tipically 15 for month periods
##

buildEvolutionMap <- function(warlogDF, membersDF, detailedMembersDF, nperiod = 3, warsPerPeriod = 15) {

    warCount <- length(unique(warlogDF$warId))
    completePeriods <- warCount %/% warsPerPeriod
    mapPeriods <- ifelse(nperiod > completePeriods, completePeriods, nperiod)    


    #Columns: tag   name    winsP1 scoreP1 rankP1  ... allWins allScore allRank
    evolutionDF <- membersDF[, c("tag", "name")]

    for (i in 1:mapPeriods) {
        periodData <- buildWarStats(warlogDF, membersDF, detailedMembersDF, i*warsPerPeriod)

        #Initialize columns
        evolutionDF$wins <- rep(0, nrow(evolutionDF))
        evolutionDF$score <- rep(0, nrow(evolutionDF))
        evolutionDF$rank <- rep(1, nrow(evolutionDF))
        
        #Set values for wins and score
        for (j in 1:nrow(evolutionDF)) {
            evolutionDF[j, "wins"] <- periodData[periodData$tag == evolutionDF[j, "tag"], "wins"]
            evolutionDF[j, "score"] <- periodData[periodData$tag == evolutionDF[j, "tag"], "WARSCORE"]
        }
        
        # Set the ranks (awkward solution #1)
        ranks <- order(evolutionDF$score, decreasing = T)
        for (j in 1:length(ranks)) evolutionDF[ranks[j], "rank"] <- j
        
        # Rename the columns (awkward solution #2)
        names(evolutionDF)[names(evolutionDF) == "wins"] <- paste("winsP", i, sep = "")
        names(evolutionDF)[names(evolutionDF) == "score"] <- paste("scoreP", i, sep = "")
        names(evolutionDF)[names(evolutionDF) == "rank"] <- paste("rankP", i, sep = "")
    }

    # Add the all time values
    totalData <- buildWarStats(warlogDF, membersDF, detailedMembersDF, "all")

    #Initialize columns
    evolutionDF$allWins <- rep(0, nrow(evolutionDF))
    evolutionDF$allScore <- rep(0, nrow(evolutionDF))
    evolutionDF$allRank <- rep(1, nrow(evolutionDF))
    
    #Set values for wins and score
    for (j in 1:nrow(evolutionDF)) {
        evolutionDF[j, "allWins"] <- totalData[totalData$tag == evolutionDF[j, "tag"], "wins"]
        evolutionDF[j, "allScore"] <- totalData[totalData$tag == evolutionDF[j, "tag"], "WARSCORE"]
    }
    
    # Set the ranks (again the awkward solution)
    ranks <- order(evolutionDF$allScore, decreasing = T)
    for (j in 1:length(ranks)) evolutionDF[ranks[j], "allRank"] <- j
    
    evolutionDF
}


## ===========================================================================================================
## Function computePlayerScore(statsDF, detailedMembersDF)
##      statsDF - data frame with war stats per player. It's returned with the new column WARSCORE
##      detailedMembersDF - data frame with all the members individual stats
##      totalWars - number of wars across which to compute the score (needed because misses remove points)
##
## ================ PLAYER SCORE FORMULA:
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

computePlayerScore <- function(statsDF, detailedMembersDF, totalWars) {

    statsDF$WARSCORE <- rep (0L, nrow(statsDF))

    for (i in 1:nrow(statsDF)) {
        
        # Check if it's an existing member; skip if not
        if (nrow(detailedMembersDF[detailedMembersDF$tag == statsDF[i, ]$tag, ]) == 0) next
        
        memberWarDayWins = detailedMembersDF[detailedMembersDF$tag == statsDF[i, ]$tag, ]$warDayWins
        memberClanCardsCollected = detailedMembersDF[detailedMembersDF$tag == statsDF[i, ]$tag, ]$clanCardsCollected

        # Number of wars where the player could have entered since joined the clan
        memberMaxWars <- as.numeric(round((Sys.Date() - detailedMembersDF[detailedMembersDF$tag == statsDF[i, ]$tag, ]$joined) / 2))
        maxWars <- ifelse(memberMaxWars > totalWars, totalWars, memberMaxWars)
        
        statsDF$WARSCORE[i] <- round(statsDF$cardsEarned[i] / 500 
                                     + (statsDF$wins[i] * 5)
                                     + (memberWarDayWins / 2)
                                     + (memberClanCardsCollected / 2000)
                                     - (10 * statsDF$finalBattleMisses[i] + 3 ^ statsDF$finalBattleMisses[i] - 1)
                                     - ((1 + statsDF$collectionBattleMisses[i] / 2) ^ 2 - 1)
                                     - (((maxWars - statsDF$warsEntered[i]) / 4) ^ 2)
        )
    }
    
    statsDF
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


## ===========================================================================================================
## Function buildWarMap(warlogDF, detailedMembersDF, nwars = "all")
##      warlogDF - data frame with the full warlog
##      detailedMembersDF - data frame with current clan members
##      nwars - build the map with this many last wars; Default is all wars available
##

buildWarMap <- function(warlogDF, detailedMembersDF, nwars = "all") {

    warCount <- length(unique(warlogDF$warId))
    wars <- warlogDF

    if (nwars == "all") nwars <- warCount

    if (nwars <= 0 || nwars > warCount) {
        warning("Invalid number of wars. Defaulting to 'all'.")
        nwars <- warCount
    }

    if (nwars < warCount) {

        # Get nwars most recent dates
        warDates <- unique(warlogDF$warId)
        warDates <- warDates[order(unique(warlogDF$warEnd), decreasing = TRUE)]
        warDates <- warDates[1:nwars]

        # subset the most recent wars
        wars <- warlogDF[warlogDF$warId %in% warDates, ]
    }

    # Cast the warlogDF to have the participation per war (only for current members)
    onlyCurrentMembersDF <- wars[wars$tag %in% detailedMembersDF$tag, ]
    warParticipationDF <- dcast(data = onlyCurrentMembersDF, 
                                formula = tag ~ as.character(as.Date(onlyCurrentMembersDF$warEnd)), 
                                value.var = "wins", 
                                fill = "MIA")


    # Add member names to the DF. This can't be included in the dcast() above because some members change names and would appear twice
    warParticipationDF$name <- sapply(warParticipationDF$tag, function(x) detailedMembersDF[detailedMembersDF$tag == x, "name"])

    # Reorder columns: names as the second column
    warParticipationDF <- warParticipationDF[, c(1, ncol(warParticipationDF), 2:(ncol(warParticipationDF)-1))]

    # Reorder columns: from most recent to oldest... is there a better way to do this?
    warParticipationDF <- warParticipationDF[, c(1, 2, 2 + order(names(warParticipationDF)[3:ncol(warParticipationDF)], decreasing = T))]
    
    # Add battle misses
    missesDF <- wars[wars$battlesPlayed == 0, ]
    missesDF$warEnd <- as.character(as.Date(missesDF$warEnd))
    missesDF$tag <- as.character(missesDF$tag)
    
    for (i in 1:nrow(missesDF))
        warParticipationDF[warParticipationDF$tag == missesDF[i, ]$tag, missesDF[i, ]$warEnd] <- "-BF"
    
    # Add members with no wars
    membersWithNoWars <- detailedMembersDF[!(detailedMembersDF$tag %in% warParticipationDF$tag), c("tag", "name")]

    ## Initialize temporary DF to bind the members with no wars
    tempDF <- warParticipationDF[1:nrow(membersWithNoWars), ]
    for(i in 1:nrow(tempDF)) for(j in 3:ncol(tempDF)) tempDF[i, j] <- "MIA"
    
    for(i in 1:nrow(membersWithNoWars)) {
        tempDF[i, ]$tag <- membersWithNoWars[i, ]$tag
        tempDF[i, ]$name <- membersWithNoWars[i, ]$name
    }
    
    ## Bind the tempDF into the the main DF
    warParticipationDF <- rbind(warParticipationDF, tempDF)
    

    # Add NA for wars where the member was not yet in the clan
    # For each member and for each battle (date)
    for (iMember in 1:nrow(warParticipationDF)) {

        joinDate <- detailedMembersDF[detailedMembersDF$tag == as.character(warParticipationDF[iMember, "tag"]), ]$joined

        for (iCol in 1:length(colnames(warParticipationDF))) {
            if (colnames(warParticipationDF)[iCol] == "tag" || colnames(warParticipationDF)[iCol] == "name") next

            warDate <- colnames(warParticipationDF)[iCol]

            if (warDate < joinDate) warParticipationDF[iMember, iCol] <- NA

        }
    }

    #Return the DF ordered by name
    warParticipationDF[order(warParticipationDF$name), ]

}
