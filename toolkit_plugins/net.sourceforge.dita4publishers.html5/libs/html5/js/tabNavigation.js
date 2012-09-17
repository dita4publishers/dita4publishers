(function (d4h5) {

    // use only if you want tabbed navigation
    // experimental UI
    var tabNavigation = {
    
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
            d4h5.tabNavigation.addTabUI();
            d4h5.tabNavigation.addToolBar();
            d4h5.ajax.ready(d4h5.tabNavigation.slideUp);           
        },
        
        slideUp: function () {
            $(d4h5.tabNavigation.tabContainerSelector).slideUp(d4h5.tabNavigation.duration, function(){
            	$(d4h5.outputSelector).show();           
            });
            
        },
        
        slideDown: function () {
        	$(d4h5.tabNavigation.tabContainerSelector).slideDown(d4h5.tabNavigation.duration, function(){
            	$(d4h5.outputSelector).hide();           
            });
        },
        
        addTabUI: function () {
			$( d4h5.tabNavigation.tabSelector ).tabs({
   		        select: function(event, ui) {
   				    d4h5.tabNavigation.slideDown();
   			    }
			});
        },
        
        addToolBar: function () {
        	$(d4h5.tabNavigation.tabContainerSelector).before($("<div />").attr('id', d4h5.tabNavigation.tooboxSelector.substring(1)));
        	$(d4h5.tabNavigation.tooboxSelector).click(function(){
        	   d4h5.tabNavigation.slideDown();
        	});
        }
    };

    d4h5.register('tabNavigation');
    d4h5.tabNavigation = tabNavigation;

})(d4h5);

