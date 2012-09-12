(function (d4h5) {

    // use only if you want tabbed navigation
    var tabNavigation = {
    
        // id of the div element to be created
        tabContainerSelector: '#tab-container',
        
        // create message container    
        init: function () {
            d4h5.ajax.ready(d4h5.tabNavigation.slideToggle);
        },
        
        slideToggle: function () {
        	$(d4h5.tabNavigation.tabContainerSelector).slideToggle('slow');
        }
    };

    d4h5.register('tabNavigation');
    d4h5.tabNavigation = tabNavigation;

})(d4h5);
