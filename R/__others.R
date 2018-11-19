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

otherclan <- "/%23QC9Y9V"

## ================ Get clan member list
message("Loading clan member list...")
OCmembersDF <- getClanMembers(otherclan, token)


## ================ Get clan warlog
message("Loading war log...")
OCwarlogDF <- getClanWarlog(otherclan, token)


## ================ Get detailed member info
message("Loading detailed member info...")
OCdetailedMembersDF <- getClanMemberDetails(otherclan, token)



## ===========================================================================================================
## Build war stats
##
message("Building stats...")
OCstatsDF <- buildWarStats(OCwarlogDF, OCmembersDF, OCdetailedMembersDF, "all")


## ===========================================================================================================
## Build war participation map
##
OCwarParticipationDF <- buildWarMap(OCwarlogDF, OCdetailedMembersDF, nwars = "all")
