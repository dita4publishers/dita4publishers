$.extend( $.dita4html5, {
	navigation: {
		maxLevel: 3,
		maxLevelTransition: 'slideUp',
		autoCollapse: false,

		init: function(){
			this.traverse();
		},

		select: function ( uri ) {
			var id = $.dita4html5.nav[uri];
			$($.dita4html5.navigationSelector + ' li').removeClass('selected');
			$('#'+id).parent('li').addClass('selected');
		},

        selectFromHash: function () {
            $.dita4html5.navigation.select($.dita4html5.hash.current.replace( /^#/, '' ));
        },

		traverse: function () {
			// navigation: prefix all href with #
			$($.dita4html5.navigationSelector + ' li').each(function(index) {

              	//if li has ul children add class collapsible
				if($(this).children('ul').length == 1) {

					// create span
					var span = $("<span/>");
					span.addClass("ico");

					// li click handler
					$(this).click(function(){

						$(this).toggleClass('active', '');
						$(this).toggleClass('collapsed', '');
						
					});
					
					$(this).children('a').click(function(){

						$(this).parent().toggleClass('active', '');
						$(this).parent().toggleClass('collapsed', '');				

					});
					

					// add class
					$(this).prepend(span).addClass('collapsible collapsed');


					// link click handler
					$(this).children('a:first-child').click(function(){
						// remove previous class
						$($.dita4html5.navigationSelector + ' li').removeClass('selected');
						$($.dita4html5.navigationSelector + ' li').removeClass('active').addClass('collapsed');

						// add selected class on the li parent element
						$(this).parentsUntil($.dita4html5.navigationSelector).addClass('active').removeClass('collapsed');

						// set all the parent trail active
						$(this).parent('li').addClass('selected');

					});
				} else {
				    $(this).addClass('no-child');
				}
			});
		}
	}
});