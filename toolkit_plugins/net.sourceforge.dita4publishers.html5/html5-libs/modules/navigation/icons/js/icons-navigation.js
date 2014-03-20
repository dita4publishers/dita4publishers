/**
 *  @file icons-navigation
 *
 *  !experimental, not yet ready
 *
 *  Copyright 2012 DITA For Publishers  
 * 
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */ 
(function (d4p) {
   var inav = new d4p.module('inav', {
   
    hideAll: function (id) {
      $('.content-chunk').hide();
    },
    
    hideAllAndShow: function (id) {
      $('.content-chunk').hide(function(){
        $("#"+id).show();
      });
    },
    
    show: function (id) {
      $("#"+id).show();
    },
    
    setAria: function () {
      $('.box-ico a').attr('aria-role', 'button');
    },
    
    loadIniContent: function () {
      var l = d4p.l();
      
      $("#home").hide();
      
      if(l.uri != ''){
        this.show(l.uri);        
      } else {
        $("#home").show();
      }
    },
    
    hashChanged: function () {
    
      this.toolBarHide();
      
      var l = d4p.l();   
      
      this.hideAll();
      $("#home").hide();
      
      if($('#'+l.uri).length != 0){
        this.show(l.uri);        
      }
      
      this.changeToolbar(l.uri);
      
    },
    
    toolBarAdd: function() {
      var toolBar = $("<div />").attr('class', 'toolbar');
      $(d4p.outputSelector).prepend(toolBar);
      this.toolBarHide();
    },
    
    toolBarHide: function () {    
      $(d4p.outputSelector+' div.toolbar').hide();
    },
    
    toolBarShow: function () {    
      $(d4p.outputSelector+' div.toolbar').show();    
    },
    
    changeToolbar: function(uri) {
          
      if(d4p.ajax.inCollection(uri)) {
        
        $('#'+d4p.ajax.collection[uri].refid).parents().map(function() {
          if($(this).attr('id') != undefined && $(this).attr('id').indexOf('tab') != -1){  
            var etoolBar = $(this).find("div.toolbar");  
            $(d4p.outputSelector+' div.toolbar').html(etoolBar.html());
            $(d4p.outputSelector+' div.toolbar').show();            
            
          }
        });;
        
      
      }  
    },
    
        //    
        init: function () {
            d4p.ajax.mode = 'append';
          this.hideAll();
          this.setAria();
          this.uriChange('hashChanged');
          this.loadIniContent();
          this.toolBarAdd();
        }        
    });
})(d4p);