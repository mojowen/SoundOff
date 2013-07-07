function formScope($http, $scope) {

	var config = {
			target: $oundoff_config.target || 'house', // Can also be senate
			limits: { 'house': 1, 'senate': 2, 'all': 3},
			campaign: $oundoff_config.campaign || null,
			email_required: $oundoff_config.email_required || false,
			name: $oundoff_config.name || null,
			page_url: $oundoff_config.page_url || false,
		}

	$scope.campaign = config.campaign != null ? '#'+config.campaign : ''
	$scope.name = config.campaign != null ? '#'+config.campaign : 'Tweet @ Your Rep'
	$scope.stage = 1

	$scope.nextStage = function() {
		var $notice = $('#notice').html('').attr('class',''),
			errors = [],
			next = 1

		$('input,textarea').blur().removeClass('oops')

		switch( $scope.stage ) {
			case 1:
				if( $scope.sunligh_fetching ) {
					$notice.text('one sec - grabbing some data')
					$scope.ready_for_2 = true
					return false
				}
				if( $scope.zip.length < 4 ) {
					errors.push( 'missing your zip code')
					zip.className += ' oops'
				}
				if( $scope.email.length < 1 && config.email_required ) {
					errors.push( 'email is required')
					email.className += ' oops'
				}

				if( $scope.raw_targets.length > 0 ) next = 3;
				else next = 2;
				break;
			case 2:
				if( $scope.geocoder_fetching ) {
					$notice.text('one sec - grabbing some data')
					$scope.ready_for_3 = true
					return false
				}
				if( $scope.street.length < 1 ) {
					errors.push( 'missing street')
					street.className += ' oops'
				}
				if( $scope.city.length < 1 ) {
					errors.push( 'missing city')
					city.className += ' oops'
				}

				next = 3;
				break;
			case 3:
				if( $scope.message.length < 1 ){
					errors.push( 'you should really write something')
					message.className += ' oops'
				} else {
					var targets = $scope.targets.map( function(el) { return '@'+el.twitter_screen_name}).join(' ');

					if( $scope.drop_campaign ) message = [ targets,$scope.message,'#SoundOff' ].join(' ');
					else message = [ targets, $scope.message,$scope.campaign.replace(/\s/g,''),'#SoundOff' ].join(' ');

					window.onbeforeunload = null;
					if( window.self != window.parent && typeof $oundoff_config.post_message_to != 'undefined' ) try {
						window.parent.postMessage('off', $oundoff_config.post_message_to);
					} catch(e) {}

					$.post(
						'/form',
						{
							soundoff: {
								email: $scope.email,
								zip: $scope.zip,
								message: message,
								targets: targets,
								campaign_id: $oundoff_config.id,
								hashtag: $scope.drop_campaign ? null : $scope.campaign,
								headcount: $scope.add_headcount,
								partner: $scope.add_partner
							}
						}
					)

					window.open('/redirect.html#'+'​'+encodeURI(message).replace(/\#/g,'%23') );
					next = 4
				}
				break;
		}

		if( errors.length > 0 ) $notice.addClass('oops').html( errors.join(' and ') )
		else $scope.stage = next;

		return false
	}


	// Stage 1
	$scope.zip = $oundoff_config.zip || ''
	$scope.email = $oundoff_config.email || ''
	$scope.add_partner =  $oundoff_config.no_email
	$scope.add_headcount = $oundoff_config.no_email && $scope.email.length < 1

	$scope.ready_for_2 = false;
	if( $scope.zip.length > 4 && ( $scope.email.length > 0 ||  $oundoff_config.no_email || $scope.campaign == '' ) ) $scope.ready_for_2 = true;

	$scope.sunligh_fetching = false

	$scope.electeds = []

	$scope.raw_targets = $oundoff_config.targets || []

	$scope.targets = []
	if( $scope.raw_targets.length > 0 ) {
		if( $scope.campaign == '' ) $scope.campaign = 'Tweet @'+$scope.raw_targets.map(function(el) { return el.twitter_id }).join(' @')
		$scope.stage = 3;
		var passed_targets = $scope.raw_targets.map( function(el) { return el.twitter_id }).join(',')
	} else {
		passed_targets = ''
	}

	if( passed_targets.length == 0 && config.campaign == null ) config.target = 'all'
	$scope.$watch( 'zip', function(newValue){
		newValue = newValue.split('-')[0].replace(/\s/,'')
		if( typeof newValue != 'undefined' && newValue.length == 5 && $scope.raw_targets.length == 0 ) {
				var query = 'http://congress.api.sunlightfoundation.com/legislators/locate?apikey=8fb5671bbea849e0b8f34d622a93b05a&callback=JSON_CALLBACK&zip='+$scope.zip
				$scope.sunligh_fetching = true
				$http.jsonp(query,{})
					.success(function(data,status) {
						$scope.electeds = data.results;
						var limit = config.limits[ config.target ],
							targets = $scope.electeds.filter( function(el) { return el.chamber == config.target || config.target == 'all' } )

						if( targets.length != limit && typeof google_maps == 'undefined' ) addGoogleMaps();
						else $scope.raw_targets = targets;

						$scope.sunligh_fetching = false;
						if( $scope.ready_for_2 ) $scope.nextStage()
					})
		}

		if( newValue.length > 5 ) {
			$oundoff_config.targets.push( {twitter_id: 'whitehouse'} )
			$scope.raw_targets = [{twitter_id: 'whitehouse'}]
		}
	})

	// Stage 2 - clarfiy location
	$scope.street = ''
	$scope.city = ''
	$scope.latlng = false
	$scope.address = ''

	$scope.geocoder = false
	$scope.geocoder_fetching = false
	$scope.ready_for_3 = false

	$scope.$watch( 'city', lookupLatLng )
	$scope.$watch( 'street', lookupLatLng )
	$scope.$watch( 'geocoder', lookupLatLng )


	function addGoogleMaps() {
		var script = document.createElement( 'script' ),
			fjs = document.head.getElementsByTagName('script')[0]
    	script.type = 'text/javascript';
    	script.id = 'google_maps';
    	script.src = 'http://maps.google.com/maps/api/js?sensor=true&callback=addGeocoder';
		fjs.parentNode.insertBefore( script, fjs);
	}

	function lookupLatLng() {
		var address = [$scope.street, $scope.city, $scope.zip].join(' ')

		if( $scope.street != '' && $scope.city != '' && $scope.geocoder && ! $scope.geocoder_fetching && $scope.address != address) {
			$scope.geocoder_fetching = true;
			$scope.address = address;

			$scope.geocoder.geocode( { 'address': address}, function(results, status) {
				if( typeof  results[0] == 'undefined' ) {
					$('#notice').html('').attr('class','').text('We couldn\'t match that address to a rep :(')
					$oundoff_config.targets.push( {twitter_id: 'whitehouse'} )
					$scope.raw_targets = [{twitter_id: 'whitehouse'}]
					$scope.stage = 3
				} else {
					var location = results[0].geometry.location,
						latlng = []
					for( var i in location ) {
						if( typeof location[i] == 'number' ) latlng.push( location[i] )
					}
					latlng = latlng.sort()
					getByLatLng(latlng);
				}
		    });
		}
	}

	function getByLatLng(latlng) {
		if( latlng && latlng != $scope.latlng ) {

				var query = 'http://congress.api.sunlightfoundation.com/legislators/locate?apikey=8fb5671bbea849e0b8f34d622a93b05a&callback=JSON_CALLBACK&latitude='+latlng[1]+"&longitude="+latlng[0]
				$http.jsonp(query,{})
					.success( function(data,status){
						$scope.electeds = data.results;
						$scope.raw_targets = $scope.electeds.filter( function(el) { return el.chamber == config.target || config.target == 'all' } )

						console.log(' found '+$scope.electeds.map(function(el){ return el.last_name }) )

						$scope.geocoder_fetching = false;
						$scope.latlng = latlng
						if( $scope.raw_targets.length == 0 ) {
							$oundoff_config.targets.push( {twitter_id: 'whitehouse'} )
							$scope.raw_targets = [{twitter_id: 'whitehouse'}];
						}
						if( $scope.ready_for_3 ) $scope.nextStage();
				})
		}
	}

	// Stage 3
	$scope.message = $oundoff_config.message || ''
	$scope.drop_campaign = $oundoff_config.campaign == null ? true : false

	$scope.removeCampaign = function() {
		$scope.drop_campaign = true
	}

	$scope.targets_list = function() { return $scope.targets.map( function(el) { return '@'+el.twitter_screen_name }).join(' ') }


	$scope.counter = 139

	$scope.$watch('raw_targets',function(targets) {

		var params = '',
			sns = $scope.raw_targets
				.map( function(el) { return el.twitter_id })
				.filter( function(el) { return $scope.targets.map(function(t){ return t.twitter_screen_name; }).indexOf(el) === -1;  })
				.join(','),
			bios = $scope.raw_targets
				.map( function(el) { return el.bioguide_id })
				.filter( function(el) { return $scope.targets.map(function(t){ return t.bioguide_id; }).indexOf(el) === -1;  })
				.join(',')

		if( sns.length > 1 || bios.length > 1 )  {

			if( $oundoff_config.targets.length > 0 ) params = 'sns='+sns
			else params = 'bio='+bios

			$http.get( '/find_reps?'+params ).success( function(r) { $scope.targets = r; });
		}
	});

	$scope.$watch('message',setCounter);
	$scope.$watch('drop_campaign',setCounter);

	$scope.seeSuggestions = function() {
		suggest.style.display = "block";

		if( isMobile.any() ) setTimeout( function() { window.scroll_to($(suggest).offset().top,0) }, 2)

		return false;
	}
	$scope.setMessage = function(message) {
		$scope.message = message;
		suggest.style.display = "none";
		return false;
	}

	function setCounter() {
		var targets = '.'+$scope.targets_list(),
			tags = $scope.drop_campaign ? [] : [$scope.campaign]

		tags.push('#soundoff')
		tags = tags.join(' ')

		$scope.counter = 140 - [targets,$scope.message,tags].join(' ').length
	}

	// Stage 4
	$scope.default_message
	$scope.url

	if( $oundoff_config.campaign != null )  {
		var target = config.target == 'senate' ? 'Senators' : config.target == 'all' ? 'Reps in Congress' : 'Rep'
		$scope.default_message = 'https://twitter.com/intent/tweet?related=HeadCountOrg&text='
		$scope.default_message += 'I just sent a #SoundOff to my '+target+' about '+$scope.campaign.replace(/\#/g,'%23')+'. Would you hit this link and do it too?'
		if( config.page_url && config.page_url != 'null' ) $scope.url = config.page_url;
		else $scope.url = $oundoff_base_domain + '/' + ( $oundoff_config.short_url || '' );
	} else {
		var target = config.target == 'senate' ? 'Senators' : $scope.targets.length > 2 ? 'Reps in Congress' : 'Rep'
		$scope.default_message = 'https://twitter.com/intent/tweet?related=HeadCountOrg&text='
		$scope.default_message += 'I just sent a %23SoundOff to my '+target+'. Hit this link and do it too:'
		$scope.default_message += 'http://www.soundoff.org'
		$scope.url = $oundoff_base_domain
	}

	$scope.twitter_link = function() { return $scope.default_message + $scope.url }
	$scope.facebook_link = function() { return 'http://facebook.com/sharer/sharer.php?u='+$scope.url }

	$scope.$watch('targets',function() {
		if( $oundoff_config.campaign == null && $scope.targets.length > 0) {
			$scope.default_message = 'https://twitter.com/intent/tweet?related=HeadCountOrg&text='
			$scope.default_message += 'I just sent a %23SoundOff to my Rep '+ $scope.targets.map( function(el) { return '@'+el.twitter_id}).join(' ')+'. Do it to and help us %23SoundOff more! '
		}
	})

}
function addGeocoder() {
	angular.element( popup ).scope().$apply( function($scope) {
		$scope.geocoder = new google.maps.Geocoder();
	})
}
if ( window.self === window.top && $oundoff_config.form ) {
	$(document).ready( function() {
		if( isMobile.any() ) {
			document.body.classList.add('noframe')
			$('.mobile').show();
		}
		$('#close').remove();
	})
 	window.onbeforeunload = function(e) {
      return 'Are you sure you want to cancel your SoundOff?';
    };
}
if( $oundoff_config.form ) $(document).on('keydown keyup','textarea', function() {
	var $notice = $('#notice').html('').attr('class',''),
		reps = angular.element(popup).scope().targets.map( function(el) { return '\@'+el.twitter_screen_name }).join('|')

	reps = new RegExp(reps,'i')
 	if( $(this).val().match(reps) ) $notice.addClass('oops').text('You don\'t need to add your reps - we\'ll do that for you') ;
})
