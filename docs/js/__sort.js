function sortWarStats() {

    $('#warStats').tablesorter({
      widgets: ['zebra'],
      widgetZebra: { css: ['odd', 'even' ] }
    }); 
}

function sortplayerStats() {

    $('#playerStats').tablesorter({
      widgets: ['zebra'],
      widgetZebra: { css: ['odd', 'even' ] }
    }); 
}

function sortWarMap() {
    $('#warMap').tablesorter({
      widgets: ['zebra'],
      widgetZebra: { css: ['odd', 'even' ] }
    });
}

function sortPlayerEvolution() {
    $('#playerEvolution').tablesorter({
      widgets: ['zebra'],
      widgetZebra: { css: ['odd', 'even' ] }
    }); 
}
  