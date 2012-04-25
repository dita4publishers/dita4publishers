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
    $(this).live( 'click', function(e){
      var state = {};

      // Get the id of this .bbq widget.
      id = $(this).attr( 'id' );

      // Set the state!
      state[ id ] = href;
      $('body').bbq.pushState( state );

      // And finally, prevent the default link click behavior by returning false.
      return false;
    });

  });

  // Bind an event to window.onhashchange that, when the history state changes,
  // iterates over all .bbq widgets, getting their appropriate url from the
  // current state. If that .bbq widget's url has changed, display either our
  // cached content or fetch new content to be displayed.
  $(window).bind( 'hashchange', function(e) {

		$('#main-content').load(location.hash.replace( /^#/, '' ));

  })

  // Since the event is only triggered when the hash changes, we need to trigger
  // the event now, to handle the hash the page may have loaded with.
  $(window).trigger( 'hashchange' );



});