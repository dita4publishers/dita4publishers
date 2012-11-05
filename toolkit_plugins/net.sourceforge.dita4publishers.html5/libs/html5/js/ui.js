/**
 * d4p.ajaxLoader.prototype.addWidgets
 * 
 * allows addition of widgets on the page
 */
(function (d4p) {

  // new prototype
  // register a hashChange callback
  d4p.ajaxLoader.prototype.addWidgets = function () {
    this.content.find("*[class]").each(function (index) {
      var classes = $(this)
        .attr('class')
        .split(" ");

      for (var i = 0, len = classes.length; i < len; i++) {

        var cs = classes[i];
        var idx = cs.indexOf(d4p.ui.prefix);
        var l = d4p.ui.prefix.length;

        if (idx >= 0) {

          var ui = cs.substring(l);

          if (d4p.ui[ui] == undefined) {
            return true;
          }

          if (d4p.ui[ui]['init'] != undefined) {
            d4p.ui[ui]['init'].call(d4p.ui[ui], $(this));
          }
        }
      }
    });
  };
  
})(d4p);

/**
 * interface with ui
 */ 
(function (d4p) {

  var ui = new d4p.module('ui', {

    // prefix
    prefix: "d4p-ui-",

    dialogMinWidth: 600,

    processed: [],

    //    
    init: function () {
      d4p.ajax.ready('addWidgets');
    }
  });
})(d4p);