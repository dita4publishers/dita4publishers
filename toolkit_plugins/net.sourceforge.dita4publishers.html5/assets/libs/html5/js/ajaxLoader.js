
(function( $, window, document, undefined ) {

// jQuery.mobile configurable options
	$.html5plugin = $.extend( {}, {

  	// toc url
  	toc: '',

  	// hash
		hash: {
		current: '',
		previous: '',
		id: 'q'
	},

	// from jQuery
	// use a modified version of the $.load function
	// for specific purpose
	rscript: '/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi',

	init: function ( options ) {
		console.log('init');
		// navigation: prefix all href with #
		$('#left-navigation a').each(function(index) {

			$(this).attr('href', '#'+$(this).attr('href'));


			// push the appropriate state onto the history when clicked.
			$(this).live( 'click', function(e) {
					console.log('live');
				var state = {};

				// Set the state!
				state[ $.html5plugin.hash.id ] = $(this).attr( 'href' ).replace( /^#/, '' );

				$.bbq.pushState( state );

				$('#left-navigation a').removeClass('active');
				$(this).addClass('active');

				// And finally, prevent the default link click behavior by returning false.
				return false;
			});

		});

		// Bind an event to window.onhashchange that, when the history state changes,
		// iterates over all .bbq widgets, getting their appropriate url from the
		// current state. If that .bbq widget's url has changed, display either our
		// cached content or fetch new content to be displayed.
		$(window).bind( 'hashchange', function(e) {
      console.log('hashchange');
			state = $.bbq.getState( $(this).attr( 'id' ) ) || '';
      uri = state[$.html5plugin.hash.id];

			console.log(uri);

			if( uri === '') { return; }

			// this is a modified version of the load function in jquery
			// I kept comments for reference
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


            var content = html.find("section");

            // set page title
            var title = html.find("title");
            $('title').html(title.html());

            content.find("a").each(function(index) {
            	//var uriInfo = parseURL($(this).attr('href'));
            	// @todo leave pdf and external intact
            	var path = uri.substring(0,  uri.lastIndexOf("/"));
              $(this).attr('href', "#" + path + "/" + $(this).attr('href'));

            	$(this).live( 'click', function(e) {
     						var state = {};

     						// Set the state!
      					state[ $.html5plugin.hash.id ] = $(this).attr( 'href' ).replace( /^#/, '' );

      					$.bbq.pushState( state );

      					// And finally, prevent the default link click behavior by returning false.
     				 	return false;
    					});
						});

						content.find("img").each(function(index) {
              $(this).attr('src',  uri.substring(0,  uri.lastIndexOf("/")) + "/" + $(this).attr('src'));
            });

            $("#main-content").html(content);

					}
				}
			});
		});

		return;

	}

	});

})( jQuery, window, document );

// initialize
$(function() {
	$.html5plugin.init();
	//$(window).trigger( 'hashchange' );
});
