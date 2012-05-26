$.extend( $.dita4html5, { ajax: {

	ajaxReady: [],

	// allow to register callback once the page is loaded by AJAX
	ready: function (fn) {
		this.ajaxReady.push(fn);
	},

  // parse navigation
  // replace href by # + href
  // add click event and push state in the history
  // using bbq
	traverse: function ( ) {
	  // navigation: prefix all href with #
		$($.dita4html5.navigationSelector + ' a').each(function(index) {

            var id = $(this).attr('id');
			var href = $(this).attr('href');


			// attribute an ID for future reference if not set
			if(id === '' || id == undefined) {
				id = $.dita4html5.ids.prefix + $.dita4html5.ids.n;
				$.dita4html5.ids.n++;
				$(this).attr('id', id);
			}

			// keep information in memory when link is triggered on page
			$.dita4html5.nav[href] = id;

			// replace href
			$(this).attr('href', '#'+href);

			// push the appropriate state onto the history when clicked.
			$.dita4html5.ajax.live ($(this));

		});
		
		$($.dita4html5.navigationSelector).find('li').each(function(index) {
		    if($(this).children('a').length == 0) {
		    console.log($(this));
		        var l = $(this).find('ul li a:first');
		        console.log(l);
		        if(l.length == 1) {
		            $(this).children('span.navtitle').click(function(){
		                console.log("loading first child");
		                $.dita4html5.ajax.loadHTML(l.attr('href').replace( /^#/, '' ));
		            });
		        }
		    }
		});
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
				beforeSend: function () {

				},
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

 						var html = $("<div>").attr('id', $.dita4html5.hash.current).append(responseText.replace($.dita4html5.rscript, ""));

            $.dita4html5.content = html.find($.dita4html5.externalContentElement);
						$.dita4html5.title = html.find("title").html();

						for (fn in $.dita4html5.ajax.ajaxReady) {
							$.dita4html5.ajax.ajaxReady[fn].call($.dita4html5.content);
						}
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
		var uri = $.dita4html5.hash.current;
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

			$.dita4html5.ajax.live ($(this));

		});
		return;
	},

	// set AJAX callback on the specified link obj.
  live: function ( obj ){

    obj.live( 'click', function(e) {

    		var state = {};

    		// Set the state!
      	state[ $.dita4html5.hash.id ] = $(this).attr( 'href' ).replace( /^#/, '' );

      	$.bbq.pushState( state );

      	// And finally, prevent the default link click behavior by returning false.
     		return false;
    	});
  },

	// load initial content to avoid a blank page
	getInitialContent : function () {
		if($($.dita4html5.outputSelector).length == 1 && $.dita4html5.loadInitialContent) {
			this.loadHTML ($($.dita4html5.navigationSelector + ' a:first-child').attr('href').replace( /^#/, '' ));
		}
	},

	// init ajax plugin
	init: function () {
		this.traverse();
	}

	}

	});

})( jQuery );