function formScope($http, $scope) {
	var config = {
		targets: 'house', // Can also be senate
		campaign: 'Yes on 51'
	}
	$scope.campaign = '#'+config.campaign
	$scope.stage = config.stage || 1

	$scope.nextStage = function() {
		switch( $scope.stage ) {
			case 1:
				// Need to do something if it's not updating
				if( $scope.targets.length > 0 ) $scope.stage = 3;
				else $scope.stage = 2;
				return false;
			case 2:
				// for some reason this isn't working
				$scope_stage = 3;
				return false;
			case 3:
				// Need to launch twitter
				break;
		}
	}


	// Stage 1
	$scope.zip = ''
	$scope.email = ''
	
	$scope.electeds = []
	$scope.targets = []
	
	$scope.$watch( 'zip', function(newValue){
		if( typeof newValue != 'undefined' && newValue.length == 5 ) {
				var query = 'http://congress.api.sunlightfoundation.com/legislators/locate?apikey=8fb5671bbea849e0b8f34d622a93b05a&callback=JSON_CALLBACK&zip='+$scope.zip
				$http.jsonp(query,{})
					.success(function(data,status) { 
						$scope.electeds = data.results;
						var limit = config.targets == 'house' ? 1 : 2,
							targets = $scope.electeds.filter( function(el) { return el.chamber == config.targets } )

						if( targets.length != limit ) addGoogleMaps(); 
						else $scope.targets = targets;
					})
		}		
	})

	// Stage 2 - clarfiy location
	$scope.street = ''
	$scope.city = ''
	$scope.latlng = false

	$scope.geocoder = false

	$scope.$watch( 'city', lookupLatLng )
	$scope.$watch( 'street', lookupLatLng )
	$scope.$watch( 'geocoder', lookupLatLng )
	$scope.$watch( 'latlng', getByLatLng )

	function addGoogleMaps() {
		var script = document.createElement( 'script' ), 
			fjs = document.head.getElementsByTagName('script')[0]
    	script.type = 'text/javascript';
    	script.src = 'http://maps.google.com/maps/api/js?sensor=true&callback=addGeocoder';
		fjs.parentNode.insertBefore( script, fjs);
	}

	function lookupLatLng() {
		if( $scope.street != '' && $scope.city != '' && $scope.geocoder ) {
			var address = [$scope.street, $scope.city, $scope.zip].join(' ')
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
						$scope.targets = $scope.electeds.filter( function(el) { return el.chamber == config.targets } )
				})
		}
	}
	
	// Stage 3
	$scope.message = ''
	$scope.drop_campaign = false

	$scope.targets_list = function() { return $scope.targets.map( function(el) { return '@'+el.twitter_id }).join(' ') }
	

	$scope.counter = 140
	$scope.$watch('message',setCounter);
	$scope.$watch('drop_campaign',setCounter);

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