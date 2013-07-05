if( $oundoff_config.home ) {

	var w_top, w_height, w_width, freeze, reset_styles, offset_factor, machine_scroll, kill_machine_scroll
	top_offset = 60
	med_cut_off = 860
	height_cut_off = 600

	$(document)
	.ready( function() {
		w_top = this.body.scrollTop,
		w_height = window.innerHeight,
		w_width = window.innerWidth,
		offset_factor =  0.4,
		reset_styles = true

		if( w_top / w_height > 1 || window.name.indexOf('soundoff_open') !== -1 ) {
			document.body.classList.add('fixed');
			$(logo).attr('src','/assets/SoundOffWhiteBeta.svg')
		}
	})
	.resize(function() {
		clearTimeout(machine_scroll);
		w_top = this.body.scrollTop,
		w_height = window.innerHeight,
		w_width = window.innerWidth
		resetStyles(null);
	}).scroll( function(e) {

		var w_top = window.scrollY,
			p = w_top / w_height;


		if( document.body.classList.contains('fixed') ) {

			if( w_width < med_cut_off  ) return false;
			var $divs = $('#content div.item');
			for (var i = $divs.length - 1; i >= 0; i--) {
				var campaign_div = $divs[i],
					offset_top = campaign_div.offsetTop,
					item = angular.element( campaign_div ).scope().item

				if( offset_top < w_top + top_offset ) {
					angular.element( main ).scope().$apply( function($scope) { $scope.active = item; });
					return false
				}

			}

			$(logo).attr('src','/assets/SoundOffWhiteBeta.svg')
			return false;
		}
		if( w_width > med_cut_off && w_height > height_cut_off ) {

			if( p < 1 ) {
				this.body.classList.remove('fixed')
				$(logo).attr('src','/assets/SoundOffAtCongressWhiteBeta.svg')
			} else {
				resetStyles('SoundOffWhiteBeta.svg');
				this.body.classList.add( 'fixed' )
				$('body').scrollTop(0)
				window.name += 'soundoff_open'
			}
		}
	})
	.on('click','.get_started',function() {
			$(logo).attr('src','/assets/SoundOffWhiteBeta.svg')
			$('body').addClass('fixed')
			window.name += 'soundoff_open'
			window.scroll_to(0,0);
	})
	.on('click','img#logo',function() {
		angular.element(main).scope().resetHard()
		window.name = window.name.replace(/soundoff_open/g,'')
		document.body.classList.remove('fixed')
		var $hide = $('#powered_by,#fixed').hide()
		$('body').scrollTop(0)
		setTimeout( function() { $(logo).attr('src','/assets/SoundOffAtCongressWhiteBeta.svg'); $hide.show(); },10)
	})
	.on('click','.open_soundoff', function() {
		var $this = $(this),
			config = {no_scoreboard: true}
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

		var target = $('#content .active').offset().top - 80
		scroll_to( target );
	})
	function resetStyles(logo) {
		if( reset_styles ) var $logo = $('#top, #menu, #content, #footer, #top, #description,#banner').attr('style',null).find('img#logo').attr('style',null)
		if( logo != null ) $logo.attr('src','/assets/'+logo)
		reset_styles = true;
	}

	function scroll_to(target_height,direction) {
		window.scrollTo(0 , target_height );
	}
}