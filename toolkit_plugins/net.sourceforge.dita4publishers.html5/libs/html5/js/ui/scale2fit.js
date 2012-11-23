/**
 * scale to fit content support for images
 */
(function (d4p) {

  d4p.ui.scale2fit = {

    init: function (obj) {

		var e = $(d4p.outputSelector);
		var w = e.innerWidth();
		var l = parseInt(e.css('padding-left'));
        var r = parseInt(e.css('padding-right'));
		w = w - r - l;
		
		// Create new offscreen image to test
		var img = new Image();
		img.src = obj.attr("src");

		// Get accurate measurements from that.
		var ow = img.width;
		var oh = img.height;
		
		if (ow <= w) { return true; }
		
		ratio = w / ow;
		
		obj.css('width', Math.round(ow * ratio) - 1 + "px");
		obj.css('height', Math.round(oh * ratio) - 1  + "px");
    }

  };

})(d4p);