if( $oundoff_config.home ) {
	

	$(document)
	.ready( function() {
		if( document.body.scrollTop / window.innerHeight ) document.body.classList.add('fixed');
	})
	.scroll( function(e) {
		var top = this.body.scrollTop,
			w_height = window.innerHeight,
			w_width = window.innerWidth,
			p = top / w_height;

		if( p < 1 ) {
			
			this.body.classList.remove('fixed')

			var $top = $('#top'),
				$foot = $('#footer'),
				$logo = $('img',$top),
				$description = $('#description',$top)

			function p_css(percent) { return [ percent * 100,'%' ].join(''); };
			function n_css(number) { return [ number ,'px' ].join(''); };

			if( top < 10 ) {
				$foot.attr('style',null)
				$top.attr('style',null)
				$logo.attr('style',null)
				$description.attr('style',null)

			} else if( top > 10 && top < w_height ) {
				var logo_width = window.innerWidth * .38,
					logo_width_rate = 180 - logo_width,
					logo_top = w_height * ( .3 - .18),
					logo_top_rate = 20 - logo_top,
					description_top = w_height*.3,
					description_top_rate = w_height*1.5 - description_top,
					top_border_width = 15,
					top_border_width_rate =  (4 - 15),
					top_bottom = w_height*.22,
					top_bottom_rate = ( (w_height-100) - top_bottom )

				$foot.css({ left: p_css(-p), right: p_css(p) })
				$top.css({ 
					borderBottomWidth: n_css( top_border_width + top_border_width_rate*p ),
					bottom: n_css( top_bottom + top_bottom_rate * p ) 
				})

				$logo.css( { width: n_css( logo_width + logo_width_rate * p ), top: n_css( logo_top + logo_top_rate  * p ) })
				$description.css( { top: n_css( description_top - description_top_rate* p) })
			} 
		} else {
			$('#top').attr('style',null).find('img').attr('style',null)
			this.body.classList.add( 'fixed' )
		}
	})


}