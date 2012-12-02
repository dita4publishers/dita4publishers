/**
 * Message module
 * small module to send message to the user
 * Will have another implementation with jquwery ui dialog within the next months
 */
(function (d4p) {

  // use ui-dialog instead ?

  var message = new d4p.module('msg', {
    // id of the div element to be created
    id: 'd4p-message',

    timeout: 3000,

    // message type
    create: function () {
      var msgBox = $("<div />")
        .attr('id', this.id)
        .attr('role', 'alertdialog')
        .attr('aria-hidden', 'true')
        .attr('aria-label', 'Message')
        .addClass('rounded')
        .hide();
      var div = msgBox.append($("<div />"));
      $('body')
        .append(msgBox);
    },

    // create message container    
    init: function () {
      this.create();

      $(document).mouseup(function (e) {
        var container = $(this.id);

        if (container.has(e.target).length === 0) {
          container.hide();
        }
      });
    },

    show: function () {
      $("#" + this.id)
        .show()
        .attr('aria-hidden', 'false')
        .delay(this.timeout)
        .fadeOut()
        .attr('aria-hidden', 'true');
    },

    alert: function (msg, type) {
      type = type == undefined ? '' : type;
      var p = $("<p />")
        .addClass(type)
        .text(msg);
      $("#" + this.id + " > div")
        .html(p);
      this.show();
    }
  });

})(d4p);