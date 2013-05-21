if( $oundoff_config.home ) {

	var w_top, w_height, w_width, freeze
	
	$(document)
	.ready( function() {
		w_top = this.body.scrollTop,
		w_height = window.innerHeight,
		w_width = window.innerWidth
		reset_styles = true
		freeze = false

		if( w_top / w_height > 1 || window.name.indexOf('soundoff_open') !== -1 ) document.body.classList.add('fixed');
		
	})
	.scroll( function(e) {

		// $('body').scrollTop(w_height);

		if( document.body.classList.contains('fixed') ) return false

		var w_top = this.body.scrollTop,
			p = w_top / w_height;

		if( p < 1 ) {
			
			this.body.classList.remove('fixed')

			var $top = $('#top'),
				$foot = $('#footer'),
				$logo = $('img',$top),
				$description = $('#description',$top),
				$menu = $('#menu'),
				$content = $('#content')

			function p_css(percent) { return [ percent * 100,'%' ].join(''); };
			function n_css(number) { return [ number ,'px' ].join(''); };

			if( w_top < 10 ) {
				if( reset_styles ) $('#top, #menu, #content, #footer, #top, #description').attr('style',null).find('img').attr('style',null)
				reset_styles = true


			} else if( w_top > 10 && w_top < w_height ) {
				var logo_width = window.innerWidth * .38,
					logo_width_rate = 180 - logo_width,
					logo_top = w_height * ( .3 - .18),
					logo_top_rate = 20 - logo_top,
					description_top = w_height*.3,
					description_top_rate = w_height*1.25 - description_top,
					top_border_width = 15,
					top_border_width_rate =  (4 - 15),
					top_bottom = w_height*.22,
					top_bottom_rate = ( (w_height-100) - top_bottom ),
					bottom_top = w_height * ( 1 - .22 ),
					menu_top = w_height + 120
					content_margin_top = w_height * 2 + 120

				$foot.css({ top: n_css( bottom_top - top_bottom_rate * p * 1.4 ) })
				$menu.css({ top: n_css( menu_top - top_bottom_rate * p *1.4) })
				$content.css({ marginTop: n_css( content_margin_top - top_bottom_rate * p *1.4 ) })
				$top.css({ 
					borderBottomWidth: n_css( top_border_width + top_border_width_rate*p ),
					bottom: n_css( top_bottom + top_bottom_rate * p ) 
				})

				$logo.css( { width: n_css( logo_width + logo_width_rate * p ), top: n_css( logo_top + logo_top_rate  * p ) })
				$description.css( { top: n_css( description_top - description_top_rate* p) })
			}
		} else {
			if( reset_styles ) $('#top, #menu, #content, #footer, #top, #description').attr('style',null).find('img').attr('style',null)
			reset_styles = true

			this.body.classList.add( 'fixed' )
			$('body').scrollTop(0)
			window.name += 'soundoff_open'
		}
	})
	.on('click','.get_started',function() {
		scroll_to( w_height )
	})
	.on('click','.home',function() {
		window.name = window.name.replace(/soundoff_open/g,'')
		document.body.classList.remove('fixed')
		$('body').scrollTop(0)
	})

	function scroll_to(target_height) {
		var increment = 25

		window.scrollBy(0,increment);
		w_top = document.body.scrollTop;
		if( Math.floor(w_top / increment) < Math.floor(target_height / increment)  ) setTimeout( function() { scroll_to(target_height) }, 1);

	}
}