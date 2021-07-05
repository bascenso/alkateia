
## ===========================================================================================================
## Function buildWarStats(cl, nwars = "all")
##      cl - a clan data structure
##      nwars - build the stats with this many last wars; Default is all wars available
##

buildWarStats <- function(cl, nwars = "all") {

    warCount <- length(unique(cl$warlog$warId))
    wars <- cl$warlog

    if (nwars == "all") nwars <- warCount
    
    if (nwars <= 0 || nwars > warCount) {
        warning("Invalid number of wars. Defaulting to 'all'.")
        nwars <- warCount
    }

    if (nwars < warCount) {
        warDates <- unique(cl$warlog$warId)
        warDates <- warDates[order(unique(cl$warlog$warEnd), decreasing = TRUE)]
        warDates <- warDates[1:nwars]

        wars <- cl$warlog[cl$warlog$warId %in% warDates, ]
    }

    # Get the battle totals per player

    s <- split(wars, wars$tag)
    statsDF <- data.frame(t(data.frame(lapply(s, function(x) {
        colSums(x[, c("cardsEarned", "battlesPlayed", "wins", "collectionDayBattlesPlayed")])
        } ))))

    # Add tag and name
    statsDF$tag <- sub("X.", "#", rownames(statsDF))
    
    statsDF$name <- rep(NA, nrow(statsDF))

    # Match first the names in the members DF to ensure current names
    for (i in 1:nrow(statsDF)) {
        player <- as.character(statsDF$tag[i])
        occ <- match(player, cl$members$tag)
        statsDF$name[i] <- as.character(cl$members$name[occ])
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
    for (i in 1:nrow(cl$members)) {
        if(!any(cl$members$tag[i] == statsDF$tag)) {
            statsDF <- rbind(statsDF, list(tag = cl$members$tag[i], name = cl$members$name[i], cardsEarned = 0,
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

    
    ## Add win percentage and cards per war
    statsDF$winRate <- round(statsDF$wins / statsDF$battlesPlayed, 2) * 100
    statsDF$cardsPerWar <- round(statsDF$cardsEarned / statsDF$warsEntered, 0)
    
    ## Add flag for current members
    statsDF$currentMember <- rep("No", nrow(statsDF))
    for (i in 1:nrow(statsDF)) {
        if (statsDF$tag[i] %in% cl$members$tag) 
            statsDF$currentMember[i] <- "Yes"
    }

    # Add player score column
    statsDF <- computePlayerScore(statsDF, clan$memberInfo, nwars)

    statsDF <- computeRecentWarPresence(statsDF, cl)

    # Reorder columns and sort by WARSCORE
    statsDF <- statsDF[c(1, 6, 12, 7, 14, 5, 2:4, 9, 8, 10, 11, 13)]
    statsDF <- statsDF[order(desc(statsDF$WARSCORE)), ]

    statsDF
}


#' function computeRecentWarPresence - computer the percentage of wars entered by each player in the last period (month)
#' 
#' @param statsDF the DF with the stats to append the new column
#' @param cl a clan data structure
#' @return the DF with the new column appended
#' 
computeRecentWarPresence <- function(statsDF, cl) {

    # Filter only the n most recent wars
    warDates <- unique(cl$warlog$warId)
    warDates <- warDates[order(unique(cl$warlog$warEnd), decreasing = TRUE)]
    warDates <- warDates[1:15]
    wars <- cl$warlog[cl$warlog$warId %in% warDates, ]

    # Build participation data
    participations <- data.frame(table(unlist(wars$tag)))
    participations$joined <- rep(Sys.Date(), nrow(participations))

    for (i in 1:nrow(participations)) participations$joined[i] <- cl$memberInfo[cl$memberInfo$tag == participations$Var1[i], "joined"]

    # Find how many wars the player could have participated
    warDates <- strptime(warDates, "%Y%m%dT%H%M%S.000Z")
    participations$couldEnter <- rep(0, nrow(participations))

    for (i in 1:nrow(participations))
        participations$couldEnter[i] <- length(which(as.Date(warDates) > as.Date(participations$joined[i] + 2)))

    participations$rate <- round(participations$Freq / participations$couldEnter * 100, 0)

    # Assign percentage to players in stats DF
    statsDF$pctLastPeriod <- rep (0, nrow(statsDF))

    for (i in 1:nrow(participations)) 
        statsDF[statsDF$tag == participations$Var1[i], ]$pctLastPeriod <- participations$rate[i]
    
    statsDF
}



## ===========================================================================================================
## Function buildEvolutionMap(warlogDF, membersDF, detailedMembersDF, nmonth = 3)
##      cl - a clan data structure
##      nperiod - number of last periods to include in the map; tipically period = month
##      warsPerPeriod - number of wars in each period; tipically 15 for month periods
##

buildEvolutionMap <- function(cl, nperiod = 3, warsPerPeriod = 15) {

    warCount <- length(unique(cl$warlog$warId))
    completePeriods <- warCount %/% warsPerPeriod
    mapPeriods <- ifelse(nperiod > completePeriods, completePeriods, nperiod)    


    #Columns: tag   name    winsP1 scoreP1 rankP1  ... allWins allScore allRank
    evolutionDF <- cl$members[, c("tag", "name")]

    for (i in 1:mapPeriods) {
        periodData <- buildWarStats(cl, i*warsPerPeriod)

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
    totalData <- buildWarStats(cl, "all")

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
## - 10 cards earned = 1 point
## - 1 war day victory = 800 points
## - 1 war day victory (all time) - 30 points
## - 5000 cards collected (all time) - 1 point
##
## Score / points removed:
## - Final battle misses: 1000 * 2 ^ (misses - 1) - 500
##                      0         500         1500         3500        7500        15500       31500    63500
## - Collection battle misses: 1000 * 2 ^ (misses / 4) - 1000
##                      0   189  414  681  1000  1378  1828  2363  3000  3756  4656  5727  7000
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
        
        statsDF$WARSCORE[i] <- round((statsDF$cardsEarned[i] / 10)
                                     + (statsDF$wins[i] * 800)
                                     + (memberWarDayWins * 30)
                                     + (memberClanCardsCollected / 5000)
                                     - (1000 * 2 ^ (statsDF$finalBattleMisses[i] - 1) - 500)
                                     - (1000 * 2 ^ (statsDF$collectionBattleMisses[i] / 4) - 1000)
                                     #- (((maxWars - statsDF$warsEntered[i]) / 4) ^ 2)
        )
    }

    statsDF
}


## ===========================================================================================================
## Function buildWarMap(cl, nwars = "all")
##      cl - a clan data structure
##      nwars - build the map with this many last wars; Default is all wars available
##

buildWarMap <- function(cl, nwars = "all") {

    warCount <- length(unique(cl$warlog$warId))
    wars <- cl$warlog

    if (nwars == "all") nwars <- warCount

    if (nwars <= 0 || nwars > warCount) {
        warning("Invalid number of wars. Defaulting to 'all'.")
        nwars <- warCount
    }

    if (nwars < warCount) {

        # Get nwars most recent dates
        warDates <- unique(cl$warlog$warId)
        warDates <- warDates[order(unique(cl$warlog$warEnd), decreasing = TRUE)]
        warDates <- warDates[1:nwars]

        # subset the most recent wars
        wars <- cl$warlog[cl$warlog$warId %in% warDates, ]
    }

    # Cast the warlog DF to have the participation per war (only for current members)
    onlyCurrentMembersDF <- wars[wars$tag %in% cl$memberInfo$tag, ]
    onlyCurrentMembersDF$warEnd <- as.character(as.Date(onlyCurrentMembersDF$warEnd))

    warParticipationDF <- dcast(data = onlyCurrentMembersDF, formula = tag ~ warEnd, value.var = "wins", fill = "MIA")


    # Add member names to the DF. This can't be included in the dcast() above because some members change names and would appear twice
    warParticipationDF$name <- sapply(warParticipationDF$tag, function(x) cl$memberInfo[cl$memberInfo$tag == x, "name"])

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
    membersWithNoWars <- cl$memberInfo[!(cl$memberInfo$tag %in% warParticipationDF$tag), c("tag", "name")]

    if (nrow(membersWithNoWars) > 0) {

        ## Initialize temporary DF to bind the members with no wars
        tempDF <- warParticipationDF[1:nrow(membersWithNoWars), ]
        for(i in 1:nrow(tempDF)) for(j in 3:ncol(tempDF)) tempDF[i, j] <- "MIA"
        
        for(i in 1:nrow(membersWithNoWars)) {
            tempDF[i, ]$tag <- membersWithNoWars[i, ]$tag
            tempDF[i, ]$name <- membersWithNoWars[i, ]$name
        }
        
        ## Bind the tempDF into the the main DF
        warParticipationDF <- rbind(warParticipationDF, tempDF)
    }    
    
    # Add NA for wars where the member was not yet in the clan
    # For each member and for each battle (date)
    for (iMember in 1:nrow(warParticipationDF)) {

        joinDate <- cl$memberInfo[cl$memberInfo$tag == as.character(warParticipationDF[iMember, "tag"]), ]$joined

        for (iCol in 1:length(colnames(warParticipationDF))) {
            if (colnames(warParticipationDF)[iCol] == "tag" || colnames(warParticipationDF)[iCol] == "name") next

            warDate <- colnames(warParticipationDF)[iCol]

            # warDate = end date; a player must join the clan before the war start to be able to participate
            if (warDate < (joinDate + 2)) warParticipationDF[iMember, iCol] <- NA

        }
    }

    #Return the DF ordered by name
    warParticipationDF[order(warParticipationDF$name), ]

}


#' function buildRiverRaceStats - builds a data frame with the stats from the River Race
#' 
#' @param cl a clan data structure
#' @param nraces number of wars to use in the stats (default = all)
#' @return the DF with the stats
#' 

buildRiverRaceStats <- function(cl, nraces = "all") {

# Data frame columns:
# name - player name
# riverRacesEntered - number of river races where the player participated
# pctParticipation
# pctLastMonthParticipation
# totalFame
# totalRepairPoints
# famePerWar
    
    races <- cl$riverRaceLog     
    raceCount <- length(unique(races$riverRaceId))
    
    if (nraces == "all") nraces <- raceCount
    
    if (nraces <= 0 || nraces > raceCount) {
        warning("Invalid number of wars. Defaulting to 'all'.")
        nraces <- raceCount
    }

    if (nraces < raceCount) {
        # PENDING: Subset races to include only the most recent nraces
        
        # Get nraces most recent dates
        raceDates <- unique(races$riverRaceId)
        raceDates <- raceDates[order(unique(races$riverRaceDate), decreasing = TRUE)]
        raceDates <- raceDates[1:nraces]        

        # subset the most recent races
        races <- races[races$riverRaceId %in% raceDates, ]
    }
    
    s <- split(races, races$participantTag)
    raceStatsDF <- data.frame(t(data.frame(lapply(s, function(x) {
        colSums(x[, c("participantFame", "participantRepairPoints")])
    } ))))

    setnames(raceStatsDF, "participantFame", "totalFame")
    setnames(raceStatsDF, "participantRepairPoints", "totalRepairPoints")
    
    
    # Add tag and name
    raceStatsDF$tag <- sub("X.", "#", rownames(raceStatsDF))
    
    raceStatsDF$name <- rep(NA, nrow(raceStatsDF))
    
    # Match first the names in the members DF to ensure current names
    for (i in 1:nrow(raceStatsDF)) {
        player <- as.character(raceStatsDF$tag[i])
        occ <- match(player, cl$members$tag)
        raceStatsDF$name[i] <- as.character(cl$members$name[occ])
    }
    
    # For players not in the clan, match their name in the river race log
    for (i in 1:nrow(raceStatsDF)) {
        if (is.na(raceStatsDF$name[i])) {
            player <- as.character(raceStatsDF$tag[i])
            occ <- match(player, races$participantTag)
            raceStatsDF$name[i] <- as.character(races$participantName[occ])
        }
    }
    

    # Add number of river races where the member was in the clan
    participations <- data.frame(table(unlist(races$participantTag)))
    raceStatsDF <- merge(raceStatsDF, participations, by.x = "tag", by.y = "Var1", all = TRUE)
    setnames(raceStatsDF, "Freq", "riverRacesPresent")

    # Add number of river races where the member has points > 0
    racesEntered <- data.frame(table(unlist(races[(races$participantFame > 0) | (races$participantRepairPoints > 0), ]$participantTag)))
    raceStatsDF <- merge(raceStatsDF, racesEntered, by.x = "tag", by.y = "Var1", all = TRUE)
    setnames(raceStatsDF, "Freq", "riverRacesEntered")

    # Add average points per race
    raceStatsDF$pointsPerRace <- round((raceStatsDF$totalFame + raceStatsDF$totalRepairPoints) / raceStatsDF$riverRacesEntered)
    raceStatsDF$pctParticipation <- round((raceStatsDF$riverRacesEntered / raceStatsDF$riverRacesPresent) * 100.0)
    
    # Reorder columns and sort by Fame points
    raceStatsDF <- raceStatsDF[c(1, 4, 5, 6, 2, 3, 7, 8)]
    raceStatsDF <- raceStatsDF[order(desc(raceStatsDF$totalFame)), ]
    
    
    raceStatsDF   
}


