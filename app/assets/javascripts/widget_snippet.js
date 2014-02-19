//= require base_domain
//= require is_mobile
//= require open_soundoff
//= require ready

ready( function() {
	var d = document,
		links = d.getElementsByTagName('a')

	for (var i = links.length - 1; i >= 0; i--) {
		var add_link = links[i],
			campaign = add_link.getAttribute('campaign'),
			title = add_link.textContent || add_link.innerText

		if( campaign != null ) {
			var the_parent = add_link.parentElement,
				container = d.createElement('div')
				widget_frame = d.createElement('iframe'),
				widget_top_button = d.createElement('div'),
				config = [],
				style = add_link.className.replace(/soundoff_widget|\_|\s/g,''),
				page_url = add_link.getAttribute('page_url'),
				skip_when_matched = add_link.getAttribute('skip_when_matched'),
				open_if_email = add_link.getAttribute('open_if_email'),
				width = '100%',
				minWidth = '280px',
				maxWidth = '600px',
				height = 500

			if( typeof $oundoff_open_if_email !== 'undefined') open_if_email = $oundoff_open_if_email;

			config.push( 'style='+style  )
			config.push( 'campaign='+campaign.replace(/\#/,'') )
			config.push( 'hashtag='+title.replace(/\#/,'') )
			// If $oundoff_demo is defined - then load sample tweets
			if( typeof $oundoff_demo != 'undefined' ) config.push( 'demo=true' );

			widget_frame.scrolling = 'no'
			widget_frame.frameborder = '0'
			widget_frame.allowTransparency = 'true'
			widget_frame.src = $oundoff_base_domain+'/widget?'+config.join('&')

			// Something about style - light or dark

			widget_frame.style.border = 'none'
			widget_frame.style.overflow = 'hidden'
			widget_frame.style.height = height + 6 + 'px'
			widget_frame.style.width = width
			widget_frame.style.minWidth = minWidth
			widget_frame.setAttribute('frameBorder','0')
			widget_frame.style.borderRadius = '3px'

			// The top "button"
			widget_top_button.setAttribute('campaign',campaign)
			widget_top_button.setAttribute('module_style',style)
			if( page_url !== null ) widget_top_button.setAttribute('page_url',page_url)
			if( skip_when_matched !== null ) widget_top_button.setAttribute('skip_when_matched',true)
			widget_top_button.style.position = 'absolute'
			widget_top_button.style.cursor = 'pointer'
			widget_top_button.style.zIndex = '100'
			widget_top_button.style.top = '0px'
			widget_top_button.style.width = width
			widget_top_button.style.minWidth = width
			widget_top_button.style.maxWidth = maxWidth
			widget_top_button.style.height = '133px'

			// The container
			container.style.position = 'relative'
			container.style.height = height + 10 +'px'
			container.style.width = width

			container.appendChild(widget_frame)
			container.appendChild(widget_top_button)

			the_parent.insertBefore(container,add_link)

			function launchModule() {
				var config = {
						campaign: this.getAttribute('campaign'),
						style: this.getAttribute('module_style'),
						page_url: this.getAttribute('page_url'),
						skip_when_matched: this.getAttribute('skip_when_matched')
					},
					email = (document.location.search.match(/email=\S[^&]/) || [''])[0].replace('email=','')
				if( email.length > 0 ) config['email'] = email;

				openSoundOff( config )
			}
			widget_top_button.onclick = launchModule;

			the_parent.removeChild(add_link)

			if( open_if_email !== null && document.location.search.search('email=') !== -1 ) {
				var email = document.location.search.match(/email=\S[^&]/)[0].replace('email=',''),
					config = {
						campaign: campaign,
						style: style,
						email: email,
					}
				if( skip_when_matched !== null ) config['skip_when_matched'] = true
				if( page_url !== null ) config['page_url'] = page_url
				openSoundOff(config)
			}
		}
	};
})
