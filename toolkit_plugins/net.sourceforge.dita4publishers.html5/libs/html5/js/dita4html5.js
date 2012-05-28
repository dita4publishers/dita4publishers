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

	externalContentElement: 'section',

	// is initial content should be loaded after init()
	loadInitialContent: true,

	// store navigation key:href, value:id
    nav: [],

    // hash (for later)
	hash: {
		current: '',
		previous: '',
		id: 'q'
	},

	// used to attribute and id to the navigation tree
	ids: {
		n: 0,
		prefix: 'page-'
	},

	// store current content
	title: '',
	content: '',
	
	transition: {
		opacity: 0.5
	},

	// from jQuery
	// use a modified version of the $.load function
	// for specific purpose
	rscript: '/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi',

	init: function ( options ) {

		$.extend (true, this, options);

 		// register callbacks for page
 		this.ajax.ready(this.ajax.rewriteAttrHref);
		this.ajax.ready(this.ajax.rewriteAttrSrc);
		this.ajax.ready(this.ajax.setTitle);
		this.ajax.ready(this.ajax.setMainContent);
		this.ajax.ready(this.navigation.selectFromHash);
	    
	    // initialize navigation first !important
		this.navigation.init();
		
		// initialize ajax callback
		this.ajax.init ();

		// Bind an event to window.onhashchange that, when the history state changes,
		// iterates over all .bbq widgets, getting their appropriate url from the
		// current state. If that .bbq widget's url has changed, display either our
		// cached content or fetch new content to be displayed.
		$(window).bind( 'hashchange', function(e) {

			state = $.bbq.getState( $(this).attr( 'id' ) ) || '';
      		uri = state[$.dita4html5.hash.id];

			if( uri === '') { return; }

			$.dita4html5.ajax.loadHTML ( uri );
			$.dita4html5.navigation.select ( uri );

		});

		// load initial content
		this.ajax.getInitialContent ( );

		return;

	}

}

);