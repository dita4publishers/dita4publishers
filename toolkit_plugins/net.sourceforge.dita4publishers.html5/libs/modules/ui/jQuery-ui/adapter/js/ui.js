/**
 *  @file jQuery UI adapter
 *
 *  Allows to interact with the DITA <-> jQuery UI library
 *
 *  Copyright 2012 DITA For Publishers  
 * 
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */ 
(function (d4p) {

  // new prototype
  // register a hashChange callback
  d4p.ajaxLoader.prototype.addWidgets = function () {
    $("*[class]").each(function (index) {
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
            console.log(ui);
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
      d4p.ajax.bind('ready', 'addWidgets');
    }
  });
})(d4p);