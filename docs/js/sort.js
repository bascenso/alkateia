$(function($){
    $('#warStats').tablesorter({
      widgets: ['zebra'],
      widgetZebra: { css: ['odd', 'even' ] }
    }); 

    $('#playerStats').tablesorter({
      widgets: ['zebra'],
      widgetZebra: { css: ['odd', 'even' ] }
    }); 

  });
