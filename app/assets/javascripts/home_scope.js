function homePageScope($http, $scope) {

	$scope.mode = 'scoreboard'

	// Reps
	$scope.raw_reps = $oundoff_config.raw_reps
	$scope.reps = function() {
		var search = $scope.search.toLowerCase().replace(/(\#|\@)/g,'');
		if( $scope.mode.toLowerCase() == 'reps' )  return $scope.raw_reps.filter( function(el) {
			if( search.length > 1 && $scope.single_item == null ) {
				return (
					( el.first_name || '').toLowerCase().search( search ) !== -1
					||
					( el.last_nae || '').toLowerCase().search( search ) !== -1
					||
					( el.state_name || '').toLowerCase().search( search ) !== -1
					||
					( el.twitter_screen_name || '').toLowerCase().search( search ) !== -1
					||
					( el.state || '').toLowerCase().search( search ) !== -1
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
 			  	return n+(s[(v-20)%10]||s[v]||s[0]) + ' Congressional District | '+rep.state_name
			}
		} else if( rep.chamber == 'senate' || rep.chamber == 'upper' ) {
			return "Senator | "+rep.state_name
		} else {
			return null
		}
	}

	// Campaigns
	$scope.raw_campaigns = $oundoff_config.raw_campaigns
	$scope.raw_campaigns.sort( function(a,b) { return a.score > b.score ? -1 : 1 });
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

	// Tweets
	$scope.raw_tweets = [];

	var hashtags = $scope.raw_campaigns.map(function(el) { return el.hashtag.replace(/\#/,'').toLowerCase()}),
		mentions = $scope.raw_reps.map(function(el) { return el.twitter_id })
		query = '/statuses?'+['hashtags='+hashtags,'mentions='+mentions].join('&')

	function loadActive(item,offset) {
		var selector = '',
			query = '',
			main = {},
			offset = offset || 0,
			offset_string = "&offset="+offset;

		if( item.constructor == Object ) {
			if( item.tweets.length < item.score ) {
				if( typeof item.hashtag == 'undefined') {
					selector = 'mentions'
					query = item.twitter_id
				} else {
					selector = 'hashtags'
					query = item.hashtag.replace(/\#/,'').toLowerCase()
				}
			}
			main = item
		} else if( item.constructor == Array ) {
			item = item.filter( function(el) { return el.tweets.length < el.score });
			if( item.length == 0 ) return false;
			if( typeof item[0].hashtag == 'undefined') {
				selector = 'mentions'
				query = item.map(function(el) { return el.twitter_id })
			} else {
				selector = 'hashtags'
				query = item.map(function(el) { return el.hashtag.replace(/\#/,'').toLowerCase()})
			}
			main = item[0]
		}
		if( query.length > 0 ) $http.get( '/statuses?'+selector+'='+query+offset_string,{}).success(function(data,status) {
			loadTweets(data);
			if( main.tweets.length < 8 && main.tweets < main.score ) loadActive(main, offset + main.tweets.length );
		})
	}
	function loadTweets(data) {
		var hashtags = $scope.raw_campaigns.map(function(el) { return el.hashtag.replace(/\#/,'').toLowerCase()}),
			mentions = $scope.raw_reps.map(function(el) { return el.twitter_id }),
			ids = $scope.raw_tweets.map( function(el) { return el.tweet_id } )
		for (var i = 0; i < data.length; i++) {
			if( ids.indexOf( data[i].tweet_id ) === -1 ) {
				var tweet = data[i],
					tweet_hashtags = tweet.hashtags.replace(/soundoff,/ig,'').split(','),
					tweet_mentions = tweet.mentions.split(',')

				tweet.mesage = unescape( tweet.message )
				tweet.created_at = new Date( tweet.created_at )

				$scope.raw_tweets.push(tweet);
				ids.push( tweet.tweet_id );

				for (var tag = tweet_hashtags.length - 1; tag >= 0; tag--) {
					var found_campaign = hashtags.indexOf( tweet_hashtags[tag] )
					if( found_campaign !== -1 ) $scope.raw_campaigns[ found_campaign ].tweets.push( tweet )
				};
				for (var tag = tweet_mentions.length - 1; tag >= 0; tag--) {
					var found_rep = mentions.indexOf( tweet_mentions[tag] )
					if( found_rep !== -1 ) $scope.raw_reps[ found_rep ].tweets.push( tweet );

				};
			}

		};
	}
	$scope.loadMore = function(item) {
		loadActive(item)
		var add = ( item.showing || 8 )
		item.showing = add + 8
	}
	$scope.$watch('active',function() {
		if( typeof $scope.active != 'undefined' ) {
			var active_list = $scope.mode.toLowerCase() == 'reps' ? $scope.reps() : $scope.campaigns(),
				position = active_list.indexOf( $scope.active )
			loadActive( active_list.slice(position, position + 3) )
		}
	})

	// Search and items
	$scope.search = ''
	$scope.items = function() {
		if( $scope.mode.toLowerCase() == 'reps' ) return $scope.reps();
		else return $scope.campaigns()
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
									data[i].tweets = $scope.raw_tweets.filter(function(el) { return el.mentions.indexOf(data[i].twitter_id) !== -1  })
									$scope.raw_reps.push( data[i] )
								}
							};
						})
			}
		},250)
	})

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
				default_message += 'I just sent a %23SoundOff to my Rep about '+$scope.single_item.hashtag.replace(/\#/g,'%23')+'. Do it to and help us %23SoundOff more! '
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
		$(menu).removeClass('single')

		$scope.single_item = null
		$scope.active = null

		if( w_width > med_cut_off ) $scope.active = $scope.items()[0]

		try{ history.pushState( {campaign: $scope.items[0] }, 'Sound Off',  '/' ); } catch(e) {}
		if( $(document.body).hasClass('fixed') ) $(logo).attr('src','/assets/SoundOffWhiteBeta.svg')
		document.title = '#SoundOff @ Congress'
	}
	$scope.resetHard = function() {
		$scope.search = ''
		$scope.reset()
	}
	$scope.setState = function(state) {

		if( typeof state == 'object' && state != null ) {

			$scope.raw_reps.unshift( state )


			$scope.search = '@'+state.twitter_screen_name
			$scope.mode = 'reps'
			if( $oundoff_config.open_soundoff ) $oundoff_config.open_soundoff.targets = state.twitter_screen_name

			$scope.single_item = state;
			$scope.active = state;
		}
		loadTweets($oundoff_config.raw_tweets || [] );

		if( typeof state == 'string' ) {
			var found = $scope.raw_campaigns.filter( function(el) { return el.short_url == state; });

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
		if( $oundoff_config.open_soundoff ) {
			openSoundOff( $oundoff_config.open_soundoff )
		}

	}
	$scope.menuClass = function() {
		var style = []
		if( $scope.single_item != null ) style.push('single')
		if( $scope.mode.toLowerCase() == "reps" ) style.push('reps')
		return style.join(' ')
	}
	$scope.$watch('search',function() {
		if( $scope.single_item != null && $scope.search != '@'+$scope.single_item.twitter_screen_name && $scope.search != $scope.single_item.name ) $scope.reset();
		if( w_width > med_cut_off ) $scope.active = $scope.items()[0];
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
				sort = a.score > b.score

			return sort ? -1 : 1
		})
		$scope.resetHard();
	}

	$scope.isActive = function($index,campaign) { return campaign == $scope.active ? 'active' : 'non-active' }
	$scope.isMode = function(mode) { return mode.toLowerCase() == $scope.mode.toLowerCase() ? 'on' : '' }
	$scope.mobileActive = function() {
		return $scope.active != null ? 'mobile_active' : ''
	}
	$scope.mode = 'Scoreboard'

	if( typeof $oundoff_config.single != 'undefined' && $oundoff_config.single != null ) $scope.setState( $oundoff_config.single )
	else {
		$scope.setScoreBoard();
		loadActive( $scope.raw_reps.slice(0,3) );
	}
}