function widgetScope($http,$scope) {

	$scope.tweets = []
	$scope.campaign = $oundoff_config.campaign || 'Yes on B'
	$scope.campaign = '#'+$scope.campaign

	var number = 20,
		hashtags = '%23'+['soundoff'].join('%23')
		query = 'https://search.twitter.com/search.json?q='+hashtags+'&rpp='+number+'&include_entities=false&result_type=recent&callback=JSON_CALLBACK'

	$http.jsonp(query,{})
		.success(function(data,status) {


			for (var j = 15 - 1; j >= 0; j--) {
				var tweet = {}

				for( var k in data.results[j] ) {
					tweet[k] = data.results[j][k]
				}

				tweet.text = unescape( tweet.text)
				tweet.text = tweet.text.replace(/\&amp;/g,'&')
				tweet.text = tweet.text.replace(/\#soundoff/gi,$scope.campaign.replace(/\s/g,'')+' #SoundOff')
				tweet.created_at = new Date(tweet.created_at); 


				$scope.tweets.push( tweet )
			};

		});
}