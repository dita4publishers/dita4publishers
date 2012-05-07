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


		traverse: function () {
			// navigation: prefix all href with #
			$($.dita4html5.navigationSelector + ' a').each(function(index) {

				//if parent li has ul children add class collapsible
				if($(this).parent().children('ul').length == 1) {

					// create span
					var span = $("<span/>");
					span.addClass("ico");

					// add click handler to span
					span.click(function(){

						if($.dita4html5.navigation.autoCollapse) {
							$($.dita4html5.navigationSelector + ' li.active').removeClass('active').addClass('collapsed');
						}

						$(this).parent('li').toggleClass('active', '');
						$(this).parent('li').toggleClass('collapsed', '');

					});

					// add class
					$(this).parent().prepend(span).addClass('collapsible collapsed');

					// click handler
					$(this).click(function(){
						// remove previous class
						$($.dita4html5.navigationSelector + ' li').removeClass('selected');
						$($.dita4html5.navigationSelector + ' li').removeClass('active').addClass('collapsed');

						// add selected class on the li parent element
						$(this).parentsUntil($.dita4html5.navigationSelector).addClass('active').removeClass('collapsed');

						// set all the parent trail active
						$(this).parent('li').addClass('selected');

					});
				}
			});
		}
	}
});