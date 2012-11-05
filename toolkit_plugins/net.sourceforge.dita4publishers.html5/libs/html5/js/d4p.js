/**
 * d4p object
 */ 
(function (window) {
  var d4p = {

    version: '0.3a',

    _init: false,

    // is initial content should be loaded after init()
    loadInitialContent: true,

    // hash
    hash: {
      current: '',
      previous: ''
    },

    ext: '.html',

    timeout: 3000,

    // main output selectors
    outputSelector: "#d4h5-main-content",

    // local navigation selector
    navigationSelector: "#local-navigation",

    // external content element
    externalContentElement: "section",

    //
    loaderParentElement: "body",

    // used to attribute and id to the navigation tree
    // if none are specified, this should make jQuery selection faster
    ids: {
      n: 0,
      prefix: 'd4p-page',
      prefixLink: 'd4p-link'
    },

    // default values for transitions
    transition: {
      speed: 'slow',
      opacity: 0.5
    },

    relativePath: '',

    // registered modules
    mod: [],

    // uri change functions
    _uriChange: [],

    // scrollElement
    scrollElem: {},

    //scroll duration in ms
    scrollDuration: 400,

    // index filename
    indexFilename: "index.html",

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

    // l current hash and return the uri + the hash
    l: function () {
      var r = document.location.hash.substring(1);
      if (r != '') {
        var s = r.split('#');
        return {
          'uri': s[0],
            'hash': s[1] != undefined ? s[1] : '',
            'id': s[0].replace(/\//g, '__')
        };
      } else {
        return {
          'uri': '',
            'hash': '',
            'id': ''
        };
      }
    },

    show: function (id) {
      $("#" + id).show();
    },

    // find if an element is scrollable
    // from http://css-tricks.com/snippets/jquery/smooth-scrolling/
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

    // scroll to hash
    scrollToHash: function (hash) {
      if (hash != "" && hash != undefined && hash != null && hash != '#') {
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

    // extend the d4p objects
    setProps: function (options) {
      // extend options
      $.extend(true, this, options);
    },

    // check if a jQuery object has an id or create one
    getIds: function (obj) {
      var id = obj.attr('id');
      var href = obj.attr('href');
      var hrefID = href.substring(0, href.length - d4p.ext.length);
      var attrs = {};

      // create an ID for future reference if not set
      if (id === '' || id == undefined) {
        id = d4p.ids.prefixLink + d4p.ids.n;
        d4p.ids.n++;
      };

      return {
        linkID: id,
        hrefID: hrefID
      };

    },

    // set AJAX callback on the specified link obj.
    live: function (obj) {

      /*  obj.live('click', function (e) {
				
				e.preventDefault();
				console.log("uri %s", obj.attr('href'));
				
               // And finally, prevent the default link click behavior by returning false.
               return false;
           });*/
    },

    // load initial content to avoid a blank page
    getInitialContent: function () {
      if ($(d4p.outputSelector).length == 1 && d4p.loadInitialContent) {
        var l = d4p.l();
        if (l.uri !== '') {
          d4p.uriChanged(l.uri, l.hash);
        } else {
          var el = $(d4p.navigationSelector + ' a:first-child');
          if (el.attr('href') == undefined) {
            return false;
          }
          url = $(d4p.navigationSelector + ' a:first-child')
            .attr('href')
            .replace(/^#/, '');
          document.location.hash = url;
        }
        d4p.loadInitialContent = false;
      }
    },

    // execute callbacks function on uri changed
    uriChanged: function (uri, hash) {
      var l = d4p.l();
      for (i in d4p._uriChange) {
        var fn = d4p._uriChange[i];
        d4p[fn.name][fn.fn].call(d4p[fn.name], l.uri, l.hash);
      }
      d4p.hash.previous = hash;
    },

    // init d4p objects and all modules
    init: function (options) {

      //prevent double initialization
      if (this._init) {
        return false;
      }

      // extend options
      $.extend(true, this, options);

      // redirect if not on the index page
      if (d4p.relativePath != "") {
        var redirect = d4p.resolveRoot();
        document.location = redirect;
        return true;
      }

      //
      this.scrollElem = this.scrollableElement('html', 'body');

      // initialize
      for (i in this.mod) {
        var fn = this.mod[i];
        this[fn].init.call(this[fn]);
      }


      var event = 'hashchange';
      //var event = 'hashchange';
      // Bind an event to window.onhashchange that, when the history state changes
      // will implament onpopsate event and history if the feature is implemented
      // but now, few browsers support it
      // detect it with Modernizr.history 
      $(window).bind(event, function (e) {
        d4p.uriChanged();
      });

      this.getInitialContent();

      this._init = true;

      return true;

    },

    filename: function (uri) {
      return uri.substring(uri.lastIndexOf('/') + 1);
    },

    basename: function (uri) {
      return uri.substring(0, uri.length - this.filename(uri).length);
    },

    resolveRoot: function () {

      var url = document.location.toString();
      var basename = d4p.basename(url);
      var s = basename.split("/");
      var c = d4p.relativePath.match(/\.\./g);
      var a = s.splice(0, s.length - 1 - c.length);
      var furl = a.join("/");
      var filename = url.substring(furl.length + 1).replace(d4p.ext, '');
      return location.protocol == 'file:' ? a.join("/") + "/" + d4p.indexFilename + "#" + filename : a.join("/") + "/" + "#" + filename;

    }

  };


  window.d4p = d4p;

})(window);