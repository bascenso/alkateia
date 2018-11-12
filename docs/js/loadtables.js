$(function(){
    $("div#lastUpdate").load("data/lastupdate.html")
    $("div#warStatsTable").load("data/warstats.html", sortWarStats);
    $("div#playerStatsTable").load("data/playerstats.html", sortPlayerStats);
    $("div#warMapTable").load("data/warmap.html", sortWarMap);
    $("div#playerEvolutionTable").load("data/playerevolution.html", sortPlayerEvolution);

    function sortWarStats() {
        $('#warStats').tablesorter({
            sortInitialOrder: "desc",
            widgets: ['zebra'],
            widgetZebra: { css: ['odd', 'even' ] }
        }); 
    }
    
    function sortPlayerStats() {
        $('#playerStats').tablesorter({
            sortInitialOrder: "desc",
            widgets: ['zebra'],
            widgetZebra: { css: ['odd', 'even' ] }
        }); 
    }
    
    function sortWarMap() {
        $('#warMap').tablesorter({
            sortInitialOrder: "desc",
            widgets: ['zebra'],
            widgetZebra: { css: ['odd', 'even' ] }
        });
    }
    
    function sortPlayerEvolution() {
        $('#playerEvolution').tablesorter({
            sortInitialOrder: "desc",
            widgets: ['zebra'],
            widgetZebra: { css: ['odd', 'even' ] }
        }); 
    }
});