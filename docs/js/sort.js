$(function($){
    $('#warStats').tablesorter({
      widgets: ['zebra'],
      widgetZebra: { css: ['odd', 'even' ] }
    }); 

    $('#playerStats').tablesorter({
      widgets: ['zebra'],
      widgetZebra: { css: ['odd', 'even' ] }
    }); 

    $('#warMap').tablesorter({
      widgets: ['zebra'],
      widgetZebra: { css: ['odd', 'even' ] }
    }); 

  });
