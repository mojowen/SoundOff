function homePageScope($http, $scope) {

	$scope.mode = 'scoreboard'

	var number = 20,
		hashtags = '%23'+['soundoff'].join('%23')
		query = 'https://search.twitter.com/search.json?q='+hashtags+'&rpp='+number+'&include_entities=false&result_type=recent&callback=JSON_CALLBACK'
	$http.jsonp(query,{})
		.success(function(data,status) {

			for (var i = $scope.campaigns.length - 1; i >= 0; i--) {
				var campaign = $scope.campaigns[i];

				for (var j = 15 - 1; j >= 0; j--) {
					var tweet = {}

					for( var k in data.results[j] ) {
						tweet[k] = data.results[j][k]
					}
					
					tweet.text = unescape( tweet.text)
					tweet.text = tweet.text.replace(/\&amp;/g,'&')
					tweet.text = tweet.text.replace(/\#soundoff/gi,campaign.name.replace(/\s/g,'')+' #SoundOff')
					tweet.created_at = new Date(tweet.created_at); 


					$scope.campaigns[i].tweets.push( tweet )
				};
			};
		})
	
	$scope.campaigns = [
		{
			name: '#Yes on 32',
			score: Math.floor( Math.random() * 100),
			description: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
			tweets: []
		},
		{
			name: '#Flouride Now',
			score: Math.floor( Math.random() * 100),
			description: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
			tweets: []
		},
		{
			name: '#Yes on B',
			score: Math.floor( Math.random() * 100),
			description: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
			tweets: []
		},
		{
			name: '#NoKXL',
			score: Math.floor( Math.random() * 100),
			description: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
			tweets: []
		}
		
	].sort( function(a,b) { 
		return a.score > b.score ? -1 : 1
	})
}