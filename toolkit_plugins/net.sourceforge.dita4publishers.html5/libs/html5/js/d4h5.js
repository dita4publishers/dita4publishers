(function (window) {
    var d4p = {

        version: '0.2a',

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

        // selectors
        outputSelector: "#d4h5-main-content",

        navigationSelector: "#local-navigation",

        externalContentElement: "section",

        loaderParentElement: "body",

        // used to attribute and id to the navigation tree
        ids: {
            n: 0,
            prefix: 'd4p-page-'
        },

        // active content
        uri: '',

        title: '',

        content: '',

        transition: {
            speed: 'slow',
            opacity: 0.5
        },

        // registered modules
        mod: [],

        // uri change functions
        _uriChange: [],

        // scrollElement
        scrollElem: {},

        //scroll duration in ms
        scrollDuration: 400,

        // from jQuery
        rscript: '/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi',

        // register a module init function will be called
        // once document is loaded.
        // I added this feature to allow user to set options
        // before their module are called.

        _docReady: [],

        docIsReady: function () {
            for (i in this._docIsReady) {
                var fn = d4p._docIsReady[i];
                fn.call(this, this.uri, this.hash.current);
            }
        },

        // find if an element is scrollable
        scrollableElement: function (els) {
            for (var i = 0, argLength = arguments.length; i < argLength; i++) {
                var el = arguments[i],
                    $scrollElement = $(el);

                if ($scrollElement.scrollTop() > 0) {
                    return el;
                } else {
                    $scrollElement.scrollTop(1);
                    var isScrollable = $scrollElement.scrollTop() > 0;
                    $scrollElement.scrollTop(0);

                    if (isScrollable) {
                        return el;
                    }
                }
            }
            return [];
        },

        scrollToHash: function (hash) {
            if (hash != "" && hash != undefined) {
                var targetOffset = $(hash)
                    .offset()
                    .top;
                $(d4p.scrollElem)
                    .animate({
                    scrollTop: targetOffset
                },
                d4p.scrollDuration);
            }
        },

        setProps: function (options) {
            // extend options
            $.extend(true, this, options);
        },

        // set AJAX callback on the specified link obj.
        live: function (obj) {
            obj.live('click', function (e) {

                var state = {};

                // Set the state!
                state[d4p.hash.id] = $(this)
                    .attr('href')
                    .replace(/^#/, '');

                $.bbq.pushState(state);

                // And finally, prevent the default link click behavior by returning false.
                return false;
            });
        },
        
        // load initial content to avoid a blank page
        getInitialContent: function () {
            if ($(d4p.outputSelector)
                .length == 1 && d4p.loadInitialContent) {
                var url = "";
                if (window.location.hash !== '') {
                    url = window.location.hash.replace(/^#/, '');
                    url = url.replace(/^q=/, '');
                    d4p.core.ajax.load(url);
                } else {
                    var el = $(d4p.navigationSelector + ' a:first-child');
                    if (el.attr('href') == undefined) {
                        return false;
                    }
                    url = $(d4p.navigationSelector + ' a:first-child')
                        .attr('href')
                        .replace(/^#/, '');
                    window.location.hash = "q=" + url;
                }
                d4p.loadInitialContent = false;
            }
        },

        init: function (options) {

            // extend options
            $.extend(true, this, options);

            //
            this.scrollElem = this.scrollableElement('html', 'body');

            // initialize
            for (i in this.mod) {
                var fn = this.mod[i];
                this[fn].init.call(this[fn]);
            }

            // Bind an event to window.onhashchange that, when the history state changes,
            // iterates over all .bbq widgets, getting their appropriate url from the
            // current state. If that .bbq widget's url has changed, display either our
            // cached content or fetch new content to be displayed.
            $(window)
                .bind('hashchange', function (e) {

                state = $.bbq.getState($(this)
                    .attr('id')) || '';
                uri = state[d4p.hash.id];

                if (uri === '' || uri == undefined) {
                    return;
                }

                var idx = uri.indexOf('#');
                var hash = idx != -1 ? uri.substring(idx) : "";

                for (i in d4p._uriChange) {
                    var fn = d4p._uriChange[i];
                    d4p[fn.name][fn.fn].call(d4p[fn.name], uri, hash);
                }

            });

            this.getInitialContent();

            return true;

        }

    };

    window.d4p = d4p;

})(window);

/**
 * Module object
 */ (function (window, d4p) {

    d4p.module = function (name, obj) {

        this.name = name;

        // set option
        for (i in obj) {
            if (this[i] == undefined) {
                this[i] = obj[i];
            }
        }

        // register component in d4p	
        if (this.init != undefined) {
            d4p.mod.push(name);
        }

        d4p[name] = this;

    };

    d4p.module.prototype.hashVal = function () {
        this.hash.current.replace(/^#/, '');
    };

    d4p.module.prototype.docReady = function (fname) {
        d4p._docReady.push({
            name: this.name,
            fn: fname
        });
    };

    // register a hashChange callback
    d4p.module.prototype.uriChange = function (fname) {
        d4p._uriChange.push({
            name: this.name,
            fn: fname
        });
    };


})(window, d4p);


