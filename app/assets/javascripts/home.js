if( $oundoff_config.home ) {

	var w_top, w_height, w_width, freeze, rotate_go
	top_offset = 100
	med_cut_off = 860
	height_cut_off = 600
	w_width = window.innerWidth
	$welcome = $(welcome)

	$(window).resize(function() {
		w_top = document.body.scrollTop,
		w_height = window.innerHeight,
		w_width = window.innerWidth
		if( w_width < 860 ) {
			resizeTabs(11);
			$(terrible).hide()
		} else {
			$('span',tabs).css('fontSize','');
			nextSlider( 0 );
		}
	})

	$(document)
	.ready( function() {
		w_top = this.body.scrollTop,
		w_height = window.innerHeight,
		w_width = window.innerWidth
		if( w_width < 860 ) resizeTabs();
		else nextSlider( 0 );

		if( typeof $oundoff_config.single != 'undefined' && $oundoff_config.single != null ) {
			$welcome.hide()
			$(terrible).hide()
		} else {
			if( w_width > 860 ) $(terrible).show()
		}
	})
	.scroll( function(e) {

		var w_top = window.scrollY

		if( w_width < 860 ) return false;

		if( w_top == 0 && $welcome.is(':visible') ) $(terrible).show();
		else $(terrible).hide();

		if( w_top > $welcome.height() ) {
			$('#terrible .step').removeClass('on')
			if( $welcome.is(':visible') ) {
				scroll_to(0, w_top -  $welcome.height() )
				$welcome.hide();
			}
		}
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

	})
	.on('click','img#logo',function() {
		angular.element(main).scope().resetHard()
		$('body').scrollTop(0)

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
		var type = $(this).hasClass('campaign') ? 'campaign' : 'rep',
			item = angular.element( this ).scope()[type]

		$(welcome).hide()
		angular.element( main ).scope().$apply( function($scope) { $scope.active = item; });


		var target = $('#content .active').offset().top - 80
		scroll_to( target );
	})
	.on('click','.tutorial', function() { overlay(); return false; } )
	.on({
		mouseenter: function(e) {
			$('.rotate .step').removeClass('on')
			var next_step = $(this).index()
			$('.describe .step').removeClass('on').eq( next_step ).addClass('on')
			$('#terrible .step').removeClass('on').eq( next_step ).addClass('on')
			clearTimeout( rotate_go )
		},
		mouseout: function(e) {
			nextSlider( $(this).index() )
		}
	},'.rotate .step')
	.on('click','#welcome .close',function() { $(this).parent().hide(); $(terrible).hide(); })
	.on('click','#logo',function() { $(welcome).show(); $(terrible).show(); reset(); })
	.on('click touchdown','.back',function() { reset() })
	.on('DOMNodeRemoved', function(e) {
		if( e.target.nodeName  === 'BLOCKQUOTE' && e.target.className == 'twitter-tweet' ) {
			e.target.parentNode.className += ' tweet_widgetized'
		}
	})

	function reset() { angular.element( main ).scope().$apply( function($scope) { $scope.reset() }); }
	function nextSlider( next_step ) {

		var next_step = next_step || 0,
			$rotate_step = $('.rotate .step',$welcome)

		if( $('.rotate .step:hover',$welcome).length == 0 && $welcome.is(':visible') ) {
				$rotate_step.removeClass('on').eq( next_step ).addClass('on')

				$('.describe .step',$welcome).removeClass('on').eq( next_step ).addClass('on')
				if( window.scrollY == 0 ) $('#terrible .step').removeClass('on').eq( next_step ).addClass('on')

				next_step = next_step > 1 ? 0 : next_step + 1

				rotate_go = setTimeout( function() { nextSlider( next_step ) },5000)
		} else {
			clearTimeout( rotate_go )
		}

	}
	function overlay() {
		if( $('body').toggleClass('overlaid').hasClass('overlaid') ) {
			var $rest = $(rest)
			$(welcome,terrible).hide();
			scroll_to(0,0);
			angular.element( main ).scope().$apply( function($scope) { $scope.mode = 'Scoreboard'; $scope.resetHard(); } )
			$(main).css({ height: window.innerHeight, minHeight: '0px', overflow: 'hidden'})
			$('#top,#menu').css('position','absolute')
			setTimeout( function() {
				$(document).bind('click.overlay', function() { overlay(); $(this).unbind('click.overlay') })
			}, 10);
		} else {
			$(welcome).show()
			$('#top,#menu,#main').attr('style','')
		}
	}
	function scroll_to(target_height,direction) {
		window.scrollTo(0 , target_height );
	}
	function resizeTabs(starting_size) {
		var sum = 0,
			$tabs = $('span',tabs),
			fontSize = typeof starting_size == 'undefined' ? parseFloat( $('span',tabs)[0].style.fontSize.replace('px','') ) : starting_size

		if( isNaN( fontSize ) ) fontSize = 11
		$tabs.each( function(i,el) { sum += el.offsetWidth; })

		if( sum / w_width < 0.9 ) {
			$tabs.css('fontSize', fontSize + 1 );
			return resizeTabs()
		}
		if( sum > w_width ) $tabs.css('fontSize', fontSize - 1 );
	}
}