(function (window) {

    var message = {
        // id of the div element to be created
        id: 'd4h5-message',

        timeout: 3000,

        // message type
        create: function () {
            var msgBox = $("<div />").attr('id', this.id).addClass('rounded').hide();
            var div = msgBox.append($("<div />"));
            $('body').append(msgBox);
        },

        // create message container    
        init: function () {
            d4h5.message.create();
        },

        show: function () {
            $("#" + this.id).show().delay(this.timeout).fadeOut();
        },

        alert: function (msg, type) {
            type = type == undefined ? '' : type;
            var p = $("<p />").addClass(type).text(msg);
            $("#" + this.id + " > div").html(p);
            this.show();
        }
    };

    window.d4h5.register('message');
    window.d4h5.message = message;

})(window);