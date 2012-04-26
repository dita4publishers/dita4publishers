$(function() {
  var idc = 0;

  // add a hash element to all href
  $('#left-navigation a').each(function(index) {

    var href = $(this).attr('href');
    $(this).attr('href', '#'+href);

    if ($(this).attr('id') == "" || $(this).attr('id') == undefined) {
      $(this).attr('id', "link"+idc);
      idc++;
    }


    // For all links push the appropriate state onto the history when clicked.
    $(this).live( 'click', function(e) {
      var state = {};

      // Get the id of this .bbq widget.
      id = 'nav';
      console.log($(this).attr( 'href' ));
      // Set the state!
      state[ id ] = $(this).attr( 'href' ).replace( /^#/, '' );
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

    htmlurl = $.bbq.getState( $(this).attr( 'id' ) ) || '';
		rscript = '/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi';

    if( htmlurl != '') {

     $.ajax( {
				type: 'GET',
				url: htmlurl,
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


 						var html = $("<div>").append(responseText.replace(rscript, ""));

            var content = html.find("section");
            var title = html.find("title");

            $('title').html(title.html());

            content.find("a").each(function(index) {
            	//var uriInfo = parseURL($(this).attr('href'));
            	// @todo leave pdf and external intact
            	var path = htmlurl.substring(0,  htmlurl.lastIndexOf("/"));
              $(this).attr('href', "#" + path + "/" + $(this).attr('href'));

            	$(this).live( 'click', function(e) {
     					var state = {};

      				// Get the id of this .bbq widget.
      				id = 'nav';

     					// Set the state!
      				state[ id ] = $(this).attr( 'href' ).replace( /^#/, '' );
      				$.bbq.pushState( state );

      				// And finally, prevent the default link click behavior by returning false.
     				 return false;
    				});
				});


    				 content.find("img").each(function(index) {
            	//var uriInfo = parseURL($(this).attr('href'));
            	// @todo leave pdf and external intact
            	var path = htmlurl.substring(0,  htmlurl.lastIndexOf("/")) + "/" +   $(this).attr('src');
              $(this).attr('src',  path);





            });

             $("#main-content").html(content);
          }

        }
      });

    }

  })


  // Since the event is only triggered when the hash changes, we need to trigger
  // the event now, to handle the hash the page may have loaded with.
  $(window).trigger( 'hashchange' );

});