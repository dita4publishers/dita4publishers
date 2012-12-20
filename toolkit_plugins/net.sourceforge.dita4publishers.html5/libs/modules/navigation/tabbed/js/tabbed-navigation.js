/**
 *  @file tabbed-navigation.js
 *
 *  !experimental, not ready
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

	d4p.ajaxLoader.prototype.prepare = function () {
        $(d4p.outputSelector).hide();
        $(d4p.tabnav.tabContainerSelector).hide();
        //$(d4p.tabnav.tooboxSelector).hide();  
    };
    
    d4p.ajaxLoader.prototype.show = function () {
        $(d4p.tabnav.tabContainerSelector).hide();
        //$(d4p.tabnav.tooboxSelector).show();  
        $(d4p.outputSelector).show(); 
        $(d4p.tabnav.tabSelector).tabs( 'selected' , -1 );
         $(".ui-tabs-selected")
         .removeClass("ui-state-active")
         .removeClass("ui-tabs-selected");        
    };
      
    d4p.ajaxLoader.prototype.failed = function () {
        $(d4p.tabnav.tabContainerSelector).show();
    };
        

    // use only if you want tabbed navigation
    // experimental UI
    var ajaxnav = new d4p.module('tabnav', {
    
    	// tab selector
    	tabSelector: '#tabs-navigation',
    
        // id of the div element to be created
        tabContainerSelector: '#tab-container',
        
        // tab selector
    	tooboxSelector: '#tab-tools',
        
        // duration
        duration: 'slow',
        
        // create message container    
        init: function () {
            this.addTabUI();
           // this.addToolBar();
            d4p.ajax.bind('before', 'prepare');  
            d4p.ajax.bind('ready', 'show');
            d4p.ajax.bind('failed', 'failed');         
        },
    
        
        hide: function () {
       		$(d4p.outputSelector).hide();   
        	$(d4p.tabnav.tabContainerSelector).show();
        },
        
        addTabUI: function () {
			$( d4p.tabnav.tabSelector ).tabs({
   		        select: function(event, ui) { 
					d4p.tabnav.hide();
					$(d4p.tabnav.tooboxSelector).hide();		
					d4p.tabnav.positionMenu(ui.index);
					document.location.hash = ui.tab.hash;						
   			    }
			});
			d4p.tabnav.positionMenu(-1);    
        },
        
        positionMenu: function ( index ) {
        	var tabs = $(d4p.tabnav.tabSelector).tabs();
			var index = index == -1 ? tabs.tabs('option', 'selected') : index;
			console.log(index);
			var parent = $(d4p.tabnav.tabSelector + " ul>li:nth-child(" + (index + 1) + ")");
   		     	        
			var parentLeft = parent.position().left;
			var parentWidth = parent.outerWidth();
				
			var menu = $("#menu-label");
			var menuWidth = menu.outerWidth();
				
			var left = parentLeft + parentWidth / 2 - menuWidth / 2;
				
			$("#menu-label").css("left", left+"px");
        
        },
        
        addToolBar: function () {
        	
        	var toolBar = $("<div />").attr('id', d4p.tabnav.tooboxSelector.substring(1));
        	
        	var menu = $("<h2 />").attr("id", "menu-label");
        	
        	var ico = $("<span />").attr('class', 'ico grip');
        	var ico2 = ico.clone();
        	var title = $("<span />").html("Menu");
        	
        	menu.append(ico);
            menu.append(title);
            menu.append(ico2);
            
            toolBar.append(menu);
            
        	$(d4p.tabnav.tabContainerSelector).before(toolBar);    	    	
        	
        	$(d4p.tabnav.tooboxSelector).click(function(){
        	   d4p.tabnav.hide();
        	   $(d4p.tabnav.tooboxSelector).hide();
        	   document.location.hash = "";
        	});
        	
        	$(d4p.tabnav.tooboxSelector).hide();
        	
        }
    });

})(d4p);