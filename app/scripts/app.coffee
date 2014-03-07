'use strict'

angular.module('dexApp', [
  'ngResource',
  'ngRoute',
  'ngSanitize',
  'ui.bootstrap'
  # 'app.directives'
])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .when '/pokemon/:pokemonID',
        templateUrl: 'views/pokemon/show.html'
        controller: 'MainCtrl'
      .otherwise
        redirectTo: '/'


$ ->
  setTimeout (->
    window.scrollTo 0, 1
    return
  ), 0
