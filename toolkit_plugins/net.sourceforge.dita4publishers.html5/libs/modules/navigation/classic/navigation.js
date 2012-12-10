/**
 *  @file navigation module
 *
 *  A classic navigation behavior
 *  There is room for improvement
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
(function (window, d4p) {

  var navigation = new d4p.module('navigation', {
  
  	'icon': 'ui-icon',
  
  	'leaf': 'ui-icon-triangle-1-e',
  	
  	'leafActive': 'ui-icon-triangle-1-s',
  	
  	'toolbar': {
  	  'id':'navToolBar',
  	  'position':'top'
  	},
  	
  	'buttons': false,

    // select the right entry in the navigation
    select: function () {
      var o = this, 
      l = d4p.l(),
      id = d4p.ajax.collection[l.uri].id;

      $(d4p.navigationSelector + ' li')
        .removeClass('selected')
        .removeAttr('aria-expanded');
        
      $("span."+o.icon).removeClass(o.leafActive).addClass(o.leaf);  

      $('#' + id).parent('li').attr('aria-expanded', 'true').addClass('selected');
      
      $('#' + id).parents('li').each(function(){
        $(this).children("span."+o.icon)
          .removeClass(o.leaf)
          .addClass(o.leafActive);      
      });

      $('#' + id)
        .parentsUntil(d4p.navigationSelector)
        .addClass('active')
        .removeClass('collapsed');
    },

    selectFromHash: function () {
      this.select(this.hashVal());
    },

    traverse: function () {
    
      var o = this;
      
      $(d4p.navigationSelector + ' li')
        .each(function (index) {
        
            var span = {}, span2 = {};

        $(this)
          .attr('role', 'treeitem');

        //if li has ul children add class collapsible
        if ($(this)
          .children('ul')
          .length == 1) {

          // create span for icone
          span = $("<span/>");
          span.addClass(o.icon + " " + o.leaf);

          span.click(function () {
            $(this)
              .parent()
              .toggleClass('active', '')
              .toggleClass('collapsed', '')
              .attr('aria-expanded', $(this)
              .parent()
              .hasClass('active'));
			$(this).toggleClass(o.leaf).toggleClass(o.leafActive);
          });

          // wrap text node with a span if exists
          $(this)
            .contents()
            .each(function () {

            if (this.nodeType == 3) { // Text only
              span2 = $("<span />");
              span2.addClass("navtitle");

              // li click handler
              span2.click(function () {
                $(this)
                  .parent()
                  .toggleClass('active', '');
                $(this)
                  .parent()
                  .toggleClass('collapsed', '');
                $(this)
                  .prev()
                  .toggleClass(o.leaf)
                  .toggleClass(o.leafActive);
              });

              $(this)
                .wrap(span2);

            }
          });


          // add class
          $(this)
            .prepend(span)
            .addClass('collapsible collapsed');


          // link click handler
          $(this)
            .find('a')
            .click(function () {
            // remove previous class
            $(d4p.navigationSelector + ' li')
              .removeClass('selected');
            $(d4p.navigationSelector + ' li')
              .removeClass('active')
              .addClass('collapsed');

            // add selected class on the li parent element
            $(this)
              .parentsUntil(d4p.navigationSelector)
              .addClass('active')
              .removeClass('collapsed');

            // set all the parent trail active
            $(this)
              .parent('li')
              .addClass('selected');
              
            $(this)
               .parent('li')
               .children(".span."+o.icon)
               .toggleClass(o.leaf)
               .toggleClass(o.leafActive);
          });

        } else {

          $(this).addClass('no-child');

        }
      });
    },
    
    addToolbar: function () {
      if(this.toolbar.position == 'top') {
         $(d4p.navigationSelector).prepend($("<div />").attr('id', this.toolbar.id).attr('class', 'toolbar top'));
      } else {
        $(d4p.navigationSelector).append($("<div />").attr('id', this.toolbar.id).attr('class', 'toolbar bottom'));
      }  	
    },
    
    addButtons: function () {
      var o = this,
      buttonExpand = $("<button/>").html("Expand All").click(function(){
      	$(d4p.navigationSelector + ' li')
      	  .addClass('selected')
      	  .removeClass('collapsed')
          .attr('aria-expanded', 'true');
        
           $("span."+o.icon).addClass(o.leafActive).removeClass(o.leaf);  

        }),
      buttonCollapse = $("<button/>").html("Collapse All").click(function(){
        o.select();
      	$(d4p.navigationSelector + ' li')
          .removeClass('selected')
          .addClass('collapsed')
          .removeAttr('aria-expanded');
        
           $("span."+o.icon).removeClass(o.leafActive).addClass(o.leaf); 
           o.select();
      });
      $('#'+this.toolbar.id).append(buttonExpand);
      $('#'+this.toolbar.id).append(buttonCollapse);
    },

    init: function (fn) {

      $(d4p.navigationSelector + " > ul")
        .attr('role', 'tree');
      $(d4p.navigationSelector + " li ul")
        .attr('role', 'group');

      this.bind('docReady', 'selectFromHash');
      this.bind('uriChange', 'select');
      this.traverse();
      
      if(this.buttons) {
      	this.addToolbar();
      	this.addButtons();
      }

    }

  });

})(window, d4p);