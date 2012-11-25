/**
 * scale to fit content support for images
 */
(function (d4p) {

  d4p.ui.scale2fit = {
  

    init: function (obj) {
		
		var s = new Object();
		
		// get size of the parent container
		var e = $(d4p.outputSelector);	
		var w = e.innerWidth();
		var l = parseInt(e.css('padding-left'));
        var r = parseInt(e.css('padding-right'));
		w = w - r - l;
		
		// Create new offscreen image 
		var img = new Image();
		img.src = obj.attr("src");

		// Get accurate measurements
		s.ow = img.width;
		s.oh = img.height;
		
		if (s.ow <= w) { return true; }
		
		s.r = w / s.ow;
		
		s.w = Math.round(s.ow * s.r) - 1;
		s.h = Math.round(s.oh * s.r) - 1;
		
		// set attribute
		// changing width of the img directly does not work on webkit
		obj.attr("width", s.w);
		obj.attr("height", s.h);
		
		var div = $("<div />").attr('class', 'scalable');
		var b1 = $("<button />").attr('class', 'scale-button ui-icon ui-icon-arrowthick-2-ne-sw').html("Scale Up");
		b1.data('size', s);
		b1.click(function(){
		    var s = $(this).data('size');
			if($(this).hasClass("scaled")){
			  $(this).removeClass("scaled");
			  $(this).html("Scale Up");
			  $(this).parent().children('img').animate({ 
        		width: s.ow,
        		height: s.oh       
      		}, 500 );
      		  $(this).parent().addClass('is-scaled');
			}else{
			  $(this).addClass("scaled");
			  $(this).html("Scale Down");
			   $(this).parent().children('img').animate({ 
        		width: s.w,
        		height: s.h
       
      		}, 500 );
			}
			 $(this).parent().removeClass('is-scaled');
		});
		
		div.append(b1);
		div.append(obj.clone());
		obj.replaceWith(div);
		
		
		
    } 
    
  };

})(d4p);