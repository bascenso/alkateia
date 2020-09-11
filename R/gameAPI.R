## ===========================================================================================================
## Functions to get data from the game API
##
## Player data Syntax:
## GET /players/{playerTag} : Get player information
## GET /players/{playerTag}/upcomingchests : Get list of reward chests that the player will receive next in the game
## GET /players/{playerTag}/battlelog : Get list of recent battle results for a player.
##
## Clan data Syntax:
## GET /clans : Search all clans by name
## GET /clans/{clanTag} : Get information about a single clan by clan tag
## GET /clans/{clanTag}/members : List clan members
## GET /clans/{clanTag}/warlog : Retrieve clan's clan war log
## GET /clans/{clanTag}/currentwar : Retrieve information about clan's current clan war


## Addresses
##
APIEndpoint <- "https://api.clashroyale.com/v1"

## Player data
playerpath = "/players"
chestspath = "/upcomingchests"
battlepath = "/battlelog"

## Clan data
clanpath <- "/clans"
memberpath <- "/members"
warlogpath <- "/warlog"
currentwarpath <- "/currentwar"

## Clan wars v2 data
riverracelogpath <- "/riverracelog"
currentriverracepath <- "/currentriverrace"



## ===========================================================================================================
## Function getPlayerInfo(playerTag, token)
##      playerTag - the tag of the player
##      token - auth token

getPlayerInfo <- function(playerTag, token) {
    APIURL <- paste(APIEndpoint, playerpath, playerTag, sep = "")
    
    playerReq <- GET(APIURL, add_headers(Accept = "application/json", Authorization = paste("Bearer", token)))
    
    if (playerReq$status_code != 200) {
        stop(paste("Server returned error:", warlogReq$status_code))
        
    } else {
        playerInfo <- content(playerReq)
        
    }
    
    playerInfo
}



## ===========================================================================================================
## Function getClanMembers(clanTag, token)
##      clanTag - the tag of the clan
##      token - auth token

getClanMembers <- function(clanTag, token) {

    cat("Getting clan members for", clanTag, "... ")
    
    APIURL <- paste(APIEndpoint, clanpath, clanTag, sep = "")

    clanReq <- GET(APIURL, add_headers(Accept = "application/json", Authorization = paste("Bearer", token)))

    if (clanReq$status_code != 200) {
        stop(paste("Server returned error:", clanReq$status_code))
    } else {
        clanInfo <- content(clanReq)

        # Build DF with member data
        membersDF <- data.frame()
        numMembers <- length(clanInfo$memberList)

        for (i in 1:numMembers) {
            membersDF <- rbind(membersDF, data.frame(
                tag = clanInfo$memberList[[i]]$tag,
                name = clanInfo$memberList[[i]]$name,
                role = clanInfo$memberList[[i]]$role,
                level = clanInfo$memberList[[i]]$expLevel,
                trophies = clanInfo$memberList[[i]]$trophies,
                arena = clanInfo$memberList[[i]]$arena$name,
                rank = clanInfo$memberList[[i]]$clanRank,
                donations = clanInfo$memberList[[i]]$donations,
                donationsR = clanInfo$memberList[[i]]$donationsReceived,
                donationBalance = clanInfo$memberList[[i]]$donations - clanInfo$memberList[[i]]$donationsReceived
            ))
        }
    }

    cat("OK\n")
    
    membersDF
}


## ===========================================================================================================
## Function getClanWarlog(clanTag, token, fileName)
##      clanTag - the tag of the clan
##      token - auth token
##      fileName - if specified, append warlog data to this file (RDS format)

getClanWarlog <- function (clanTag, token, fileName = "") {

    cat("Getting warlog for", clanTag, "... ")
    
    APIURL <- paste(APIEndpoint, clanpath, clanTag, warlogpath, sep = "")

    warlogReq <- GET(APIURL, add_headers(Accept = "application/json", Authorization = paste("Bearer", token)))

    if (warlogReq$status_code != 200) {
        stop(paste("Server returned error:", warlogReq$status_code))

    } else {
        warlogInfo <- content(warlogReq)

        if (file.exists(fileName)) {
            warlogDF <- readRDS(fileName) # if there is already data present, load it
        } else {
            warlogDF <- data.frame() # else build the DF from scratch
        }
        
        
        for (i in 1:length(warlogInfo$items)) { # Each of the 10 wars
            thisWarId <- warlogInfo$items[[i]]$createdDate
            
            if (any(thisWarId == warlogDF$warId)) next # If data about the war is already present, skip it

            numParticipants <- length(warlogInfo$items[[i]]$participants)

            for (j in 1:numParticipants) { # Get data on each participant
                warlogDF <- rbind(warlogDF, data.frame(
                    warId = thisWarId,
                    warEnd = strptime(thisWarId, "%Y%m%dT%H%M%S.000Z"),
                    tag = warlogInfo$items[[i]]$participants[[j]]$tag,
                    name = warlogInfo$items[[i]]$participants[[j]]$name,
                    cardsEarned = warlogInfo$items[[i]]$participants[[j]]$cardsEarned,
                    battlesPlayed = warlogInfo$items[[i]]$participants[[j]]$battlesPlayed,
                    wins = warlogInfo$items[[i]]$participants[[j]]$wins,
                    collectionDayBattlesPlayed = warlogInfo$items[[i]]$participants[[j]]$collectionDayBattlesPlayed
                ))
            }

        }

        if (fileName != "") saveRDS(warlogDF, fileName)
    }

    cat("OK\n")
    
    warlogDF
}


