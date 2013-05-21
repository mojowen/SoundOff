function homePageScope($http, $scope) {

	$scope.mode = 'scoreboard'

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