function openSoundOff( args ) {
  var args = args || {},
    config = '',
    d = document

  if( typeof args == 'string' ) args = { campaign: args }
  for( var i in args ) {
    if( args[i] != null ) {
      if( i == 'campaign' ) args['campaign'] = args[i].toString().replace(/\#/g,'')
      if( i == 'reps' ) args['reps'] = args[i].replace(/\@/g,'').join(',')
      config += i + '=' + args[i] +'&';
    }
  }

  if ( isMobile.any() ) {
    if( ! args.no_click ) window.open($oundoff_base_domain+'/form?'+config);
    else document.location = $oundoff_base_domain+'/form?'+config;
  } else { // if not mobile - open form and append

    if( typeof args['remote'] != 'undefined' ) config += '&remote=true'
    config += '&post_message_to='+d.location.toString()

    if( typeof form_iframe_soundoff != 'undefined' ) return false
    var dark = el('div'),
      close = el('div'),
      form = el('iframe');

      dark.id = 'dark_div_soundoff'
      close.id = 'close_div_soundoff'
      form.id = 'form_iframe_soundoff'

      form.src = $oundoff_base_domain+'/form?'+config

      form.style.width = '0px'
      form.style.border = 'none'
      form.style.height = '0px'
      form.style.position = 'fixed'
      form.setAttribute('frameBorder','0')
      form.style.top = (args.top || '60')+'px'



      form.onload = function() {

        dark.style.opacity = 0.6
        dark.style.backgroundColor = '#348DAF'

        dark.style.position = 'fixed'
        dark.style.top = '0px'
        dark.style.bottom = '0px'
        dark.style.left = '0px'
        dark.style.right = '0px'
        dark.style.zIndex = '99'
        dark.onclick = closeWindow

        close.style.position = 'fixed'
        close.style.top = ( ( parseInt(args.top) || 60)+ 14 ).toString()+'px'
        close.style.left = ( window.innerWidth * .96 )/2 + 396/2 - 36 + 14 +'px'
        close.style.zIndex = '110'
        close.style.width = '30px'
        close.style.height= '50px'
        close.style.cursor = 'pointer'
        close.onclick = closeWindow

        function closeWindow() {
          if ( confirm('Are you sure you want to cancel your SoundOff?') ) {
            var dark = document.getElementById('dark_div_soundoff'),
                close = document.getElementById('close_div_soundoff'),
                frame = document.getElementById('form_iframe_soundoff')
            dark.parentNode.removeChild( dark )
            frame.parentNode.removeChild( frame )
            close.parentNode.removeChild( close )
            window.onbeforeunload = null
          }
        }
        window.onbeforeunload = function(e) {
          return 'Are you sure you want to cancel your SoundOff?';
        };
        try {
          window.addEventListener("message", function(e) {
            window.onbeforeunload = null;
            close.onclick = function() {
              var dark = document.getElementById('dark_div_soundoff'),
                  close = document.getElementById('close_div_soundoff'),
                  frame = document.getElementById('form_iframe_soundoff')
                frame.parentNode.removeChild( frame )
                dark.parentNode.removeChild( dark )
                close.parentNode.removeChild( close )
            }
          }, false);
        } catch(e) {}


        d.body.appendChild( dark )
        d.body.appendChild( close )

        form.style.left = '0px'
        form.style.right = '0px'
        form.style.zIndex = '100'
        form.style.width = '96%'
        form.style.margin = '0 auto'
        form.style.overflow = 'hidden'

        form.scrolling = 'no'

        form.style.minHeight = '680px'

      }

      d.body.appendChild( form )

  }

  function el(type) { return d.createElement(type); }
}