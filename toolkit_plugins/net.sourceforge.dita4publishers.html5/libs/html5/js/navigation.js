
(function (window, d4p) {

    var nav = new d4p.module('nav', {

        // select the right entry in the navigation
        select: function (uri) {

            var id = d4p.nav[uri];

            $(d4p.navigationSelector + ' li')
                .removeClass('selected')
                .removeAttr('aria-expanded');

            $('#' + id)
                .parent('li')
                .attr('aria-expanded', 'true')
                .addClass('selected');

            $('#' + id)
                .parentsUntil(d4p.navigationSelector)
                .addClass('active')
                .removeClass('collapsed');
        },

        selectFromHash: function () {
            this.select(this.hashVal());
        },

        traverse: function () {
            $(d4p.navigationSelector + ' li')
                .each(function (index) {

                $(this)
                    .attr('role', 'treeitem');

                //if li has ul children add class collapsible
                if ($(this)
                    .children('ul')
                    .length == 1) {

                    // create span for icone
                    var span = $("<span/>");
                    span.addClass("ico");

                    span.click(function () {
                        $(this)
                            .parent()
                            .toggleClass('active', '')
                            .toggleClass('collapsed', '')
                            .attr('aria-expanded', $(this)
                            .parent()
                            .hasClass('active'));

                    });

                    // wrap text node with a span if exists
                    $(this)
                        .contents()
                        .each(function () {

                        if (this.nodeType == 3) { // Text only
                            var span2 = $("<span />");
                            span2.addClass("navtitle");

                            // li click handler
                            span2.click(function () {
                                $(this)
                                    .parent()
                                    .toggleClass('active', '');
                                $(this)
                                    .parent()
                                    .toggleClass('collapsed', '');
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
                            .addClass('selected')
                    });

                } else {

                    $(this)
                        .addClass('no-child');

                }
            });
        },

        init: function (fn) {

            $(d4p.navigationSelector + " > ul")
                .attr('role', 'tree');
            $(d4p.navigationSelector + " li ul")
                .attr('role', 'group');

            this.docReady('selectFromHash');
            this.uriChange('select');
            this.traverse();

        }

    });

})(window, d4p);
