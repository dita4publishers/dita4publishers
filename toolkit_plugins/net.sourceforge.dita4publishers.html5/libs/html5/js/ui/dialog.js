(function (d4p) {

 	// Remove links on dialogs
    d4p.ajaxLoader.prototype.removeLinks = function () {
        var uri = d4p.hash.current;
        this.content.find("a").each(function (index) {
            $(this).replaceWith(this.childNodes);
        });
    };
    
    d4p.ui.dialog = {
    
    	ids: 0,
    	
    	
    	
    	done: {},
    
    	init: function (obj) {  	
    	   	
    		var uri = obj.attr('href').substring(1);
    		var id = this.getId();
    		
    		// keep track of every external dialog loaded
        	if (this.done[uri] == undefined) {
            	this.done[uri] = {
                	'id': id,
                	'uri': obj.attr('href').substring(1),
                	'done': false
            	};
        	}
        	
        	if(this.checkDialog (obj, uri)) {
        		this.dialog(obj, uri);
        	}
        	
        	     	
    	
    	},
    	
    	getId: function () {
    		this.ids++;
    		return this.ids;
    	},

		checkDialog: function (obj, uri) {

       	 	// avoid processing url twice
       	 	if (this.done[uri].done == true) {
            	
            	if (uri != "") {
                	// remove href
                	obj.attr('href', "");
                	obj.attr('target', "#dialog-" + this.done[uri].id);

                	// add click handler
                	obj.click(function () {
                   		$($(this).attr('target')).dialog('open');
                	});
            	}
            	return false;
        	} else {
        		return true;
        	}
        },

		dialog: function (obj, uri) {
			// add dialog
			var ajax = new d4p.ajaxLoader();
    		ajax.ready('rewriteAttrHref');
            ajax.ready('rewriteAttrSrc');
    	   	ajax.ready('removeLinks');
    	   	
			var id = this.done[uri].id;
        	var dialog = $("<div />").attr("id", "dialog-" + id);
        	
			$(d4p.ajax.loaderParentElement).append(dialog);
			
        	ajax.setOutputSelector("#dialog-" + id);
        	ajax.load(uri);
        	
        	        	dialog.dialog({
          	  autoOpen: false,
            	minWidth: d4p.ui.dialogMinWidth
        	});
        
        	dialog.dialog('close');

        	// remove href
        	obj.attr('href', "");
        	obj.attr('target', "#dialog-" + id);

        	// add click handler
        	obj.click(function () {
            	$($(this).attr('target')).dialog('open');
        	});

        	this.done[uri].done = true;
		}
    };


})(d4p);