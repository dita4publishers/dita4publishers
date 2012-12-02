/**
 * d4p.ajaxLoader object
 *
 * This object is used to perform ajax call on page
 * d4p.ajaxLoader could be instantiated and use differently the contect
 */
(function (window, d4p) {

  /**
   * d4p.ajax constructor
   * multiple instance of this object are possible
   */
  d4p.ajaxLoader = function (opts) {

    this.outputSelector = d4p.outputSelector;
    this.title = '';
    this.content = '';
    this.externalContentElement = d4p.externalContentElement;
    this.setAriaAttr();
    this.timeout = d4p.timeout;
    this.ajaxBefore = [];
    this.ajaxReady = [];
    this.ajaxLive = [];
    this.ajaxFailed = [];
    this.modified = true;

    // store references
    this.collection = [],

    /**
     * ajax mode
     * - replace
     * - appends
     */
    this.mode = 'replace';

    $.extend(true, this, opts);

  };

  // Set outputSelector
  d4p.ajaxLoader.prototype.setOutputSelector = function (selector) {
    this.outputSelector = selector;
  },
  // allow to register callback before is loaded by AJAX
  d4p.ajaxLoader.prototype.before = function (fname) {
    this.ajaxBefore.push(fname);
  };

  // allows to set the timeout
  d4p.ajaxLoader.prototype.setTimeout = function (ms) {
    this.timeout = ms;
  };

  // allow to register callback once the page is loaded by AJAX
  d4p.ajaxLoader.prototype.ready = function (fname) {
    this.ajaxReady.push(fname);
  },
  
  // allow to register callback once the page is live
  d4p.ajaxLoader.prototype.live = function (fname) {
    this.ajaxLive.push(fname);
  },

  // allow to register callback once the page is loaded by AJAX
  d4p.ajaxLoader.prototype.failed = function (fname) {
    this.ajaxFailed.push(fname);
  };

  // add loader (spinner on the page)
  d4p.ajaxLoader.prototype.addLoader = function () {
    var node = $("<div />").attr("id", "d4p-loader");
    $(d4p.loaderParentElement).append(node);
  };

  // set ARIA attributes on the ajax container
  // for accessibility purpose
  d4p.ajaxLoader.prototype.setAriaAttr = function () {
    $(this.outputSelector).attr('role', 'main')
      .attr('aria-atomic', 'true')
      .attr('aria-live', 'polite')
      .attr('aria-relevant', 'all');
  };

  // called before the ajax request is send
  // used to output a 'loader' on the page  
  d4p.ajaxLoader.prototype.contentIsLoading = function () {
    $("#d4p-loader").show();
    $(this.outputSelector).css('opacity', d4p.transition.opacity);
  };

  // called at the end of the ajax call
  d4p.ajaxLoader.prototype.contentIsLoaded = function () {
    $("#d4p-loader").hide();
    $(this.outputSelector).css('opacity', 1);
  };

  // Add entry into the collection
  d4p.ajaxLoader.prototype.collectionSet = function (id, uri, title) {
    if (this.collection[id] == undefined) {
      this.collection[id] = {
        'cache': false,
          'uri': uri,
          'id': uri.replace(/\//g, '__'),
          'title': title
      };
    }
  };

  // Add entry into the collection
  d4p.ajaxLoader.prototype.setCacheStatus = function (id) {
    this.collection[id].cache = true;
  };

  // tell if id is cached
  d4p.ajaxLoader.prototype.isCached = function (id) {
    return this.collection[id] != undefined ? this.collection[id].cache : false;
  };

  // Add entry into the collection
  d4p.ajaxLoader.prototype.inCollection = function (id) {
    return this.collection[id];
  };

  // Set title of the page
  d4p.ajaxLoader.prototype.setTitle = function () {
    $('title').html(this.title);
    // replace title in collection, may be more accurate
    this.collection[this.id]['title'] = this.title;
  },

  // set content of the page
  // this function use the hash value as an ID
  d4p.ajaxLoader.prototype.setMainContent = function () {
    var id = this.id.replace(/\//g, '__');
   var div = $("<div />").attr('id', id).attr('class', 'content-chunk').css('visibility', 'hidden').html(this.content);
    
    if (this.mode == 'append') {
      // append new div, but hide it
      $(this.outputSelector).append();          
      // keep information in memory when link is triggered on page
      this.setCacheStatus(this.id);
    } else {
      $(this.outputSelector).html(div);
    }
    
    // execute ajaxLive
    // perform all tasks which may require
    // content to be inserted in the DOM
    for (i in this.ajaxLive) {
      var fn = this.ajaxLive[i];
      this[fn].call(this, d4p.content);
    }
      
    // show content 
    $('#'+id).css('visibility', 'visible');
  },

  // Rewrite each src in the document
  // because there is no real path with AJAX call
  d4p.ajaxLoader.prototype.rewriteAttrSrc = function () {
    var l = d4p.l();
    this.content.find("*[src]").each(function (index) {
      $(this).attr('src', l.uri.substring(0, l.uri.lastIndexOf("/")) + "/" + $(this).attr('src'));
    });
  },


  // Rewrite each href in the document
  // because real path won't works with AJAX call
  // if there are not from the first level
  d4p.ajaxLoader.prototype.rewriteAttrHref = function () {
    var o = this;
    this.content.find("*[href]").each(function (index) {
      var l = d4p.l();

      var dir = l.uri.substring(0, l.uri.lastIndexOf("/"));
      var base = dir.split("/");
      var arr = [];

      // href
      var href = $(this).attr('href');
      href = href.replace(d4p.ext, '');

      // prevent hash to be rewritten
      if (href.substring(0, 1) == "#") {
        return true;
      }

      var idx = href.indexOf(l.uri);

      // anchors on the same page
      if (idx == 0) {

        $(this).attr('href', href.substring(l.uri.length - 1));

        //  event.preventDefault() is necessary to avoid the AJAC call
        $(this).click(function (event) {
          event.preventDefault();
          d4p.scrollToHash(this.hash);
        });

        return true;
      }

      var parts = href.split("/");

      // prevent external to be rewritten           
      if ($(this).hasClass("external") || $(this).attr('target') == "_blank") {
        return true;
      }


      var pathC = dir != "" ? base.concat(parts) : arr.concat(parts);

      for (var i = 0, len = pathC.length; i < len; ++i) {
        if (pathC[i] === '..') {
          pathC.splice(i, 1);
          pathC.splice(i - 1, 1);
        }
      }

      /**
       * links have not necessarily
       * a link in the navigation.
       * In this case we use the parent page ID
       */
      var l = d4p.l();
      var pId = o.collection[l.uri].id;
      o.collectionSet(pathC.join("/"), pId, ($(this).html()));

      $(this).attr('href', '#' + pathC.join("/"));

      d4p.live($(this));

    });

  };

  /**
   * this is a based from the load function of jquery
   *
   * @param uri: the uri to load
   * @paran hash: the hash to scroll to after the load
   * @todo: see if it is neccessary to implement cache here
   * @todo: implement beforeSend, error callback
   */
  d4p.ajaxLoader.prototype.load = function (uri, hash) {

    this.id = uri.replace(d4p.ext, '');
    this.uri = uri;
    this.hash = hash;

    // todo: implement cache method
    if (this.isCached(this.id)) {
      return true;
    }

    // call ajax before callbacks
    for (i in this.ajaxBefore) {
      var fn = this.ajaxBefore[i];
      this[fn].call(this, uri, hash);
    }

    // set aria status
    $(this.outputSelector).attr('aria-busy', 'true');

    $.ajax({

      type: 'GET',

      context: this,

      cache: true,

      ifModified: this.modified,

      timeout: this.timeout,

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
        if (status === 'error' || status === 'timeout') {

          var msg = status === 'timeout' ? 'Sorry, the content could not be loaded' : 'Sorry, the server does not respond.';
          d4p.msg.alert(msg, 'error');

          this.contentIsLoaded();

          document.location.hash = d4p.hash.previous;

          // ajax failed callback
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

		  // remove scripts from the ajax calls unless they will be loaded
		  var myHTML = $(responseText).not('script');
		  
          var html = $("<div>")
            .attr('id', this.uri + "-temp")
            .append(myHTML);

          this.content = html.find(this.externalContentElement);

          this.title = html.find("title").html();

          // execute ajaxReady
          for (i in this.ajaxReady) {
            var fn = this.ajaxReady[i];
            this[fn].call(this, d4p.content);
          }

          this.setMainContent();

          this.contentIsLoaded();

          $(this.outputSelector).attr('aria-busy', 'false');

          if (hash != undefined) {
            d4p.scrollToHash('#' + hash);
          }

        }
      }
    });
  };

})(window, d4p);