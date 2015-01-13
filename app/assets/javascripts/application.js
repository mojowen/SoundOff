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
//= require base_domain
//= require is_mobile
//= require form
//= require home
//= require home_app
//= require home_controller
//= require open_soundoff

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
function is_touch_device() {
  return !!('ontouchstart' in window) // works on most browsers
      || !!('onmsgesturechange' in window); // works on ie10
};
if( is_touch_device() ) {
  document.body.classList.add('touch');
}
$(document).on('click touchstart','#top_menu a.menu',function(e) {
  if( is_touch_device() ) {
    var $parent = $(this).parent()
    if( ! $parent.hasClass('on') ) $('#main').bind('click touchstart', function() {  $parent.removeClass('on'); $(this).unbind('click touchstart') });
    else $('#main').unbind('click touchstart')

    $parent.toggleClass('on')
  }
  e.preventDefault();
})
