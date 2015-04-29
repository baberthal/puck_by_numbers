@puckbynumbers = angular.module('puckbynumbers', [])

@puckbynumbers.config(['$routeProvider', ($routeProvider) ->
  $routeProvider.
    when('/games', {
      templateUrl: '../templates/restaurants/index.html',
      controller: 'GameIndexCtrl'
    }).
    otherwise({
      templateUrl: '../templates/home.html',
      controller: 'HomeCtrl'
    })
])


#  vim: set ts=8 sw=2 tw=0 et :
