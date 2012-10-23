(function (window, d4p) {

  /**
   * This is the core of the main ajax navigation
   */
  var ajaxnav = new d4p.module('ajaxnav', {

    traverse: function () {
      // navigation: prefix all href with #
      $(d4p.navigationSelector + ' a').each(function (index) {

        var href = $(this).attr('href');

        // ids.linkID;
        // ids.hrefID;
        var ids = d4p.getIds($(this));

        // attribute an ID for future reference if not set
        $(this).attr('id', ids.linkID);

        // do not rewrite anchors and absolute uri
        // @todo check for absolute uri
        if (href.substring(0, 1) != '#') {

          // add it in the collection
          d4p.ajax.collectionSet(ids.hrefID, ids.linkID);
          $(this).attr('href', '#' + ids.hrefID);

        }

        // push the appropriate state onto the history when clicked.
        d4p.live($(this));

      });

      /** span.navtitle **/
      $(d4p.navigationSelector).find('li').each(function (index) {
        if ($(this).children('a').length === 0) {
          var l = $(this).find('ul li a:first');
          if (l.length == 1) {
            $(this).children('span.navtitle').click(function () {
              d4p.ajax.load(l.attr('href').replace(/^#/, ''));
            });
          }
        }
      });
    },

    load: function () {

      var l = d4p.l();
      if (d4p.ajax.inCollection(l.uri) != undefined && !d4p.ajax.inCollection(l.uri).cached) {
        d4p.ajax.load(l.uri + d4p.ext, l.hash);
      }
    },

    init: function () {

      d4p.ajax = new d4p.ajaxLoader();
      d4p.ajax.addLoader();
      d4p.ajax.ready('rewriteAttrHref');
      d4p.ajax.ready('rewriteAttrSrc');
      d4p.ajax.ready('setTitle');

      this.traverse();
      this.uriChange('load');
      this.load();
    }
  });

})(window, d4p);