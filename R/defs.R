##
## My Tokens
## eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6ImFiYWIzODkxLWQ4M2QtNDgwMC1hNzVhLTVlYWNhYzc3ZDBmOSIsImlhdCI6MTUzODQ5NzM3Niwic3ViIjoiZGV2ZWxvcGVyL2M4ZDc4NGY5LWY0MDUtOTg5NC1mMjBiLTg3NGVhYzlhNzlmZSIsInNjb3BlcyI6WyJyb3lhbGUiXSwibGltaXRzIjpbeyJ0aWVyIjoiZGV2ZWxvcGVyL3NpbHZlciIsInR5cGUiOiJ0aHJvdHRsaW5nIn0seyJjaWRycyI6WyI5NS45Mi42OS4xMTciXSwidHlwZSI6ImNsaWVudCJ9XX0.EXORF-G5oyfpzvaRRLoBOw1SnYo-YfFlGnS5H8tKQwXwQhtDm1Cc12PeUcpno8hd2R4PanJdNLJF1dRuKQ0HXA
## Allowed IP: 95.92.69.117
##
## curl -X GET --header 'Accept: application/json' --header "authorization: Bearer <API token>" 'https://api.clashroyale.com/v1/tournaments'
## curl -X GET --header 'Accept: application/json' --header "authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6ImFiYWIzODkxLWQ4M2QtNDgwMC1hNzVhLTVlYWNhYzc3ZDBmOSIsImlhdCI6MTUzODQ5NzM3Niwic3ViIjoiZGV2ZWxvcGVyL2M4ZDc4NGY5LWY0MDUtOTg5NC1mMjBiLTg3NGVhYzlhNzlmZSIsInNjb3BlcyI6WyJyb3lhbGUiXSwibGltaXRzIjpbeyJ0aWVyIjoiZGV2ZWxvcGVyL3NpbHZlciIsInR5cGUiOiJ0aHJvdHRsaW5nIn0seyJjaWRycyI6WyI5NS45Mi42OS4xMTciXSwidHlwZSI6ImNsaWVudCJ9XX0.EXORF-G5oyfpzvaRRLoBOw1SnYo-YfFlGnS5H8tKQwXwQhtDm1Cc12PeUcpno8hd2R4PanJdNLJF1dRuKQ0HXA" 'https://api.clashroyale.com/v1/players/%232UVYQPG2J'
## 


token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6ImFiYWIzODkxLWQ4M2QtNDgwMC1hNzVhLTVlYWNhYzc3ZDBmOSIsImlhdCI6MTUzODQ5NzM3Niwic3ViIjoiZGV2ZWxvcGVyL2M4ZDc4NGY5LWY0MDUtOTg5NC1mMjBiLTg3NGVhYzlhNzlmZSIsInNjb3BlcyI6WyJyb3lhbGUiXSwibGltaXRzIjpbeyJ0aWVyIjoiZGV2ZWxvcGVyL3NpbHZlciIsInR5cGUiOiJ0aHJvdHRsaW5nIn0seyJjaWRycyI6WyI5NS45Mi42OS4xMTciXSwidHlwZSI6ImNsaWVudCJ9XX0.EXORF-G5oyfpzvaRRLoBOw1SnYo-YfFlGnS5H8tKQwXwQhtDm1Cc12PeUcpno8hd2R4PanJdNLJF1dRuKQ0HXA"

myplayertag = "/%232UVYQPG2J"
myclantag = "/%23PG8VC9V"

tplayertag = "/%23992V0CV2U"

## Files
warlogFile = "data/warlog.RDS"
clanStatsFile = "data/clanstats.RDS"

templateFile <- "data/template.html"
outputFile <- "../docs/index.html"

statsJSONfile <- "C:/Data/GDrive/98.CR/alkateia.json"
statsXLSfile <- "C:/Data/GDrive/98.CR/alkateia.xlsx"

# Tag in template HTML file to replace with the table
customTableTag <- "<CLAN_PLAYERS_TABLE>"


