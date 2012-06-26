window.dita4html5.message = {
	// id of the div element to be created
    id: 'dita4html5-message',
    
    timeout: 3000,
    
    // message type
    create: function() {
    	var msgBox = $("<div />").attr('id', this.id).addClass('rounded').hide();
    	var div = msgBox.append($("<div />"));
    	$('body').append(msgBox);
    },
    
    // create message container    
    init: function() {
    	this.create();
    },
    
    show: function() {
    	$("#"+this.id).show().delay(this.timeout).fadeOut();
    },
    
    alert: function (msg, type) {    
        type = type == undefined ? '' : type;    	
    	var p = $("<p />").addClass(type).text(msg);    	
        $("#"+this.id+" > div").html(p);
        this.show();  
    }    
    
};