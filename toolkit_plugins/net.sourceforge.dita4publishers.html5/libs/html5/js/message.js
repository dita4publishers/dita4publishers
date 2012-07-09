(function (d4h5) {

    // use ui-dialog instead ?

    var message = {
        // id of the div element to be created
        id: 'd4h5-message',

        timeout: 3000,

        // message type
        create: function () {
            var msgBox = $("<div />").attr('id', this.id).attr('role', 'alertdialog').attr('aria-hidden', 'true').attr('aria-label', 'Message').addClass('rounded').hide();
            var div = msgBox.append($("<div />"));
            $('body').append(msgBox);
        },

        // create message container    
        init: function () {
            d4h5.message.create();
        },

        show: function () {
            $("#" + this.id).show().attr('aria-hidden', 'false').delay(this.timeout).fadeOut().attr('aria-hidden', 'true');
        },

        alert: function (msg, type) {
            type = type == undefined ? '' : type;
            var p = $("<p />").addClass(type).text(msg);
            $("#" + this.id + " > div").html(p);
            this.show();
        }
    };

    d4h5.register('message');
    d4h5.message = message;

})(d4h5);