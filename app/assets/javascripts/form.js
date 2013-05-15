function formScope($http, $scope) {

	var config = {
			target: $oundoff_config.target || 'house', // Can also be senate
			campaign: $oundoff_config.campaign || 'Yes on 51',
			email_required: $oundoff_config.email_required || false,
		}

	$scope.campaign = '#'+config.campaign
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
					errors.push( 'missing a zip code')
					zip.className += ' oops'
				}
				if( $scope.email.length < 1 && config.email_required ) {
					errors.push( 'email is required')
					email.className += ' oops'
				}

				if( $scope.targets.length > 0 ) next = 3;
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
					message = [ $scope.targets.map( function(el) { return ' @'+el.twitter_id}), $scope.message,$scope.campaign.replace(/\s/g,''),'#soundoff' ].join(' ')
					window.open('/redirect.html#'+escape(message) );
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
	$scope.ready_for_2 = false

	$scope.sunligh_fetching = false

	$scope.electeds = []
	$scope.targets = $oundoff_config.targets || []
	if( $scope.targets.length > 0 ) $scope.stage = 3
	
	$scope.$watch( 'zip', function(newValue){
		if( typeof newValue != 'undefined' && newValue.length == 5 ) {
				var query = 'http://congress.api.sunlightfoundation.com/legislators/locate?apikey=8fb5671bbea849e0b8f34d622a93b05a&callback=JSON_CALLBACK&zip='+$scope.zip
				$scope.sunligh_fetching = true
				$http.jsonp(query,{})
					.success(function(data,status) { 
						$scope.electeds = data.results;
						var limit = config.target == 'house' ? 1 : 2,
							targets = $scope.electeds.filter( function(el) { return el.chamber == config.target } )

						if( targets.length != limit && typeof google_maps == 'undefined' ) addGoogleMaps(); 
						else $scope.targets = targets;

						$scope.sunligh_fetching = false;
						if( $scope.ready_for_2 ) $scope.nextStage()
					})
		}		
	})

	// Stage 2 - clarfiy location
	$scope.street = ''
	$scope.city = ''
	$scope.latlng = false

	$scope.geocoder = false
	$scope.geocoder_fetching = false
	$scope.ready_for_3 = false

	$scope.$watch( 'city', lookupLatLng )
	$scope.$watch( 'street', lookupLatLng )
	$scope.$watch( 'geocoder', lookupLatLng )
	$scope.$watch( 'latlng', getByLatLng )

	function addGoogleMaps() {
		var script = document.createElement( 'script' ), 
			fjs = document.head.getElementsByTagName('script')[0]
    	script.type = 'text/javascript';
    	script.id = 'google_maps';
    	script.src = 'http://maps.google.com/maps/api/js?sensor=true&callback=addGeocoder';
		fjs.parentNode.insertBefore( script, fjs);
	}

	function lookupLatLng() {
		if( $scope.street != '' && $scope.city != '' && $scope.geocoder ) {
			var address = [$scope.street, $scope.city, $scope.zip].join(' ')
			$scope.geocoder_fetching = true;
			$scope.geocoder.geocode( { 'address': address}, function(results, status) {
				var location = results[0].geometry.location,
					latlng = []
				for( var i in location ) { 
					if( typeof location[i] == 'number' ) latlng.push( location[i] )
				}
				angular.element( document.getElementById('popup') ).scope().$apply( function() {
					$scope.latlng = latlng.sort()
				})
		    });
		}
	}

	function getByLatLng(newValue) {
		if( $scope.latlng ) {
				var query = 'http://congress.api.sunlightfoundation.com/legislators/locate?apikey=8fb5671bbea849e0b8f34d622a93b05a&callback=JSON_CALLBACK&latitude='+$scope.latlng[1]+"&longitude="+$scope.latlng[0]
				$http.jsonp(query,{})
					.success( function(data,status){ 
						$scope.electeds = data.results;
						$scope.targets = $scope.electeds.filter( function(el) { return el.chamber == config.target } )

						$scope.geocoder_fetching = false;
						if( $scope.ready_for_3 ) $scope.nextStage();
				})
		}
	}
	
	// Stage 3
	$scope.message = $oundoff_config.message || ''
	$scope.drop_campaign = $oundoff_config.drop_campaign || false

	$scope.targets_list = function() { return $scope.targets.map( function(el) { return '@'+el.twitter_id }).join(' ') }
	

	$scope.counter = 140
	$scope.$watch('message',setCounter);
	$scope.$watch('drop_campaign',setCounter);
	
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
}



function addGeocoder() {
	angular.element( document.getElementById('popup') ).scope().$apply( function($scope) {
		$scope.geocoder = new google.maps.Geocoder();
	})
}