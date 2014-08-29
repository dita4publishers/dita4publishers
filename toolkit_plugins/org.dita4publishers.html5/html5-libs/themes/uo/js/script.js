/**
 * 
 */
(function (d4p) {

    var inav = new d4p.module('inav', {
   
    hideAll: function (id) {
      $('.content-chunk').hide();
    },
        
    show: function (id) {
      $("#"+id).show();
    },
    
    setAria: function () {
      $('.box-ico a').attr('aria-role', 'button');
    },
    
    rewriteLangAttrHref : function (response) {
      var lang = $('html').attr('lang') == 'en' ? 'fr' : 'en',
      alternatelangdirectory = $("meta[name='alternate-lang-directory']").attr('content');
      $("#ch-lang-url").attr('href', "/"+lang+"/"+alternatelangdirectory+document.location.hash);
      },
    
    load: function () {
      var o = this,
      l = d4p.l(),
      ret = d4p.ajax.inCollection(l.uri),
      id = '';
      
      this.hideAll();
                  
      if(ret)  {
        $("#home").addClass('state-active');
        id = d4p.ajax.collection[l.uri].id;
        this.show(id);
      } else if(l.uri != '' && !ret)  {  
        $("#home").addClass('state-active');
        this.show(l.uri.substring(1));
      } else if (l.uri == '') {
        $("#home").removeClass('state-active');
      }
      
      return true;
      
    },
    goToHash: function () {
      var l = d4p.l(), 
      idx=0;
      
      $('#'+l.id).find(".ui-accordion-header").each(function(index, value){
        idx = $(this).parent().attr('id') == l.hash ? index : idx;
      });
      
      $(".d4p-ui-accordion").accordion( "option", "active", idx );
      $('#content-container-anchor').attr('tabindex', -1).focus();  

    },
    
        //    
        init: function () {
            d4p.ajax.mode = 'append';
             $('#ajax-content').prepend($('<a />').attr('id', 'ajax-content-anchor').attr('class', 'named-anchor').attr('name', 'ajax-content-anchor'));
             $('#content-container').prepend($('<a />').attr('id', 'content-container-anchor').attr('class', 'named-anchor').attr('name', 'content-container-anchor'));
             
            $('#home').find('.box-ico a').each(function(){
              var hash = $(this).attr('href').substring(1, $(this).attr('href').length);
              $(this).attr('role', 'button');
              $(this).attr('data-hash', '#/' + hash);
              
              $(this).click(function(e){
              
                  e.preventDefault();
                  
                  var lang = $('html').attr('lang') == 'fr' ? 'en/my-info/' : 'fr/mon-info/';
                                    
                  $(this).parent().siblings().removeClass('active');
                  $(this).parent().addClass('active');
                  $("#ch-lang-url").attr('href', "/"+lang+document.location.hash);  
                  
                  document.location.hash = $(this).attr('data-hash');
              });
            });
            
            
          this.hideAll();
          this.setAria();
          this.bind('uriChange', 'load');
          this.bind('uriChange', 'goToHash');
          this.bind('uriChange', 'rewriteLangAttrHref');
          this.load();
        }        
    });
})(d4p);

(function (d4p) {

  
   var audience = new d4p.module('audience', {
   
     onClick: function() {
     //  add on click event on header
     //$("#audienceBtn").unbind('click');
     
    $("#audienceBtn").click(function(e){
        if($("#audience-widget").hasClass('active')) {
          $("#audience-widget").toggleClass('active');
          $("#audience-list").slideUp();
          $("#home").attr("tabindex",-1).focus();
        } else {
        $("#audience-widget").toggleClass('active');
        $("#audience-list").slideDown().attr("tabindex",-1).focus();
      }
    });

     },
   
   
     
     init: function() {
     
     window.group.init();
     this.onClick();

     $("#audience-widget").addClass('no-select');
     
     
    $('html').click(function(e){
      
      if($(e.target).parent().attr("id") == "audience-widget") { return; }
      
      if($("#audience-widget").hasClass('active')) { 
        $("#audience-widget").toggleClass('active');
      }
    });
  
    }
    });
})(d4p);


(function (d4p) {
 
 d4p.ui.analytic = {

    init: function (obj) {
      var l = d4p.l();
       $(".ui-accordion-header").click(
      function(){
        var value = jQuery.trim(String($(this).text()));
        _gaq.push(['_trackEvent', 'my-info', l.uri, value, 1]);
      }
    );
    }
  };
  
   var analytic = new d4p.module('analytics', {
  
       load: function () {
      var l = d4p.l();
      _gaq.push(['_trackPageview', document.location.pathname + '#' + l.uri]);
    },
      
     init: function() {
         this.bind('uriChange', 'load');
       }
    });
})(d4p);
