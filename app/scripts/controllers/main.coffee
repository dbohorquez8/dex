'use strict'

angular.module('dexApp')
  .controller 'MainCtrl', ($scope, $routeParams, $timeout, pokemonService, filterFilter) ->
    init = ->
      pokedexData = pokemonService.getPokedex()
      pokedexData.then (data) ->
        $scope.pokedex = pokemonService.parsePokedexData(data.pokemon)

        pokemonNationalID = (if ($routeParams.pokemonID) then parseInt($routeParams.pokemonID) else 0)
        getPokemonData pokemonNationalID if pokemonNationalID > 0
        return
      return

    getPokemonData = (pokemonID) ->
      pokemonData = pokemonService.getPokemon(pokemonID)
      pokemonData.then (data) ->
        pokemon = data
        $scope.pokemon = pokemon

        # Get pokemon's sprite
        $scope.pokemon.image_url = 'images/pokemon-placeholder.png'
        if !_.isEmpty pokemon.sprites
          spriteData = pokemonService.getPokemonImage(pokemon.sprites[0].resource_uri)
          spriteData.then (data) ->
            $scope.pokemon.image_url = 'http://pokeapi.co' + data.image
            # $scope.pokemon.image_url = 'http://www.pkparaiso.com/imagenes/xy/sprites/animados/' + pokemon.name.toLowerCase() + '.gif'
            return

        # Get pokemon's description
        $scope.pokemon.description = ''
        if !_.isEmpty pokemon.descriptions
          descriptionIndex = _.last pokemon.descriptions
          descriptionData = pokemonService.getPokemonDescription(descriptionIndex.resource_uri)
          descriptionData.then (data) ->
            $scope.pokemon.description = data.description
            return

        return

      return

    $scope.$watch 'search', (newValue) ->
      $timeout.cancel timer if timer
      filteredArray = filterFilter($scope.pokedex, newValue)
      if filteredArray
        selectedPokemon = filteredArray[0].remote_id
        timer = ($timeout ->
          if newValue is $scope.search
            $scope.pokemon = getPokemonData(selectedPokemon)
          return
        , 250)
      return


    init()
    return
    

