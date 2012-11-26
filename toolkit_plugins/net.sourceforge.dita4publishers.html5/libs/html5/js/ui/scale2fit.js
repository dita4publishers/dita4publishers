/**
 * scale to fit content support for images
 */
(function (d4p) {

  d4p.ui.scale2fit = {
  
  	scale: function (obj, r) {
  	  obj.css("-webkit-transform-origin", "50% 0%" );
  	  obj.css("-moz-transform-origin", "50% 0%" );
  	  obj.css("-ms-transform-origin", "50% 0%" );
  	  obj.css("-o-transform-origin", "50% 0%" );
  	  obj.css("transform-origin", "50% 0%" );
	  
	  obj.css('-webkit-transition', 'all 300ms linear');
      obj.css('-moz-transition', 'all 300ms linear');
      obj.css('-ms-transition', 'all 300ms linear');
      obj.css('-o-transition', 'all 300ms linear');
      obj.css('transition', 'all 300ms linear');
			  
      obj.css('-webkit-transform', 'scale('+ r +')');
      obj.css('-moz-transform', 'scale('+ r +')');
      obj.css('-ms-transform', 'scale('+ r +')');
      obj.css('-o-transformn', 'scale('+ r +')');
      obj.css('transform', 'scale('+ r +')');			  
  	},
  	

    init: function (obj) {

		
		var s = new Object();
		
		// get size of the parent container
		var e = obj.closest(".topic");	
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
		
		//
		var obj2 = obj.clone();
		var self = this;
		
	//	if(Modernizr.csstransforms) { 

    
		
		var div = $("<div />").attr('class', 'scalable');
		var b1 = $("<button />").attr('class', 'scale-button ui-icon ui-icon-arrowthick-2-ne-sw').html("Scale Up");
		
		b1.click(function(){
			obj2.trigger('dblclick');
		});
				
		obj2.data('size', s);
		
		obj2.dblclick(function(){
		
		    var img = $(this);
		    var s = $(this).data('size');
		    var p = $(this).parent();
				    
			if($(this).hasClass("scaled")){
			
			  $(this).removeClass("scaled");
			  self.scale(p, 1);
			  
			}else{                  
			 
      		  $(this).html("Scale Down");
      		  $(this).addClass("scaled");
      		  self.scale(p, 1/  s.r);
			}

		});
		
	//}
		
		div.append(b1);
		div.append(obj2);
		obj.replaceWith(div);
		console.log("image Replaced");
		
		
		
    } 
    
  };

})(d4p);