## Pretty names for clan stats columns
clanCols = list(
    c("tag", "tag"),
    c("name.x", "Nome"),
    c("currentMember", "Membro?"),
    c("warsEntered", "Guerras"),
    c("collectionDayBattlesPlayed", "Batalhas Colecta"),
    c("cardsEarned", "Cartas ganhas"),
    c("battlesPlayed", "Batalhas finais"),
    c("wins", "Vitórias"),
    c("collectionBattleMisses", "Falhas em colecta"),
    c("finalBattleMisses", "Falhas em batalha"),
    c("winRate", "% de vitórias"),
    c("expLevel", "Nível"),
    c("trophies", "Troféus"),
    c("bestTrophies", "Máx. troféus"),
    c("totalWins", "Vitórias totais"),
    c("totalLosses", "Derrotas totais"),
    c("battleCount", "Batalhas totais"),
    c("threeCrownWins", "VitÃórias 3 coroas"),
    c("challengeCardsWon", "Cartas em desafios"),
    c("challengeMaxWins", "Máx vitórias em desafios"),
    c("tournamentCardsWon", "Cartas em torneios"),
    c("tournamentBattleCount", "Batalhas em torneios"),
    c("role", "Nível no clã"),
    c("donations", "Doções"),
    c("donationsReceived", "Doações recebidas"),
    c("totalDonations", "Total de doções"),
    c("warDayWins", "Vitórias em guerras"),
    c("clanCardsCollected", "Cartas colectadas"),
    c("arena", "Arena"),
    c("WARSCORE", "Contributo para o clã")
)


## XLX Description sheet
descs = list(
    c("tag", "Identificador ÃÂºnico do jogador"), 
    c("name.x", "Nome actual do jogador "), 
    c("currentMember", "Indica se ÃÂ© ou nÃÂ£o membro actual do clÃÂ£ (Yes - ÃÂ© membro; No - jÃÂ¡ nÃÂ£o ÃÂ© membro)"), 
    c("warsEntered", "NÃÂºmero de guerras de clÃÂ£ em que participou"), 
    c("collectionDayBattlesPlayed", "NÃÂºmero de batalhas da colecta em que participou. Deveria ser 3 x nÃÂºmero de guerras, mas por vezes hÃÂ¡ quem nÃÂ£o faÃÂ§a as 3 batalhas da colecta"), 
    c("cardsEarned", "NÃÂºmero total de cartas ganhas para o clÃÂ£ nas colectas em que participou"), 
    c("battlesPlayed", "NÃÂºmero de batalhas finais que jogou. Pode ser maior que o nÃÂºmero de guerras em que participou porque alguns jogadores tÃÂªm 2 batalhas"), 
    c("wins", "NÃÂºmero de vitÃÂ³rias em batalhas finais"), 
    c("collectionBattleMisses", "NÃÂºmero de batalhas da colecta nÃÂ£o jogadas (ÃÂ© mau...)"), 
    c("finalBattleMisses", "NÃÂºmero de batalhas finais nÃÂ£o jogadas (ÃÂ© muito mau!!...)"), 
    c("winRate", "Taxa de vitÃÂ³rias em batalhas finais (alguÃÂ©m consegue 100%?)"), 
    c("WARSCORE", "Indicador do nÃÂ­vel de desempenho em guerras (Quanto maior for, melhor!!)"), 
    c("expLevel", "NÃÂ­vel no jogo (1 a 13)"), 
    c("trophies", "NÃÂºmero de trofÃÂ©us actual"), 
    c("bestTrophies", "NÃÂºmero mÃÂ¡ximo de trofÃÂ©us jÃÂ¡ atingido (PB)"), 
    c("totalWins", "NÃÂºmero total de vitÃÂ³rias em todas as batalhas no jogo"), 
    c("totalLosses", "NÃÂºmero total de derrotas em todas as batalhas no jogo"), 
    c("battleCount", "NÃÂºmero total de batalhas em que entrou no jogo"), 
    c("threeCrownWins", "NÃÂºmero de batalhas em que ganhou com 3 coroas"), 
    c("challengeCardsWon", "NÃÂºmero de cartas ganhas em desafios"), 
    c("challengeMaxWins", "MÃÂ¡ximo de vitÃÂ³rias jÃÂ¡ atingido num desafio"), 
    c("tournamentCardsWon", "NÃÂºmero de cartas ganhas em torneios"), 
    c("tournamentBattleCount", "NÃÂºmero de batalhas em torneios"), 
    c("role", "NÃÂ­vel no clÃÂ£ - LÃÂ­der (leader), Co-lÃÂ­der (coLeader), AnciÃÂ£o (elder) ou Membro (member)"), 
    c("donations", "NÃÂºmero de cartas doadas nesta semana"), 
    c("donationsReceived", "NÃÂºmero de cartas recebidas esta semana"), 
    c("totalDonations", "NÃÂºmero total de doaÃÂ§ÃÂµes efectuadas no jogo, desde sempre"), 
    c("warDayWins", "Total de vitÃÂ³rias em guerras de clÃÂ£s (desde sempre, inclundo noutros clÃÂ£s anteriores)"), 
    c("clanCardsCollected", "Total de cartas colectadas em guerras de clÃÂ£s (desde sempre, inclundo noutros clÃÂ£s anteriores)"), 
    c("arena", "Arena ou liga actual")
)
 
   