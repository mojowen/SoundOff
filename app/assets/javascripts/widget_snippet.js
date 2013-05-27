//= require base_domain
//= require open_soundoff
//= require ready

ready( function() {
	var d = document,
		links = d.getElementsByTagName('a')

	for (var i = links.length - 1; i >= 0; i--) {
		var add_link = links[i],
			campaign = add_link.getAttribute('campaign')

		if( campaign != null ) {
			var the_parent = add_link.parentElement,
				container = d.createElement('div')
				widget_frame = d.createElement('iframe'),
				widget_button = d.createElement('div'),
				config = []

			config.push( 'style='+add_link.className.replace(/soundoff_widget|\_|\s/g,'')  )
			config.push( 'campaign='+campaign.replace(/\#/,'') )

			widget_frame.scrolling = 'no'
			widget_frame.frameborder = '0'
			widget_frame.allowTransparency = 'true'
			widget_frame.src = $oundoff_base_domain+'/widget?'+config.join('&')

			// Something about style - light or dark

			widget_frame.style.border = 'none'
			widget_frame.style.overflow = 'hidden'
			widget_frame.style.height = '502px'
			widget_frame.style.width = '302px'
			widget_frame.style.borderRadius = '3px'

      		// The "button"
      		widget_button.setAttribute('campaign',campaign)
      		widget_button.style.position = 'absolute'
      		widget_button.style.cursor = 'pointer'
      		widget_button.style.zIndex = '100px'
      		widget_button.style.bottom = '0px'
      		widget_button.style.width = '302px'
      		widget_button.style.height = '64px'

			
			// The container
			container.style.position = 'relative'
			container.style.height = '502px'
			container.style.width = '302px'

			container.appendChild(widget_frame)
			container.appendChild(widget_button)
			
			the_parent.insertBefore(container,add_link)
			widget_button.onclick = function() { openSoundOff( this.getAttribute('campaign').replace(/\#/,'') ) }

			the_parent.removeChild(add_link)
		}
	};
})