## ===========================================================================================================
## Function getClanMemberDetails(members, token)
##      members - vector with member tags
##      token - auth token

getClanMemberDetails <- function(members, token) {

    if ((length(members) < 1) || (length(members) > 50))
        stop("Clan member list should have between 1 and 50 tags.")
    
    numMembers <- length(members)
    memberInfoDF <- data.frame()
    
    cat("Getting members (", numMembers, "):\n", sep = "")

    for (i in 1:numMembers) {
        cat(i, ". ")
        
        iMember <- getPlayerInfo(sub("#", "/%23", members[i]), token)

        memberInfoDF <- rbind(memberInfoDF, data.frame(
            tag = iMember$tag,
            name = iMember$name,
            expLevel = iMember$expLevel,
            trophies = iMember$trophies,
            bestTrophies = iMember$bestTrophies,
            totalWins = iMember$wins,
            totalLosses = iMember$losses,
            battleCount = iMember$battleCount,
            threeCrownWins = iMember$threeCrownWins,
            challengeCardsWon = iMember$challengeCardsWon,
            challengeMaxWins = iMember$challengeMaxWins,
            tournamentCardsWon = iMember$tournamentCardsWon,
            tournamentBattleCount = iMember$tournamentBattleCount,
            role = iMember$role,
            donations = iMember$donations,
            donationsReceived = iMember$donationsReceived,
            totalDonations = iMember$totalDonations,
            warDayWins = iMember$warDayWins,
            clanCardsCollected = iMember$clanCardsCollected,
            arena = iMember$arena$name
        ))
        
    }

    cat("\n")
    
    memberInfoDF
}



## ===========================================================================================================
## Function getClanRiverRaceLog(clanTag, token, fileName)
##      clanTag - the tag of the clan
##      token - auth token
##      fileName - if specified, append river race log data to this file (RDS format)

getClanRiverRaceLog <- function (clanTag, token, fileName = "") {
    
    cat("Getting River race log for", clanTag, "... ")
    
    APIURL <- paste(APIEndpoint, clanpath, clanTag, riverracelogpath, sep = "")
    
    riverRaceLogReq <- GET(APIURL, add_headers(Accept = "application/json", Authorization = paste("Bearer", token)))
    
    if (riverRaceLogReq$status_code != 200) {
        stop(paste("Server returned error:", riverRaceLogReq$status_code))
        
    } else {
        riverRaceLogInfo <- content(riverRaceLogReq)
        
        if (file.exists(fileName)) {
            riverRaceLogDF <- readRDS(fileName) # if there is already data present, load it
        } else {
            riverRaceLogDF <- data.frame() # else build the DF from scratch
        }
        
        
        for (i in 1:length(riverRaceLogInfo$items)) { # For each river race returned
            thisRiverRaceId <- riverRaceLogInfo$items[[i]]$createdDate
            
            if (any(thisRiverRaceId == riverRaceLogDF$riverRaceId)) next # If data about the river race is already present, skip it
            
            # Iterate river race standings to find the clan
            for (j in 1:5) {
                if (riverRaceLogInfo$items[[i]]$standings[[j]]$clan$tag == sub("/%23", "#", clanTag)) break
            }                
            
            # Get the data for each participant in the river race
            for (k in 1:length(riverRaceLogInfo$items[[i]]$standings[[j]]$clan$participants)) {
            
                riverRaceLogDF <- rbind(riverRaceLogDF, data.frame(
                    riverRaceId = thisRiverRaceId,
                    riverRaceDate = strptime(thisRiverRaceId, "%Y%m%dT%H%M%S.000Z"),
                    riverRaceFinish = strptime(riverRaceLogInfo$items[[i]]$standings[[j]]$clan$finishTime, "%Y%m%dT%H%M%S.000Z"),
                    fame = riverRaceLogInfo$items[[i]]$standings[[j]]$clan$fame,
                    repairPoints = riverRaceLogInfo$items[[i]]$standings[[j]]$clan$repairPoints,
                    clanScore = riverRaceLogInfo$items[[i]]$standings[[j]]$clan$clanScore,
                    participantTag = riverRaceLogInfo$items[[i]]$standings[[j]]$clan$participants[[k]]$tag,
                    participantName = riverRaceLogInfo$items[[i]]$standings[[j]]$clan$participants[[k]]$name,
                    participantFame = riverRaceLogInfo$items[[i]]$standings[[j]]$clan$participants[[k]]$fame,
                    participantRepairPoints = riverRaceLogInfo$items[[i]]$standings[[j]]$clan$participants[[k]]$repairPoints
                ))
                
            }
            
        }
        
        if (fileName != "") saveRDS(riverRaceLogDF, fileName)
    }
    
    cat("OK\n")
    
    riverRaceLogDF
}

