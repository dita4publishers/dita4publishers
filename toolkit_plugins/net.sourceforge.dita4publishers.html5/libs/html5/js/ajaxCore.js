/**
 * Module object
 */ (function (window, d4p) {

    var core = new d4p.module('core', {

        ajax: new d4p.ajaxLoader(d4p.outputSelector),

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

            $(d4p.navigationSelector)
                .find('li')
                .each(function (index) {
                if ($(this)
                    .children('a')
                    .length === 0) {
                    var l = $(this)
                        .find('ul li a:first');
                    if (l.length == 1) {
                        $(this)
                            .children('span.navtitle')
                            .click(function () {
                            loader.loadHTML(l.attr('href')
                                .replace(/^#/, ''));
                        });
                    }
                }
            });
        },

        load: function (uri) {
            this.ajax.load(uri);
        },

        init: function () {
            this.ajax.addLoader();
            this.ajax.ready('rewriteAttrHref');
            this.ajax.ready('rewriteAttrSrc');
            this.traverse();
            this.uriChange('load');
        }
    });

})(window, d4p)