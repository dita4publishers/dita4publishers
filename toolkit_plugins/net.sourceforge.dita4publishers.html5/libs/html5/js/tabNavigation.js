(function (d4h5) {

    // use only if you want tabbed navigation
    // experimental UI
    var tabnav = {
    
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
            d4h5.tabnav.addTabUI();
            d4h5.tabnav.addToolBar();
            d4h5.ajax.before(d4h5.tabnav.prepare);  
            d4h5.ajax.ready(d4h5.tabnav.show);
            d4h5.ajax.failed(d4h5.tabnav.failed);         
        },
        
        prepare: function () {
        	$(d4h5.outputSelector).hide();
        	$(d4h5.tabnav.tabContainerSelector).hide();
        	$(d4h5.tabnav.tooboxSelector).hide();  
        },
        
        failed: function () {
        	$(d4h5.tabnav.tabContainerSelector).show();
        },
        
        show: function () {
            $(d4h5.tabnav.tabContainerSelector).hide();
            $(d4h5.tabnav.tooboxSelector).show();  
            $(d4h5.outputSelector).show();         
        },
        
        hide: function () {
       		$(d4h5.outputSelector).hide();   
        	$(d4h5.tabnav.tabContainerSelector).show();
        },
        
        addTabUI: function () {
			$( d4h5.tabnav.tabSelector ).tabs({
   		        select: function(event, ui) { 
					d4h5.tabnav.hide();
					$(d4h5.tabnav.tooboxSelector).hide();		
					d4h5.tabnav.positionMenu(ui.index);				
   			    }
			});
			d4h5.tabnav.positionMenu(-1);    
        },
        
        positionMenu: function ( index ) {
        	var tabs = $(d4h5.tabnav.tabSelector).tabs();
			var index = index == -1 ? tabs.tabs('option', 'selected') : index;
			console.log(index);
			var parent = $(d4h5.tabnav.tabSelector + " ul>li:nth-child(" + (index + 1) + ")");
   		     	        
			var parentLeft = parent.position().left;
			var parentWidth = parent.outerWidth();
				
			var menu = $("#menu-label");
			var menuWidth = menu.outerWidth();
				
			var left = parentLeft + parentWidth / 2 - menuWidth / 2;
				
			$("#menu-label").css("left", left+"px");
        
        },
        
        addToolBar: function () {
        	
        	var toolBar = $("<div />").attr('id', d4h5.tabnav.tooboxSelector.substring(1));
        	
        	var menu = $("<h2 />").attr("id", "menu-label");
        	
        	var ico = $("<span />").attr('class', 'ico grip');
        	var ico2 = ico.clone();
        	var title = $("<span />").html("Menu");
        	
        	menu.append(ico);
            menu.append(title);
            menu.append(ico2);
            
            toolBar.append(menu);
            
        	$(d4h5.tabnav.tabContainerSelector).before(toolBar);    	    	
        	
        	$(d4h5.tabnav.tooboxSelector).click(function(){
        	   d4h5.tabnav.hide();
        	   $(d4h5.tabnav.tooboxSelector).hide();
        	   document.location.hash = "";
        	});
        	
        	$(d4h5.tabnav.tooboxSelector).hide();
        	
        }
    };

    d4h5.register('tabnav');
    d4h5.tabnav = tabnav;

})(d4h5);