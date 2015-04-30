puckbynumbers = angular.module('puckbynumbers', [
  'templates',
  'ngRoute',
  'ngResource',
  'controllers',
])

puckbynumbers.config([ '$routeProvider',
  ($routeProvider) ->
    $routeProvider
      .when('/',
        templateUrl: 'index.html'
        controller: 'GamesController'
      )
])

controllers = angular.module('controllers', [])
controllers.controller('GamesController', [ '$scope', '$routeParams', '$location', '$resource'
  ($scope,$routeParams,$location,$resource) ->
    $scope.search = (q) -> $location.path("/").search('q', q)
    Game = $resource('/games/:gameId', { gameId: "@id", format: 'json' })

    if $routeParams.q
      Game.query(q: $routeParams.q, (results) -> $scope.games = results)
    else
      $scope.games = []
])


#  vim: set ts=8 sw=2 tw=0 et :
