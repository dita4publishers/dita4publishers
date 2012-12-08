/**
 *  @file message
 *
 *  Allow to send quick message to the user
 *  Might have an alternate version to work with UI dialog
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

  // use ui-dialog instead ?

  var message = new d4p.module('msg', {
    // id of the div element to be created
    id: 'd4p-message',

    timeout: 3000,

    // message type
    create: function () {
      var msgBox = $("<div />")
        .attr('id', this.id)
        .attr('role', 'alertdialog')
        .attr('aria-hidden', 'true')
        .attr('aria-label', 'Message')
        .addClass('rounded')
        .hide();
      var div = msgBox.append($("<div />"));
      $('body')
        .append(msgBox);
    },

    // create message container    
    init: function () {
      this.create();

      $(document).mouseup(function (e) {
        var container = $(this.id);

        if (container.has(e.target).length === 0) {
          container.hide();
        }
      });
    },

    show: function () {
      $("#" + this.id)
        .show()
        .attr('aria-hidden', 'false')
        .delay(this.timeout)
        .fadeOut()
        .attr('aria-hidden', 'true');
    },

    alert: function (msg, type) {
      type = type == undefined ? '' : type;
      var p = $("<p />")
        .addClass(type)
        .text(msg);
      $("#" + this.id + " > div")
        .html(p);
      this.show();
    }
  });

})(d4p);