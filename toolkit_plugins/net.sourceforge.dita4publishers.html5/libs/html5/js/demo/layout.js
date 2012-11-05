/**
 * d4p.ajaxLoader.prototype.addButton
 * 
 * This is an example of how to add javascript on specific element on page.
 * There is a need to implement a machanism to add such javascript on page
 */
(function (d4p) {

  d4p.ajaxLoader.prototype.addButtons = function () {

    var o = this;

    var buttonNavigation = $("<button/>").html("Place navigation on the right").click(function () {
      if ($('body').hasClass('navigation-right')) {
        $('body').removeClass('navigation-right');
        $('body').addClass('navigation-default', 'slow');
        $(this).html('Place navigation on the right');
      } else {
        $('body').addClass('navigation-right', 'slow');
        $('body').removeClass('navigation-default');
        $(this).html('Place navigation on the left (default)');
      }
    });


    var buttonCentered = $("<button/>").html("Align page on the left").click(function () {
      $('body').toggleClass('centered');
      $(this).html($(this).html() == "Align page on the left" ? "Center page" : "Align page on the left");
    });

    var buttonPaged = $("<button/>").html("Remove paged class").click(function () {
      $('body').toggleClass('paged');
      $(this).html($(this).html() == "Remove paged class" ? "Add paged class" : "Remove paged class");

    });

    var p = this.content.find('#concept_nyf_phj_hg__layout-switcher');
    p.append($("<h2/>").html("Layout"));
    p.append(buttonCentered);
    p.append($("<h2/>").html("Paged or not paged"));
    p.append(buttonPaged);
    p.append($("<h2/>").html("Navigation"));
    p.append(buttonNavigation);

  };


  var layout = new d4p.module('layout', {

    // create message container    
    init: function () {
      d4p.ajax.ready('addButtons');
    }
  });

})(d4p);