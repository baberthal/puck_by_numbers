@puckbynumbers.controller 'RestaurantIndexCtrl', ['$scope', '$location', '$http', ($scope, $location, $http) ->
  $scope.games = []
  $http.get('./games.json').success((data) ->
    $scope.games = data
  )
]
