window.dita4html5.navigation = {
    maxLevel: 3,
    // for later
    maxLevelTransition: 'slideUp',
    // for later
    autoCollapse: false,

    init: function () {
        this.traverse();
    },

    select: function (uri) {
        var id = dita4html5.nav[uri];
        $(dita4html5.navigationSelector + ' li').removeClass('selected');
        $('#' + id).parent('li').addClass('selected');
    },

    selectFromHash: function () {
        dita4html5.navigation.select(dita4html5.hash.current.replace(/^#/, ''));
    },

    traverse: function () {
        // navigation: prefix all href with #
        $(dita4html5.navigationSelector + ' li').each(function (index) {

            //if li has ul children add class collapsible
            if ($(this).children('ul').length == 1) {

                // create span for icone
                var span = $("<span/>");
                span.addClass("ico");

                span.click(function () {
                    $(this).parent().toggleClass('active', '');
                    $(this).parent().toggleClass('collapsed', '');

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
                    $(dita4html5.navigationSelector + ' li').removeClass('selected');
                    $(dita4html5.navigationSelector + ' li').removeClass('active').addClass('collapsed');

                    // add selected class on the li parent element
                    $(this).parentsUntil(dita4html5.navigationSelector).addClass('active').removeClass('collapsed');

                    // set all the parent trail active
                    $(this).parent('li').addClass('selected')
                });

            } else {

                $(this).addClass('no-child');

            }
        });
    }
};