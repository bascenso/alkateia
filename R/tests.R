## Score / points removed:
## - Final battle misses: 5 * misses + 2 ^ misses -1
##                      0, 6, 13, 22, 35, 56, 93, 162    
## - Collection battle misses: misses + (1 + misses / 5) ^ 2 - 1
##                      0, 1, 3, 5, 6, 8, 10, 12, 14, 16, 18, 23, 27, 33, 38, 44
## - War miss: (misses / 4) ^ 2
##                      0, 0.1, 0.3, 0.6, 1, 1.6



x <- 0:20

fm <- 10 * x + 3 ^ x - 1

cm <- (1 + x/2)^2 -1

wm <- (x / 4)^2

result <- data.frame(misses = x, fm = fm, cm = cm, wm = wm)


## Plot value
testDF <- allStatsDF[allStatsDF$currentMember == "Yes", ]
#testDF <- testDF[testDF$WARSCORE >= 100, ]

rownames(testDF) <- testDF$name.x

par(mfrow = c(1, 1))
plot(testDF$trophies, testDF$WARSCORE)

text(testDF$trophies, testDF$WARSCORE, labels = rownames(testDF), pos = 3)
abline(h = 100, col = "green")
abline(h = 50, col = "yellow")
abline(h = 0, col = "red")


## Test linear regression

drops <- c("tag", "role", "arena", "WARSCORE", "currentMember")
testDF <- allStatsDF[allStatsDF$currentMember == "Yes", !names(allStatsDF) %in% drops]
rownames(testDF) <- testDF$name.x
testDF <- testDF[, names(testDF) != "name.x"]

fit1 <- lm(winRate ~ trophies, data = test2DF)


# remove outliers
outliers = c("Manu", "ZezinhoPT", "bascenso")
test3DF <- test2DF[!rownames(test2DF) %in% outliers, ]
fit2 <- lm(winRate ~ trophies, data = test3DF)


par(mfrow = c(1, 2))

plot(test2DF$trophies, test2DF$winRate)
text(test2DF$trophies, test2DF$winRate, labels = rownames(test2DF), pos = 4)
abline(fit1)

plot(test3DF$trophies, test3DF$winRate)
abline(fit2)
