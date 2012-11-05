/**
 * Module object
 */ 
(function (window, d4p) {

  d4p.module = function (name, obj) {

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

  d4p.module.prototype.hash = function () {
    return document.location.hash.substring(1);
  };

  // register document ready function
  d4p.module.prototype.docReady = function (fname) {
    d4p._docReady.push({
      name: this.name,
      fn: fname
    });
  };

  // register a hashChange callback
  d4p.module.prototype.uriChange = function (fname) {
    d4p._uriChange.push({
      name: this.name,
      fn: fname
    });
  };


})(window, d4p);