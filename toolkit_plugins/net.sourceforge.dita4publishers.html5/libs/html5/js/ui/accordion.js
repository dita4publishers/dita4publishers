(function (d4p) {

  d4p.ui.accordion = {

    init: function (obj) {
      var cs = '';
      if (obj.hasClass('concept')) {
        cs = '> div.topic > h2';
      } else {
        cs = '> div.section > h2';
      }
      obj.accordion({
        header: cs,
        autoHeight: false, // required for Safari
        active: false,
        collapsible: true
      });
    }
  };

})(d4p);