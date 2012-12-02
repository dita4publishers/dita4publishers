/**
 * d4p.ui.cycle
 * 
 * Interface with jQuery Cycle Plugin (core engine)
 * @ref http://jquery.malsup.com/cycle/
 */
(function (d4p) {

  d4p.ui.cycle = {

    init: function (obj) {

      obj.cycle({
        fx: 'fade',
        speed: 500,
        timeout: 2000,
      });
    }

  };

})(d4p);