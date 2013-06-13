function homePageScope($http, $scope) {

	$scope.mode = 'scoreboard'

	// Included reps
	var random_reps = $oundoff_config.random_reps.map( function(el) { el.tweets =[]; return el })

	var number = 50,
		hashtags = '%23'+['soundoff'].join('%23')
	// 	query = 'https://search.twitter.com/search.json?q='+hashtags+'&rpp='+number+'&include_entities=false&result_type=recent&callback=JSON_CALLBACK'
	// $http.jsonp(query,{})
	// 	.success(function(data,status) {

	// 		for (var i = $scope.raw_campaigns.length - 1; i >= 0; i--) {
	// 			var campaign = $scope.raw_campaigns[i],
	// 				raw_tweets = data.results.filter( function(el) { return typeof el != 'undefined' })

	// 			for (var j = 14 - 1; j >= 0; j--) {
	// 				var tweet = {}

	// 				for( var k in raw_tweets[j] ) {
	// 					tweet[k] = raw_tweets[j][k]
	// 				}

	// 				tweet.text = unescape( tweet.text)
	// 				tweet.text = tweet.text.replace(/\&amp;/g,'&')
	// 				tweet.text = tweet.text.replace(/\#soundoff/gi,campaign.name.replace(/\s/g,'')+' #SoundOff')
	// 				tweet.created_at = new Date(tweet.created_at);

	// 				// Give em a false rep
	// 				var random_rep = random_reps[ Math.floor( random_reps.length * Math.random() ) ]
	// 				tweet.text = '@'+random_rep.twitter_screen_name+' '+tweet.text


	// 				$scope.raw_campaigns[i].tweets.push( tweet )
	// 				random_rep.tweets.push( tweet )
	// 			};
	// 		};
	// 	})
	$scope.raw_reps = random_reps
	$scope.reps = function() {
		var search = $scope.search.toLowerCase();
		if( $scope.mode.toLowerCase() == 'reps' )  return $scope.raw_reps.filter( function(el) {
			if( search.length > 1 && $scope.single_item == null ) {
				return (
					el.first_name.toLowerCase().search( search ) !== -1
					||
					el.last_name.toLowerCase().search( search ) !== -1
					||
					el.state.toLowerCase().search( search ) !== -1
					||
					el.twitter_screen_name.toLowerCase().search( search ) !== -1
					||
					el.state_name.toLowerCase().search( search ) !== -1
				)
			} else if ( $scope.single_item != null ) return  el == $scope.single_item
			else return el;
		})
	}
	$scope.longTitle = function(rep) {
		if( rep.chamber == 'house' ) {
			if( rep.district == '0' ) return "Representative  | "+rep.state_name
			else {
				var n = parseInt( rep.district ),
					s=["th","st","nd","rd"],
					v=n%100;
 			  	return n+(s[(v-20)%10]||s[v]||s[0]) + 'Congressional Distriction | '+rep.state_name
			}
		} else {
			return "Senator | "+rep.state_name
		}
	}
	$scope.$watch('search',function() {
		if( typeof fetch != 'undefined' ) clearTimeout( fetch);

		fetch = setTimeout( function() {

			if( $scope.search.length > 1 && $scope.mode.toLowerCase() == 'reps' && $scope.single_item == null ) {

				query = '/find_reps?q='+$scope.search.replace(/\@/g,'')
					$http.get(query,{})
						.success( function(data) {
							$('.messages .loading').hide()
							var reps_twitter_ids = $scope.raw_reps.map( function(el) { return el.twitter_screen_name })
							for (var i = 0; i < data.length; i++) {
								if( reps_twitter_ids.indexOf( data[i].twitter_screen_name ) === -1 ) {
									data[i].tweets = []
									$scope.raw_reps.push( data[i] )
								}
							};
						})
			}
		},250)
	})

	$scope.raw_campaigns = $oundoff_config.raw_campaigns
	$scope.search = ''

	$scope.campaigns = function() {
		var search = $scope.search.toLowerCase();
		if( $scope.mode.toLowerCase() != 'reps' ) return $scope.raw_campaigns.filter( function(el) {
			if( search.length > 1 && $scope.single_item == null ) {
				return (
					el.name.toLowerCase().search( search ) !== -1
					||
					el.description.toLowerCase().search( search ) !== -1
				)
			} else if ( $scope.single_item != null ) return  el == $scope.single_item
			else return el;
		})
	}

	$scope.items = function() {
		if( $scope.mode.toLowerCase() == 'reps' ) return $scope.reps();
		else return $scope.campaigns()
	}

	$scope.single_item =  null;
	$scope.single_url = ''
	$scope.single_twitter = ''
	$scope.single_facebook = ''
	$scope.build_widget = ''
	$scope.$watch('single_item', function() {
		if( $scope.single_item != null  ) {
			var url = $oundoff_base_domain + ($scope.single_item.short_url.slice(0,1) == '/' ? '' : '/') + $scope.single_item.short_url
			$scope.single_url =  url

			$scope.single_facebook =  'http://facebook.com/sharer/sharer.php?u='+url

			if( $scope.mode.toLowerCase() != 'reps')  {
				default_message = 'https://twitter.com/intent/tweet?related=HeadCountOrg&text='
				default_message += 'I just sent a %23SoundOff to my Rep about '+$scope.single_item.name.replace(/\#/g,'%23')+'. Do it to and help us %23SoundOff more! '
				$scope.build_widget =  $oundoff_base_domain + '/widget_create?campaign=' + $scope.single_item.name.replace(/\#/g,'')
			} else {
				default_message = 'https://twitter.com/intent/tweet?related=HeadCountOrg&text='
				default_message += 'I just sent a %23SoundOff to my Rep @'+$scope.single_item.twitter_screen_name+'. Do it to and help us %23SoundOff more! '
				$scope.build_widget =  ''
			}
			$scope.single_twitter =  default_message+url

		}
	})

	$scope.reset = function() {
		scroll_to(0)
		menu.classList.remove('single')

		$scope.single_item = null
		$scope.active = null
		if( w_width > small_cut_off ) $scope.active = $scope.items()[0]
		history.pushState( {campaign: $scope.items[0] }, 'Sound Off',  '/home' );
		$(logo).attr('src','/assets/logo_no_cong.png')
		document.title = '#SoundOff @ Congress'
	}
	$scope.resetHard = function() {
		$scope.search = ''
		$scope.reset()
	}
	$scope.setState = function(state) {
		if( typeof state == 'string' ) {
			var found = $scope.raw_campaigns.filter( function(el) { return el.short_url == state ; });

			if( typeof found[0] != 'undefined' ) {
				$scope.active = found[0];

				$scope.search = found[0].name;
				setTimeout( function() { $scope.single_item = found[0]; },1)
				window.name += 'soundoff_open'
				if( $oundoff_config.open_soundoff ) $oundoff_config.open_soundoff.campaign = found[0].id;
			} else {
				$scope.setScoreBoard();
				$scope.search = state
			}
		}
		if( typeof state == 'object' && state != null ) {
			state.tweets = []
			$scope.raw_reps.push( state )


			$scope.search = '@'+state.twitter_screen_name
			$scope.mode = 'reps'
			if( $oundoff_config.open_soundoff ) $oundoff_config.open_soundoff.targets = state.twitter_screen_name

			setTimeout( function() { $scope.single_item = state; $scope.active = state; },1)
		}
		if( $oundoff_config.open_soundoff ) {
			openSoundOff( $oundoff_config.open_soundoff )
		}

	}

	$scope.$watch('search',function() {
		if( $scope.single_item != null ) $scope.reset();
		if( w_width > small_cut_off ) $scope.active = $scope.items()[0];
	})

	$scope.setScoreBoard = function() {
		$scope.raw_campaigns.sort( function(a,b) {
			return a.score > b.score ? -1 : 1
		});
		$scope.mode = 'Scoreboard'
		if( $scope.single_item != null ) $scope.resetHard();
		else $scope.reset()
	}

	$scope.setMostRecent = function() {
		$scope.raw_campaigns.sort( function(a,b) {
			return a.created_at > b.created_at ? -1 : 1;
		})
		$scope.mode = 'Most Recent'
		if( $scope.single_item != null ) $scope.resetHard();
		else $scope.reset()
	}

	$scope.setReps = function() {
		$scope.mode = 'Reps'
		$scope.raw_reps.sort( function(a,b) {
			var a_length = (a.tweets || '').length,
				b_length = (b.tweets || '').length
			return a_length > b_length ? -1 : 1
		})
		$scope.resetHard();
	}

	$scope.isActive = function($index,campaign) { return campaign == $scope.active ? 'active' : 'non-active' }
	$scope.isMode = function(mode) { return mode.toLowerCase() == $scope.mode.toLowerCase() ? 'on' : '' }
	$scope.mobileActive = function() {
		return $scope.active != null ? 'mobile_active' : ''
	}
	$scope.mode = 'Scoreboard'

	if( typeof $oundoff_config.single != 'undefined' ) $scope.setState( $oundoff_config.single )
	else $scope.setScoreBoard();
}