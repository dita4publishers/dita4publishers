window.d4h5.ajax = {

    ajaxReady: [],
    
    // allow to register callback once the page is loaded by AJAX
    ready: function (fn) {
        this.ajaxReady.push(fn);
    },

    // parse navigation
    // replace href by # + href
    // add click event and push state in the history
    // using bbq
    traverse: function () {
        // navigation: prefix all href with #
        $(d4h5.navigationSelector + ' a').each(function (index) {

            var id = $(this).attr('id');
            var href = $(this).attr('href');


            // attribute an ID for future reference if not set
            if (id === '' || id == undefined) {
                id = d4h5.ids.prefix + d4h5.ids.n;
                d4h5.ids.n++;
                $(this).attr('id', id);
            }

            // keep information in memory when link is triggered on page
            d4h5.nav[href] = id;

            // replace href
            $(this).attr('href', '#' + href);

            // push the appropriate state onto the history when clicked.
            d4h5.ajax.live($(this));

        });

        $(d4h5.navigationSelector).find('li').each(function (index) {
            if ($(this).children('a').length === 0) {
                var l = $(this).find('ul li a:first');
                if (l.length == 1) {
                    $(this).children('span.navtitle').click(function () {
                        d4h5.ajax.loadHTML(l.attr('href').replace(/^#/, ''));
                    });
                }
            }
        });
    },

    // add loader (spinner on the page)
    // @todo: add support for localization
    addLoader: function () {
        var title = $("<h2>content is loading</h2>").addClass('hidden');
        var loader = $("<div />").attr("id", "d4h5-loader").append(title);
        $('body').append(loader);
    },

    // called before the ajax request is send
    // used to output a 'loader' on the page  
    contentIsLoading: function () {
        $("#d4h5-loader").show();
        $(d4h5.outputSelector).css('opacity', d4h5.transition.opacity);
    },

    // called at the end of the ajax call
    contentIsLoaded: function () {
        $("#d4h5-loader").hide();
        $(d4h5.outputSelector).css('opacity', 1);
    },

    // this is a modified version of the load function in jquery
    // I kept comments for reference
    // @todo: see if it is neccessary to implement cache here
    // @todo: implement beforeSend, error callback
    loadHTML: function (uri) {
        d4h5.hash.current = uri;
        $.ajax({
            type: 'GET',

            url: uri,

            dataType: 'html',

            beforeSend: function (jqXHR) {
                d4h5.ajax.contentIsLoading();
            },

            complete: function (jqXHR, status, responseText) {
            
                // is status is an error, return an error dialog
                if(status === 'error'){
                    d4h5.message.alert('Sorry, the content could not be loaded', 'error');
                    d4h5.ajax.contentIsLoaded();
                    return false;
                }
                
                // Store the response as specified by the jqXHR object
                responseText = jqXHR.responseText;

                // If successful, inject the HTML into all the matched elements
                if (jqXHR.isResolved()) {

                    // From jquery: #4825: Get the actual response in case
                    // a dataFilter is present in ajaxSettings
                    jqXHR.done(function (r) {
                        responseText = r;
                    });

                    var html = $("<div>").attr('id', d4h5.hash.current).append(responseText.replace(d4h5.rscript, ""));

                    d4h5.content = html.find(d4h5.externalContentElement);

                    d4h5.title = html.find("title").html();

                    for (fn in d4h5.ajax.ajaxReady) {
                        d4h5.ajax.ajaxReady[fn].call(d4h5.content);
                    }

                    d4h5.ajax.contentIsLoaded();
                }
            }
        });
    },

    setTitle: function () {
        $('title').html(d4h5.title);
    },

    setMainContent: function () {
        $(d4h5.outputSelector).html(d4h5.content);
    },

    // Rewrite each src in the document
    // because there is no real path with AJAX call
    rewriteAttrSrc: function () {
        var uri = d4h5.hash.current;
        d4h5.content.find("*[src]").each(function (index) {
            $(this).attr('src', uri.substring(0, uri.lastIndexOf("/")) + "/" + $(this).attr('src'));
        });
    },

    // Rewrite each href in the document
    // because there is no real path with AJAX call
    //
    rewriteAttrHref: function () {
        d4h5.content.find("*[href]").each(function (index) {
            var uri = d4h5.hash.current;
            var dir = uri.substring(0, uri.lastIndexOf("/"));
            var base = dir.split("/");
            var href = $(this).attr('href');
            var parts = href.split("/");

            // prevent external to be rewritten           
            if ($(this).hasClass("external") || $(this).attr('target') == "_blank") {
                return true;
            }
			
            var pathC = dir != "" ? base.concat(parts) : Array.concat(parts);

            for (var i = 0, len = pathC.length; i < len; ++i) {
                if (pathC[i] === '..') {
                    pathC.splice(i, 1);
                    pathC.splice(i - 1, 1);
                }
            }

            $(this).attr('href', "#" + pathC.join("/"));

            d4h5.ajax.live($(this));

        });

    },

    // set AJAX callback on the specified link obj.
    live: function (obj) {
        obj.live('click', function (e) {

            var state = {};

            // Set the state!
            state[d4h5.hash.id] = $(this).attr('href').replace(/^#/, '');

            $.bbq.pushState(state);

            // And finally, prevent the default link click behavior by returning false.
            return false;
        });
    },

    // load initial content to avoid a blank page
    getInitialContent: function () {
        if ($(d4h5.outputSelector).length == 1 && d4h5.loadInitialContent) {
            var url = "";
            if (window.location.hash !== '') {
                url = window.location.hash.replace(/^#/, '');
                url = url.replace(/^q=/, '');
                this.loadHTML(url);
            } else {
                url = $(d4h5.navigationSelector + ' a:first-child').attr('href').replace(/^#/, '');
                window.location.hash = "q=" + url;
            }
            d4h5.loadInitialContent = false;
        }
    },

    // init ajax plugin
    init: function () {
        this.traverse();
        this.addLoader();
        this.getInitialContent();
    }


};