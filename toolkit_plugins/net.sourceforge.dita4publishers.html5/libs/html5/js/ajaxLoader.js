
(function (window, d4p) {

    // constructor
    d4p.ajaxLoader = function (selector) {
        this.outputSelector = selector;
        this.title = '';
        this.content = '';
        this.externalContentElement = d4p.externalContentElement;
        this.setAriaAttr();
    };

    // Store events to be called before the AJAX request is executed
    d4p.ajaxLoader.prototype.ajaxBefore = [];

    // Store Events to be called once the AJAX succeed
    // used to add function to alter the content
    d4p.ajaxLoader.prototype.ajaxReady = [];

    // Store events to be called if the ajax request failed
    d4p.ajaxLoader.prototype.ajaxFailed = [];

    // allow to register callback before is loaded by AJAX
    d4p.ajaxLoader.prototype.before = function (fname) {
        this.ajaxBefore.push(fname);
    };

    // allow to register callback once the page is loaded by AJAX
    d4p.ajaxLoader.prototype.ready = function (fname) {
        this.ajaxReady.push(fname);
    },

    // allow to register callback once the page is loaded by AJAX
    d4p.ajaxLoader.prototype.failed = function (fname) {
        this.ajaxFailed.push(fname);
    };

    // add loader (spinner on the page)
    d4p.ajaxLoader.prototype.addLoader = function () {
        var node = $("<div />")
            .attr("id", "d4p-loader");
        $(d4p.loaderParentElement).append(node);
    };

    // set ARIA attributes on the ajax container
    // for accessibility purpose
    d4p.ajaxLoader.prototype.setAriaAttr = function () {
        $(this.outputSelector)
            .attr('role', 'main')
            .attr('aria-atomic', 'true')
            .attr('aria-live', 'polite')
            .attr('aria-relevant', 'all');
    };

    // called before the ajax request is send
    // used to output a 'loader' on the page  
    d4p.ajaxLoader.prototype.contentIsLoading = function () {
        $("#d4p-loader")
            .show();
        $(this.outputSelector)
            .css('opacity', d4p.transition.opacity);
    };

    // called at the end of the ajax call
    d4p.ajaxLoader.prototype.contentIsLoaded = function () {
        $("#d4p-loader")
            .hide();
        $(this.outputSelector)
            .css('opacity', 1);
    };

    // Set title of the page
    d4p.ajaxLoader.prototype.setTitle = function () {
        $('title')
            .html(this.title);
    },

    // set content of the page
    d4p.ajaxLoader.prototype.setMainContent = function () {
        $(this.outputSelector)
            .html(this.content);
    },

    // Rewrite each src in the document
    // because there is no real path with AJAX call
    d4p.ajaxLoader.prototype.rewriteAttrSrc = function () {
        var uri = d4p.hash.current;
        this.content.find("*[src]")
            .each(function (index) {
            $(this)
                .attr('src', uri.substring(0, uri.lastIndexOf("/")) + "/" + $(this)
                .attr('src'));
        });
    },

    // Rewrite each href in the document
    // because real path won't works with AJAX call
    // if there are not from the first level
    d4p.ajaxLoader.prototype.rewriteAttrHref = function () {

        this.content.find("*[href]")
            .each(function (index) {
            var uri = d4p.hash.current;
            var dir = uri.substring(0, uri.lastIndexOf("/"));
            var base = dir.split("/");
            var arr = [];

            var href = $(this)
                .attr('href');

            var idx = href.indexOf(uri);

            // anchors on the same page
            if (idx == 0) {

                $(this)
                    .click(function (event) {
                    event.preventDefault();
                    d4p.scrollToHash(this.hash);
                });

                return true;
            }

            var parts = href.split("/");

            // prevent external to be rewritten           
            if ($(this)
                .hasClass("external") || $(this)
                .attr('target') == "_blank") {
                return true;
            }

            var pathC = dir != "" ? base.concat(parts) : arr.concat(parts);

            for (var i = 0, len = pathC.length; i < len; ++i) {
                if (pathC[i] === '..') {
                    pathC.splice(i, 1);
                    pathC.splice(i - 1, 1);
                }
            }

            $(this).attr('href', "#" + pathC.join("/"));

            d4p.live($(this));

        });

    };

    // this is a modified version of the load function in jquery
    // I kept comments for reference
    // @todo: see if it is neccessary to implement cache here
    // @todo: implement beforeSend, error callback
    d4p.ajaxLoader.prototype.load = function (uri, hash) {

        for (fn in this.ajaxBefore) {
            this.ajaxBefore[fn].call(this, d4p.content);
        }

        d4p.hash.current = uri;

        $(this.outputSelector)
            .attr('aria-busy', 'true');

        $.ajax({

            type: 'GET',

            context: this,

            cache: true,

            url: uri,

            dataType: 'html',

            data: {
                ajax: "true"
            },

            beforeSend: function (jqXHR) {
                this.contentIsLoading();
            },

            complete: function (jqXHR, status, responseText) {

                // is status is an error, return an error dialog
                if (status === 'error') {
                    d4p.message.alert('Sorry, the content could not be loaded', 'error');
                    this.contentIsLoaded();

                    document.location.hash = "";

                    for (fn in this.ajaxFailed) {
                        this.ajaxFailed[fn].call(d4p.content);
                    }

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

                    var html = $("<div>")
                        .attr('id', d4p.hash.current)
                        .append(responseText.replace(d4p.rscript, ""));

                    this.content = html.find(this.externalContentElement);

                    this.title = html.find("title")
                        .html();

                    for (i in this.ajaxReady) {
                        var fn = this.ajaxReady[i];
                        this[fn].call(this, d4p.content);
                    }

                    this.setTitle();

                    this.setMainContent();

                    this.contentIsLoaded();

                    $(this.outputSelector)
                        .attr('aria-busy', 'false');

                    d4p.scrollToHash(hash);
                }
            }
        });
    };



})(window, d4p);
