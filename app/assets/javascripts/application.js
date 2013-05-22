// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require form
//= require home
//= require home_scope

if (!Array.prototype.filter) {
  Array.prototype.filter = function(fun /*, thisp*/)
  {
    "use strict";
 
    if (this == null)
      throw new TypeError();
 
    var t = Object(this);
    var len = t.length >>> 0;
    if (typeof fun != "function")
      throw new TypeError();
 
    var res = [];
    var thisp = arguments[1];
    for (var i = 0; i < len; i++)
    {
      if (i in t)
      {
        var val = t[i]; // in case fun mutates this
        if (fun.call(thisp, val, i, t))
          res.push(val);
      }
    }
 
    return res;
  };
}
var months = ['Jan', 'Feb', 'March', 'April', 'May', 'June','July', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'];

function openSoundOff( args ) {
  var args = args || {},
    config = '', 
    mobile = false // Check if mobile


  for( var i in args ) {
    config += i + '=' + args[i];
  }

  if ( mobile ) { // if mobile - open form in new tab

  } else { // if not mobile - open form and append
    if( typeof form_iframe_soundoff != 'undefined' ) return false
    var dark = el('div'),
      form = el('iframe');

      dark.id = 'dark_div_soundoff'
      form.id = 'form_iframe_soundoff'

      form.src = '/form?'+config
      
      form.style.width = '0px'
      form.style.border = 'none'
      form.style.height = '0px'
      form.style.position = 'fixed'
      form.style.top = window.innerHeight / 6 + 'px'



      form.onload = function() {

        dark.style.opacity = 0.6
        dark.style.backgroundColor = 'black'

        dark.style.position = 'fixed'
        dark.style.top = '0px'
        dark.style.bottom = '0px'
        dark.style.left = '0px'
        dark.style.right = '0px'
        dark.style.zIndex = '99'
  
        document.body.appendChild( dark )

        form.style.bottom = '0px'
        form.style.left = '0px'
        form.style.right = '0px'
        form.style.zIndex = '100'
        form.style.width = '100%'
        form.style.height = '100%'
      }

      document.body.appendChild( form )

  }
  

  function el(type) { return document.createElement(type); }
}