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

function loadIntents() {
	if (document.addEventListener) {
		document.addEventListener('DOMNodeRemoved',removeNode,false)
	} else if (document.attachEvent)  {
		document.attachEvent('DOMNodeRemoved',removeNode)
	}
	twttr.widgets.load()
}

function removeNode(e) {
	if( e.target.nodeName  === 'BLOCKQUOTE' && e.target.className == 'twitter-tweet' ) {
		e.target.parentNode.className += ' tweet_widgetized'
	}
}
