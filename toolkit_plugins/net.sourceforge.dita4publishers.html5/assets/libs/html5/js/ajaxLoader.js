(function( $, window, document, undefined ) {

// jQuery.mobile configurable options
$.html5plugin = $.extend( {}, {

  // toc url - to be implemented
  // the idea is to have the reference to the toc on every page.
  // if someone come on a specific page trough a search engine
  // the code will load the toc parent and render the page properly.
  toc: '',

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
	rscript: '/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi',

  // parse navigation
  // replace href by # + href
  // add click event and push state in the history
  // using bbq
	parseNavigation: function ( ) {
	  // navigation: prefix all href with #
		$('#left-navigation a').each(function(index) {

      var id = $(this).attr('id');

			// attribute an ID for future reference if not set
			if(id === '' || id == undefined) {
				id = $.html5plugin.ids.prefix + $.html5plugin.ids.n;
				$.html5plugin.ids.n++;
				$(this).attr('id', id);
			}

			// replace href
      var href = '#'+$(this).attr('href');
			$(this).attr('href', href);

			// keep information in memory when link is triggered on page
			$.html5plugin.navigation[href] = id;

			// push the appropriate state onto the history when clicked.
			$(this).live( 'click', function(e) {

				var state = {};

				// Set the state!
				state[ $.html5plugin.hash.id ] = $(this).attr( 'href' ).replace( /^#/, '' );
				$.bbq.pushState( state );

				$.html5plugin.setNavItemActive($(this).attr('id'));
				// And finally, prevent the default link click behavior by returning false.
				return false;
			});

		});
	},

	// activate navigation item
	// add/remove required navigation item
	setNavItemActive: function (id) {
		console.log(id);
		// remove previous class
		$('#left-navigation li').removeClass('selected');
		$('#left-navigation li').removeClass('active');

		// add selected class on the li parent element
		$('#'+id).parents().addClass('selected');

		// set all the parent trail active
		$('#'+id).parent('li').addClass('active');
	},

	// this is a modified version of the load function in jquery
	// I kept comments for reference
	// @todo: see if it is neccessary to implement cache here
	// @todo: implement beforeSend, error callback
	loadHTML: function ( uri ) {
	 	$.html5plugin.hash.current = uri;
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

 						var html = $("<div>").append(responseText.replace($.html5plugin.rscript, ""));

            $.html5plugin.content = html.find("section");
						$.html5plugin.title = html.find("title").html();
						$.html5plugin.rewriteAttrHref();
						$.html5plugin.rewriteAttrSrc();
						$.html5plugin.setTitle();
						$.html5plugin.setMainContent();

					}
				}
			});

	},

	setTitle: function() {
		$('title').html($.html5plugin.title);
	},

	setMainContent: function() {
		 $("#main-content").html($.html5plugin.content);
	},

	// Rewrite each src in the document
	// because there is no real path with AJAX call
	rewriteAttrSrc: function() {
		$.html5plugin.content.find("*[src]").each(function(index) {
  		$(this).attr('src',  uri.substring(0,  uri.lastIndexOf("/")) + "/" + $(this).attr('src'));
   });
	},

	// Rewrite each href in the document
	// because there is no real path with AJAX call
	rewriteAttrHref: function ( ) {
		$.html5plugin.content.find("*[href]").each(function(index) {
			var uri = $.html5plugin.hash.current;
    	var dir = uri.substring(0,  uri.lastIndexOf("/"));
    	var base = dir.split("/");
    	var parts = $(this).attr('href').split("/");

    	// prevent external to be rewrited
    	if ($.inArray (parts[0], $.html5plugin.protocols) !=  -1) {
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
      	state[ $.html5plugin.hash.id ] = $(this).attr( 'href' ).replace( /^#/, '' );

      	$.bbq.pushState( state );

      	$.html5plugin.setNavItemActive($.html5plugin.navigation[$(this).attr('href')]);

      	// And finally, prevent the default link click behavior by returning false.
     		return false;
    	});

		});
	},

	// load initial content to avoid a blank page
	setInitialContent : function () {
		if($("#main-content").length == 1 ) {
			this.loadHTML ($("#left-navigation a:first-child").attr('href').replace( /^#/, '' ));
			$("#left-navigation li:first-child").addClass("active selected");
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
      uri = state[$.html5plugin.hash.id];

			if( uri === '') { return; }

			$.html5plugin.loadHTML ( uri );

		});

		$.html5plugin.setInitialContent ( );

		return;

	}

	});

})( jQuery, window, document );