(function( $, undefined ) {


$.dita4html5 = $.dita4html5  || {};

// jQuery.mobile configurable options
$.extend( $.dita4html5, {

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

	// load first page of the documentation if no content on the page
	setInitialContent: true,

	// store navigation key:href, value:id
  navigation: [],

  // hash (for later)
	hash: {
		current: '',
		previous: '',
		id: 'q'
	},

	// used to attribute and id to the navigation tree
	ids: {
		n: 0,
		prefix: 'html5plugin-nav-item-'
	},

	// store current content
	title: '',
	content: '',

	protocols: ['file', 'ftp', 'http', 'https', 'mailto'],


	// from jQuery
	// use a modified version of the $.load function
	// for specific purpose
	rscript: '/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi'

	});

	$.extend( $.dita4html5, {

  // parse navigation
  // replace href by # + href
  // add click event and push state in the history
  // using bbq
	parseNavigation: function ( ) {
	  // navigation: prefix all href with #
		$($.dita4html5.navigationSelector + ' a').each(function(index) {

      var id = $(this).attr('id');

			// attribute an ID for future reference if not set
			if(id === '' || id == undefined) {
				id = $.dita4html5.ids.prefix + $.dita4html5.ids.n;
				$.dita4html5.ids.n++;
				$(this).attr('id', id);
			}

			// replace href
      var href = '#'+$(this).attr('href');
			$(this).attr('href', href);

			// keep information in memory when link is triggered on page
			$.dita4html5.navigation[href] = id;

			// if parent li as ul children add class collapsible
			if($(this).parent().children('ul').length == 1) {
				$(this).parent().addClass('collapsible collapsed');
			}

			// push the appropriate state onto the history when clicked.
			$(this).live( 'click', function(e) {

				var state = {};

				// Set the state!
				state[ $.dita4html5.hash.id ] = $(this).attr( 'href' ).replace( /^#/, '' );
				$.bbq.pushState( state );

				$.dita4html5.setNavItemActive($(this).attr('id'));
				// And finally, prevent the default link click behavior by returning false.
				return false;
			});

		});
	},

	// activate navigation item
	// add/remove required navigation item
	setNavItemActive: function (id) {

		// remove previous class
		$($.dita4html5.navigationSelector + ' li').removeClass('selected');
		$($.dita4html5.navigationSelector + ' li').removeClass('active').addClass('collapsed');

		// add selected class on the li parent element
		$('#'+id).parentsUntil($.dita4html5.navigationSelector).addClass('active').removeClass('collapsed');;

		// set all the parent trail active
		$('#'+id).parent('li').addClass('selected');

	},

	// this is a modified version of the load function in jquery
	// I kept comments for reference
	// @todo: see if it is neccessary to implement cache here
	// @todo: implement beforeSend, error callback
	loadHTML: function ( uri ) {
	 	$.dita4html5.hash.current = uri;
		$.ajax( {
				type: 'GET',
				url: uri,
				dataType: 'html',
				complete: function( jqXHR, status, responseText ) {
          // Store the response as specified by the jqXHR object
          responseText = jqXHR.responseText;

          // If successful, inject the HTML into all the matched elements
          if ( jqXHR.isResolved() ) {
            // #4825: Get the actual response in case
            // a dataFilter is present in ajaxSettings
            jqXHR.done(function( r ) {
              responseText = r;
            });

 						var html = $("<div>").append(responseText.replace($.dita4html5.rscript, ""));

            $.dita4html5.content = html.find("section");
						$.dita4html5.title = html.find("title").html();
						$.dita4html5.rewriteAttrHref();
						$.dita4html5.rewriteAttrSrc();
						$.dita4html5.setTitle();
						$.dita4html5.setMainContent();

					}
				}
			});

	},

	setTitle: function() {
		$('title').html($.dita4html5.title);
	},

	setMainContent: function() {
		 $($.dita4html5.outputSelector).html($.dita4html5.content);
	},

	// Rewrite each src in the document
	// because there is no real path with AJAX call
	rewriteAttrSrc: function() {
		$.dita4html5.content.find("*[src]").each(function(index) {
  		$(this).attr('src',  uri.substring(0,  uri.lastIndexOf("/")) + "/" + $(this).attr('src'));
   });
	},

	// Rewrite each href in the document
	// because there is no real path with AJAX call
	//
	rewriteAttrHref: function ( ) {
		$.dita4html5.content.find("*[href]").each(function(index) {
			var uri = $.dita4html5.hash.current;
    	var dir = uri.substring(0,  uri.lastIndexOf("/"));
    	var base = dir.split("/");
    	var href = $(this).attr('href');
    	var parts = href.split("/");

    	// prevent external and absolute to be rewrited
    	if ($.inArray (parts[0], $.dita4html5.protocols) !=  -1 ) {
      	return true;
    	}

    	var pathC = base.concat(parts);

    	for ( var i=0, len=pathC.length; i<len; ++i ){
 				if (pathC[i] === '..') {
 					pathC.splice(i, 1);
        	pathC.splice(i - 1, 1);
    		}
			}

    	$(this).attr('href', "#" + pathC.join("/"));

    	$(this).live( 'click', function(e) {

    		var state = {};

    		// Set the state!
      	state[ $.dita4html5.hash.id ] = $(this).attr( 'href' ).replace( /^#/, '' );

      	$.bbq.pushState( state );
     		$.dita4html5.setNavItemActive($.dita4html5.navigation[$(this).attr('href')]);

      	// And finally, prevent the default link click behavior by returning false.
     		return false;
    	});

		});
	},

	// load initial content to avoid a blank page
	getInitialContent : function () {
		if($($.dita4html5.outputSelector).length == 1 && $.dita4html5.setInitialContent) {
			this.loadHTML ($($.dita4html5.navigationSelector + ' a:first-child').attr('href').replace( /^#/, '' ));
			$($.dita4html5.navigationSelector + " li:first-child").addClass("active selected").removeClass('collapsed');
		}

	},

	init: function ( options ) {

 		this.parseNavigation ();

		// Bind an event to window.onhashchange that, when the history state changes,
		// iterates over all .bbq widgets, getting their appropriate url from the
		// current state. If that .bbq widget's url has changed, display either our
		// cached content or fetch new content to be displayed.
		$(window).bind( 'hashchange', function(e) {

			state = $.bbq.getState( $(this).attr( 'id' ) ) || '';
      uri = state[$.dita4html5.hash.id];

			if( uri === '') { return; }

			$.dita4html5.loadHTML ( uri );

		});

		$.dita4html5.getInitialContent ( );

		return;

	}

	});

})( jQuery );