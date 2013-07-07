function widgetScope($http,$scope) {

	$scope.tweets = []
	$scope.campaign = $oundoff_config.campaign || 'Yes on B'
	$scope.campaign = '#'+$scope.campaign


	for (var i = 0; i < $oundoff_config.raw_tweets.length; i++) {

		var tweet = {},
			raw_tweet = $oundoff_config.raw_tweets[i],
			data = raw_tweet.data

		for( var k in data ) {
			tweet[k] = data[k]
		}

		tweet.text = unescape( raw_tweet.message )
		tweet.text = tweet.text.replace(/\&amp;/g,'&')
		tweet.created_at = new Date(tweet.created_at);


		$scope.tweets.push( tweet )

	}
}
function resizeButtonText() {
	var scale = window.innerWidth / 14.5
	if( scale < 36 ) button.style.fontSize =  scale+'px'
}
window.onresize = resizeButtonText
window.onload = resizeButtonText
