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
				widget_bottom_button = d.createElement('div'),
				widget_top_button = d.createElement('div'),
				config = [],
				style = add_link.className.replace(/soundoff_widget|\_|\s/g,'')

			config.push( 'style='+style  )
			config.push( 'campaign='+campaign.replace(/\#/,'') )

			widget_frame.scrolling = 'no'
			widget_frame.frameborder = '0'
			widget_frame.allowTransparency = 'true'
			widget_frame.src = $oundoff_base_domain+'/widget?'+config.join('&')

			// Something about style - light or dark

			widget_frame.style.border = 'none'
			widget_frame.style.overflow = 'hidden'
			widget_frame.style.height = '510px'
			widget_frame.style.width = '302px'
			widget_frame.style.borderRadius = '3px'

			// The top "button"
			widget_top_button.setAttribute('campaign',campaign)
			widget_top_button.setAttribute('module_style',style)
			widget_top_button.style.position = 'absolute'
			widget_top_button.style.cursor = 'pointer'
			widget_top_button.style.zIndex = '100'
			widget_top_button.style.top = '0px'
			widget_top_button.style.width = '302px'
			widget_top_button.style.height = '64px'

			// The bottom "button"
			widget_bottom_button.setAttribute('campaign',campaign)
			widget_bottom_button.setAttribute('module_style',style)
			widget_bottom_button.style.position = 'absolute'
			widget_bottom_button.style.cursor = 'pointer'
			widget_bottom_button.style.zIndex = '100'
			widget_bottom_button.style.bottom = '18px'
			widget_bottom_button.style.width = '302px'
			widget_bottom_button.style.height = '60px'

			
			// The container
			container.style.position = 'relative'
			container.style.height = '510px'
			container.style.width = '302px'

			container.appendChild(widget_frame)
			container.appendChild(widget_top_button)
			container.appendChild(widget_bottom_button)
			
			the_parent.insertBefore(container,add_link)
			widget_bottom_button.onclick = function() { openSoundOff( { campaign: this.getAttribute('campaign').replace(/\#/,''), style: this.getAttribute('module_style') } ) }
			widget_top_button.onclick = function() { openSoundOff( { campaign: this.getAttribute('campaign').replace(/\#/,''), style: this.getAttribute('module_style') } ) }

			the_parent.removeChild(add_link)
		}
	};
})