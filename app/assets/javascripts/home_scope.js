function homePageScope($http, $scope) {

	$scope.mode = 'scoreboard'

	var number = 15,
		hashtags = '%23'+['soundoff'].join('%23')
		query = 'https://search.twitter.com/search.json?q='+hashtags+'&rpp='+number+'&include_entities=false&result_type=recent&callback=JSON_CALLBACK'
	$http.jsonp(query,{})
		.success(function(data,status) {
			for (var i = $scope.campaigns.length - 1; i >= 0; i--) {
				data.results = data.results.map( function(el) { 
					el.text = unescape(el.text)
					el.text = el.text.replace(/\&amp;/g,'&')
					el.created_at = new Date(el.created_at); 
					return el; 
				})
				$scope.campaigns[i].tweets = data.results
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
		
	]
}