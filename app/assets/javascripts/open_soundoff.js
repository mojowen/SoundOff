function openSoundOff( args ) {
  var args = args || {},
    config = '', 
    mobile = false, // Check if mobile
    d = document

  if( typeof args == 'string' ) args = { campaign: args }
  for( var i in args ) {
    if( i == 'campaign' ) args[i] = args[i].replace(/\#/g,'')
    config += i + '=' + args[i];
  }

  if ( mobile ) { // if mobile - open form in new tab

  } else { // if not mobile - open form and append
    if( typeof form_iframe_soundoff != 'undefined' ) return false
    var dark = el('div'),
      form = el('iframe');

      dark.id = 'dark_div_soundoff'
      form.id = 'form_iframe_soundoff'

      form.src = $oundoff_base_domain+'/form?'+config
      
      form.style.width = '0px'
      form.style.border = 'none'
      form.style.height = '0px'
      form.style.position = 'fixed'
      form.style.top = '60px'



      form.onload = function() {

        dark.style.opacity = 0.6
        dark.style.backgroundColor = 'black'

        dark.style.position = 'fixed'
        dark.style.top = '0px'
        dark.style.bottom = '0px'
        dark.style.left = '0px'
        dark.style.right = '0px'
        dark.style.zIndex = '99'
        dark.onclick = function() {
          if ( confirm('Are you sure you want to cancel your SoundOff?') ) {
            var dark = this
                frame = document.getElementById('form_iframe_soundoff')
            dark.parentNode.removeChild( dark )
            frame.parentNode.removeChild( frame )
          }
        }
  
        d.body.appendChild( dark )

        form.style.left = '0px'
        form.style.right = '0px'
        form.style.zIndex = '100'
        form.style.width = '46%'
        form.style.margin = '0 auto'

        form.style.minHeight = '652px'

      }

      d.body.appendChild( form )

  }
  

  function el(type) { return d.createElement(type); }
}