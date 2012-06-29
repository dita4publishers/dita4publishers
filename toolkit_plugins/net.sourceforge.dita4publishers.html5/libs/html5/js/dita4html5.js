(function (window) {
    var d4h5 = {

        version: '0.1a',
        // toc url - to be implemented
        // the idea is to have the reference to the toc on every page.
        // if someone come on a specific page trough a search engine
        // the code will load the toc parent and render the page properly.
        toc: '',

        // selector for the element which contain the content
        outputSelector: '#main-content',

        // navigationSelector
        navigationSelector: '#left-navigation',

        // element which contains the content to show after the AJAX call
        externalContentElement: 'section',

        // is initial content should be loaded after init()
        loadInitialContent: true,

        // store navigation key:href, value:id
        nav: [],

        // hash (for later)
        hash: {
            current: '',
            previous: '',
            id: 'q'
        },

        // used to attribute and id to the navigation tree
        ids: {
            n: 0,
            prefix: 'page-'
        },

        // store current content
        title: '',
        content: '',

        transition: {
            opacity: 0.5
        },
		
		// registered modules
        mod: [],

        // from jQuery
        // use a modified version of the $.load function
        // for specific purpose
        rscript: '/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi',

        register: function (id) {
            this.mod.push(id);
        },

        init: function (options) {

            $.extend(true, this, options);
			
			// initialize
            for (i in this.mod) {
                var fn = this.mod[i];
                this[fn].init.call();
            }

            // register callbacks for page


            // Bind an event to window.onhashchange that, when the history state changes,
            // iterates over all .bbq widgets, getting their appropriate url from the
            // current state. If that .bbq widget's url has changed, display either our
            // cached content or fetch new content to be displayed.
            $(window).bind('hashchange', function (e) {

                state = $.bbq.getState($(this).attr('id')) || '';
                uri = state[d4h5.hash.id];

                if (uri === '') {
                    return;
                }

                d4h5.ajax.loadHTML(uri);
                d4h5.navigation.select(uri);

            });

            return true;

        }

    };

    window.d4h5 = d4h5;

})(window);