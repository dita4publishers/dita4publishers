(function (window) {
    var d4h5 = {

        version: '0.1a',
        
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
        
        // hash change functions
        _hashChange: [],

        // from jQuery
        // use a modified version of the $.load function
        // for specific purpose
        rscript: '/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi',

		// register a module init function will be called
		// once document is loaded.
		// I added this feature to allow user to set options
		// before their module are called.
        register: function (id) {
            this.mod.push(id);
        },
        
        // register a hashChange callback
        hashChange: function (fn) {
            this._hashChange.push(fn);
        },

        init: function (options) {

            $.extend(true, this, options);
			
			// initialize
            for (i in this.mod) {
                var fn = this.mod[i];
                this[fn].init.call();
            }

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
                
                for (i in d4h5._hashChange) {
                	var fn = d4h5._hashChange[i];
                	fn.call(this, uri);
            	}

            });

            return true;

        }

    };

    window.d4h5 = d4h5;

})(window);