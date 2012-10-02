/**
 * Module object
 */ (function (window, d4p) {


    var ajaxnav = new d4p.module('ajaxnav', {

        traverse: function () {
            // navigation: prefix all href with #
            $(d4p.navigationSelector + ' a')
                .each(function (index) {

                var id = $(this)
                    .attr('id');
                var href = $(this)
                    .attr('href');


                // attribute an ID for future reference if not set
                if (id === '' || id == undefined) {
                    id = d4p.ids.prefix + d4p.ids.n;
                    d4p.ids.n++;
                    $(this).attr('id', id);
                }

                // keep information in memory when link is triggered on page
                d4p.nav[href] = id;

                // replace href
                $(this).attr('href', '#' + href);

                // push the appropriate state onto the history when clicked.
                d4p.live($(this));

            });

            $(d4p.navigationSelector).find('li').each(function (index) {
                if ($(this).children('a').length === 0) {
                    var l = $(this).find('ul li a:first');
                    if (l.length == 1) {
                        $(this).children('span.navtitle').click(function () {
                            d4p.ajax.load(l.attr('href')
                                .replace(/^#/, ''));
                        });
                    }
                }
            });
        },

        load: function (uri) {
            d4p.ajax.load(uri);
        },

        init: function () {
        
        	d4p.ajax = new d4p.ajaxLoader(d4p.outputSelector);
            d4p.ajax.addLoader();
            d4p.ajax.ready('rewriteAttrHref');
            d4p.ajax.ready('rewriteAttrSrc');
            d4p.ajax.ready('setTitle');
            
            this.traverse();
            this.uriChange('load');
        }
    });

})(window, d4p);
