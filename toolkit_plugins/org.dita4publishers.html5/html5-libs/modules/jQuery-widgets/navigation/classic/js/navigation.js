/**
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
var navigation = {

  'icon': 'ui-icon',

  'leaf': 'ui-icon-triangle-1-e',

  'leafActive': 'ui-icon-triangle-1-s',

  'toolbar': {
    'id': 'navToolBar',
    'position': 'top'
  },

  'buttons': false,

  traverse: function () {

    var o = this;

    $("#local-navigation" + ' li')
      .each(function (index) {

         var span = {}, span2 = {};

         $(this).attr('role', 'treeitem');

         //if li has ul children add class collapsible
         if ($(this).hasClass('collapsible')) {

            // create span for icone
            span = $("<span/>");
            span.addClass(o.icon);
            span.addClass($(this).hasClass('active') ? o.leafActive : o.leaf);
            span.on('click', function() {
              $(this).parent().toggleClass('active').toggleClass('collapsed');
            });
            $(this).prepend(span);
          }
        }
      );
    },

    addToolbar: function () {
      if(this.toolbar.position == 'top') {
         $("#local-navigation").parent().prepend($("<div />").attr('id', this.toolbar.id).attr('class', 'toolbar top'));
      } else {
        $("#local-navigation").parent().append($("<div />").attr('id', this.toolbar.id).attr('class', 'toolbar bottom'));
      }
    },

    addButtons: function () {
      var o = this,
      expandIco = $("<span/>").attr("class", "ui-icon ui-icon-carat-2-n-s"),
      collapseIco = $("<span/>").attr("class", "ui-icon ui-icon-carat-2-n"),
      expand = $("<span/>").attr("class", "hidden").html("Expand All"),
      collapse = $("<span/>").attr("class", "hidden").html("Collapse All"),
      btnExpand = $("<button/>").attr('id', 'expandBtn').attr('class', 'ui-state-default').append(expandIco).append(expand).click(function(){
        $("#local-navigation" + ' li')
          .addClass('selected')
          .removeClass('collapsed')
          .attr('aria-expanded', 'true');

           $(this).hide();
           $('#collapseBtn').show();

        }),
      btnCollapse = $("<button/>").attr('id', 'collapseBtn').attr('class', 'ui-state-default').append(collapseIco).append(collapse).hide().click(function(){
        o.select();
        $("#local-navigation" + ' li')
          .removeClass('selected')
          .addClass('collapsed')
          .removeAttr('aria-expanded');

           o.select();
           $(this).hide();
           $('#expandBtn').show();
      });

      $('#'+this.toolbar.id).append(btnExpand);
      $('#'+this.toolbar.id).append(btnCollapse);
    },

    init: function (fn) {

      $("#local-navigation" + " > ul").attr('role', 'tree');
      $("#local-navigation" + " li ul").attr('role', 'group');

      this.traverse();

      if(this.buttons) {
        this.addToolbar();
        this.addButtons();
      }

    }
    };

    $(function() {
      navigation.init();
    });


