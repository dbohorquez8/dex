angular.module('dexApp')
  .factory 'Server', ($http, $q) ->
    return get: (url) ->
      deferred = $q.defer()
      $http.jsonp(url)
        .success (data) ->
          deferred.resolve data
          return
      deferred.promise