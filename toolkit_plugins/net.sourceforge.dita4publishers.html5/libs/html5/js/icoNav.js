(function (d4p) {
  var inav = new d4p.module('inav', {
    hideAll: function (id) {
      $('.content-chunk').hide();
    },

    hideAllAndShow: function (id) {
      $('.content-chunk').hide(function () {
        $("#" + id).show();
      });
    },

    show: function (id) {
      $("#" + id).show();
    },

    setAria: function () {
      $('.box-ico a').attr('aria-role', 'button');
    },

    loadIniContent: function () {
      var l = d4p.l();

      $("#local-navigation").hide();

      if (l.uri != '') {
        this.show(l.uri);
      } else {
        $("#local-navigation").show();
      }
    },

    hashChanged: function () {

      var l = d4p.l();

      this.hideAll();
      $("#local-navigation").hide();

      if ($('#' + l.uri).length != 0) {
        this.show(l.uri);
      }

      this.changeToolbar(l.uri);

    },

    addToolBar: function () {
      var toolBar = $("<div />").attr('class', 'toolbar');
      $('#ajax-content').prepend(toolBar);
      $('#ajax-content div.toolbar').hide();
    },

    changeToolbar: function (uri) {

      if (d4p.ajax.collection[uri] != undefined) {

        $('#' + d4p.ajax.collection[uri].id).parents().map(function () {
          if ($(this).attr('id') != undefined && $(this).attr('id').indexOf('tab') != -1) {
            var etoolBar = $(this).find("div.toolbar");
            $('#ajax-content div.toolbar').html(etoolBar.html());
            $('#ajax-content div.toolbar').show();

          }
        });


      }
    },

    //    
    init: function () {
      this.hideAll();
      this.setAria();
      this.uriChange('hashChanged');
      this.loadIniContent();
      this.addToolBar();
    }
  });
})(d4p);