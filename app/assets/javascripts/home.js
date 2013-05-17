if( $oundoff_config.home ) {

	var w_top, w_height, w_width	

	$(document)
	.ready( function() {
		w_top = this.body.scrollTop,
		w_height = window.innerHeight,
		w_width = window.innerWidth

		if( w_top / w_height > 1 ) document.body.classList.add('fixed');
		
	})
	.scroll( function(e) {
		var w_top = this.body.scrollTop,
			p = w_top / w_height;

		if( p < 1 ) {
			
			this.body.classList.remove('fixed')

			var $top = $('#top'),
				$foot = $('#footer'),
				$logo = $('img',$top),
				$description = $('#description',$top),
				$menu = $('#menu')

			function p_css(percent) { return [ percent * 100,'%' ].join(''); };
			function n_css(number) { return [ number ,'px' ].join(''); };

			if( w_top < 10 ) {
				$foot.attr('style',null)
				$top.attr('style',null)
				$logo.attr('style',null)
				$description.attr('style',null)
				$menu.attr('style',null)

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

				$foot.css({ top: n_css( bottom_top - top_bottom_rate * p * 1.4 ) })
				$menu.css({ top: n_css( menu_top - top_bottom_rate * p *1.4) })
				$top.css({ 
					borderBottomWidth: n_css( top_border_width + top_border_width_rate*p ),
					bottom: n_css( top_bottom + top_bottom_rate * p ) 
				})

				$logo.css( { width: n_css( logo_width + logo_width_rate * p ), top: n_css( logo_top + logo_top_rate  * p ) })
				$description.css( { top: n_css( description_top - description_top_rate* p) })
			}
		} else {
			$('#top, #menu').attr('style',null).find('img').attr('style',null)
			this.body.classList.add( 'fixed' )
		}
	})
	.on('click','.get_started',function() {
		scroll_to(1000)
	})

	function scroll_to(target_height) {
		var increment = 25

		window.scrollBy(0,increment);
		w_top = document.body.scrollTop;
		if( Math.floor(w_top / increment) < Math.floor(target_height / increment)  ) setTimeout( function() { scroll_to(target_height) }, 1);

	}
}