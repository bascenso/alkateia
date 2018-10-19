## ===========================================================================================================
## Functions to get player data
## Syntax:
## GET /players/{playerTag} : Get player information
## GET /players/{playerTag}/upcomingchests : Get list of reward chests that the player will receive next in the game
## GET /players/{playerTag}/battlelog : Get list of recent battle results for a player.


##
## Addresses
##
APIEndpoint = "https://api.clashroyale.com/v1"
playerpath = "/players"
chestspath = "/upcomingchests"
battlepath = "/battlelog"



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