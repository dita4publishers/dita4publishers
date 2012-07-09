(function (d4h5) {

    var navigation = {
		// select the right entry in the navigation
        select: function (uri) {
            var id = d4h5.nav[uri];
            $(d4h5.navigationSelector + ' li').removeClass('selected').removeAttr('aria-expanded');

            $('#' + id).parent('li').attr('aria-expanded', 'true').addClass('selected');
            $('#' + id).parentsUntil(d4h5.navigationSelector).addClass('active').removeClass('collapsed');
        },

        selectFromHash: function () {
            d4h5.navigation.select(d4h5.hash.current.replace(/^#/, ''));
        },
        

        traverse: function () {
            $(d4h5.navigationSelector + ' li').each(function (index) {
            
            	$(this).attr('role', 'treeitem');

                //if li has ul children add class collapsible
                if ($(this).children('ul').length == 1) {

                    // create span for icone
                    var span = $("<span/>");
                    span.addClass("ico");

                    span.click(function () {
                        $(this).parent().toggleClass('active', '').toggleClass('collapsed', '').attr('aria-expanded', $(this).parent().hasClass('active'));

                    });

                    // wrap text node with a span if exists
                    $(this).contents().each(function () {

                        if (this.nodeType == 3) { // Text only
                            var span2 = $("<span />");
                            span2.addClass("navtitle");

                            // li click handler
                            span2.click(function () {
                                $(this).parent().toggleClass('active', '');
                                $(this).parent().toggleClass('collapsed', '');

                            });

                            $(this).wrap(span2);

                        }
                    });


                    // add class
                    $(this).prepend(span).addClass('collapsible collapsed');


                    // link click handler
                    $(this).find('a').click(function () {
                        // remove previous class
                        $(d4h5.navigationSelector + ' li').removeClass('selected');
                        $(d4h5.navigationSelector + ' li').removeClass('active').addClass('collapsed');

                        // add selected class on the li parent element
                        $(this).parentsUntil(d4h5.navigationSelector).addClass('active').removeClass('collapsed');

                        // set all the parent trail active
                        $(this).parent('li').addClass('selected')
                    });

                } else {

                    $(this).addClass('no-child');

                }
            });
        },
        
        init: function () {
       		$(d4h5.navigationSelector + " > ul").attr('role', 'tree');
       		$(d4h5.navigationSelector + " li ul").attr('role', 'group');
        	d4h5.ajax.ready(d4h5.navigation.selectFromHash);
        	d4h5.hashChange(d4h5.navigation.select);
            d4h5.navigation.traverse();
        }
    };
    
    d4h5.register('navigation');
    d4h5.navigation = navigation;

})(d4h5);