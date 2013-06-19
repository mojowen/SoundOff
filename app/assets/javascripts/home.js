if( $oundoff_config.home ) {

	var w_top, w_height, w_width, freeze, reset_styles, offset_factor, machine_scroll, kill_machine_scroll
	top_offset = 80
	small_cut_off = 860


	$(document)
	.ready( function() {
		w_top = this.body.scrollTop,
		w_height = window.innerHeight,
		w_width = window.innerWidth,
		offset_factor =  0.4,
		reset_styles = true,
		freeze = false;

		if( w_top / w_height > 1 || window.name.indexOf('soundoff_open') !== -1 ) {
			document.body.classList.add('fixed');
			$(logo).attr('src','/assets/logo_no_cong.png')
		}
	})
	.scroll( function(e) {

		var w_top = this.body.scrollTop,
			p = w_top / w_height;


		if( document.body.classList.contains('fixed') ) {

			if( w_width < small_cut_off  ) return false;
			var divs = content.childNodes,
				unset = true;

			for (var i = divs.length - 1; i >= 0; i--) {
				var campaign_div = divs[i];

				if( campaign_div.tagName == 'DIV' ) {

					var offset_top = campaign_div.offsetTop,
						type = campaign_div.classList.contains('campaign') ? 'campaign' : 'rep',
						item = angular.element( campaign_div ).scope().item


					if( typeof item != 'undefined' && offset_top < w_top + top_offset ) {
						angular.element( main ).scope().$apply( function($scope) { $scope.active = item; });
						return false
					}

				}
			};
			$(logo).attr('src','/assets/logo_no_cong.png')
			return false;
		}

		if( w_width > 500 ) {

			if( p < 1 ) {

				this.body.classList.remove('fixed')
				$(logo).attr('src','/assets/logo.png')

				var $top = $('#top'),
					$foot = $('#footer'),
					$logo = $('img#logo',$top),
					$description = $('#description',$top),
					$menu = $('#menu'),
					$content = $('#content'),
					$banner = $('#banner')

				function p_css(percent) { return [ percent ,'%' ].join(''); };
				function n_css(number) { return [ number ,'px' ].join(''); };

				if( w_top < 10 ) {
					if( reset_styles ) $('#top, #menu, #content, #footer, #top, #description,#banner').attr('style',null).find('#home').attr('style',null) //.attr('src','/assets/logo.png')
					reset_styles = true

				} else if( w_top > 10 && w_top < w_height ) {

					if( w_width >= small_cut_off ) {
						var logo_width = w_width * .33,
							logo_width_rate = 170 - logo_width,

							logo_top = w_height * .3,
							logo_top_rate = 6 - logo_top,

							logo_left = 10,
							logo_left_rate = (7 - 10) / 10,

							description_top = w_height*offset_factor,
							description_top_rate = w_height*1.25 - description_top,

							banner_top = 0,
							banner_top_rate = 180 - ( - 200 ),

							top_border_width = 15,
							top_border_width_rate =  (4 - 15),
							top_bottom = w_height*.22,
							top_bottom_rate = ( (w_height-100) - top_bottom ),

							bottom_top = w_height * ( 1 - .22 ),
							menu_top = w_height + 20 + top_offset
							content_margin_top = w_height * 2 + 20 + top_offset

						$foot.css({ top: n_css( bottom_top - top_bottom_rate * p * 1.4 ), paddingBottom: '0px' })
						$menu.css({ top: n_css( menu_top - top_bottom_rate * p *1.4) })
						$content.css({ marginTop: n_css( content_margin_top - top_bottom_rate * p *1.4 ) })
						$top.css({
							minHeight: 0,
							borderBottomWidth: n_css( top_border_width + top_border_width_rate*p ),
							bottom: n_css( top_bottom + top_bottom_rate * p ),
						})

						$logo.css( {
							width: n_css( logo_width + logo_width_rate * p ),
							top: n_css( logo_top + logo_top_rate  * p ),
							left: p_css( logo_left + logo_left_rate * p)
						})

						if( p > 0.25 ) $(logo).attr('src','/assets/logo_no_cong.png')

						$description.css( { top: n_css( description_top - description_top_rate* p) })
						$banner.css( { top: n_css( banner_top - banner_top_rate* p) })
					} else {
						$description.hide()
						if( p > .1 ) {
							$(logo).attr('src','/assets/logo_no_cong.png')
							$top.css({
								position: 'fixed',
								height: '80px',
								borderBottomWidth: '4px',

							})
							$logo.css({
								width: '210px',
								top: '6px',
								left: '7%',
								marginTop: 0
							})
						}
						if( p > 0.3 ) {
							if( reset_styles ) $('#top, #menu, #content, #footer, #top, #description,#banner').attr('style',null).find('img').attr('style',null)

							reset_styles = true;

							this.body.classList.add( 'fixed' )
							window.name += 'soundoff_open'
						}
						$foot.css({ paddingBottom: '100px' })
					}

				}

			} else {
				if( reset_styles ) $('#top, #menu, #content, #footer, #top, #description,#banner').attr('style',null).find('img').attr('style',null)
				$(logo).attr('src','/assets/logo_no_cong.png')
				reset_styles = true;

				this.body.classList.add( 'fixed' )
				$('body').scrollTop(0)
				window.name += 'soundoff_open'
			}
		}
	})
	.on('click','.get_started',function() {
		if( w_width < 500 ) {
			$(logo).attr('src','/assets/logo_no_cong.png')
			$('body').addClass('fixed')
			window.name += 'soundoff_open'
		} else {
			scroll_to( w_height )
		}
	})
	.on('click','img#logo',function() {
		angular.element(main).scope().resetHard()
		window.name = window.name.replace(/soundoff_open/g,'')
		document.body.classList.remove('fixed')
		var $hide = $('#powered_by,#fixed').hide()
		$('body').scrollTop(0)
		setTimeout( function() { $(logo).attr('src','/assets/logo.png'); $hide.show(); },10)
	})
	.on('click','.open_soundoff', function() {
		var $this = $(this),
			config = {}
		if( $this.attr('campaign') ) config.campaign = $this.attr('campaign');
		if( $this.attr('rep') ) config.targets = $this.attr('rep');

		openSoundOff(config)
		return false;
	})
	.on('click','#menu .campaign, #menu .rep',function() {
		var type = this.classList.contains('campaign') ? 'campaign' : 'rep',
			item = angular.element( this ).scope()[type]

		angular.element( main ).scope().$apply( function($scope) { $scope.active = item; });

		if( machine_scroll ) clearTimeout(machine_scroll);

		scroll_to( $('#content .active').offset().top - 120 )
		kill_machine_scroll = setTimeout( function() { clearTimeout(machine_scroll); },1000)
	})

	function scroll_to(target_height,direction) {
		if( w_width < 500 ) return window.scrollTo(0 , target_height );

		var increment =
				Math.abs( target_height - w_top ) < 10 ? 1  :
				Math.abs( target_height - w_top ) < 50 ? 5  :
				Math.abs( target_height - w_top ) < 300 ? 15  :
				Math.abs( target_height - w_top ) < 1000 ? 100  : 250,
			direction = direction || ( target_height > w_top ? 1 : -1 )

		window.scrollBy(0,increment * direction);

		w_top = document.body.scrollTop;

		var next_increment =
				Math.abs( target_height - w_top ) < 10 ? 1  :
				Math.abs( target_height - w_top ) < 50 ? 5  :
				Math.abs( target_height - w_top ) < 300 ? 15  :
				Math.abs( target_height - w_top ) < 1000 ? 100  : 250

		if(
			Math.floor(w_top / next_increment) < Math.floor(target_height / next_increment) && direction > 0 && w_top > 0
			||
			Math.floor(w_top / next_increment) > Math.floor(target_height / next_increment) && direction < 0 && w_top > 0
		) {
			machine_scroll = setTimeout( function() { scroll_to(target_height,direction) }, 1);
		} else {
			window.scrollTo(0 , target_height );
			clearTimeout(kill_machine_scroll);
		}

	}
}