/**
 *  @file module
 *
 *  Allow to instantiate a module to work with the d4p Object
 *  The d4p object will automatically initialize the module.
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
(function (window, d4p) {

  d4p.module = function (name, obj) {
    
    var i = 0;
    this.name = name;

    // set option
    for (i in obj) {
      if (this[i] == undefined) {
        this[i] = obj[i];
      }
    }

    // register component in d4p	
    if (this.init != undefined) {
      d4p.mod.push(name);
    }

    d4p[name] = this;

  };

  // deprecated
  d4p.module.prototype.hash = function () {
    return document.location.hash.substring(1);
  };

  // register document ready function
  // possible key: uriChange, docChange
  d4p.module.prototype.bind = function (key, fname) {
    d4p['e'+key].push({
      name: this.name,  // module name
      fn: fname         // function name to call
    });
  };

})(window, d4p);