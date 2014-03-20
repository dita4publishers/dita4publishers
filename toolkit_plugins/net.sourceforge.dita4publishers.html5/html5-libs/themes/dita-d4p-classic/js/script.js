$(function() {

  $('.toggle-topbar a').on('click', function(){
   var $lefty = $('#local-navigation');
    $lefty.animate({
      left: parseInt($lefty.css('left'),10) < 0 ? 0 : '-'+ $lefty.outerWidth()
    });
  });

  $(document).mouseup(function (e)
  {
    var container = $('#local-navigation');

    if (!container.is(e.target) // if the target of the click isn't the container...
        && container.has(e.target).length === 0) // ... nor a descendant of the container
    {
      container.animate({
        left: parseInt(container.css('left'),10) < 0 ? 0 : '-'+ container.outerWidth()
      });

    }
  });

});
