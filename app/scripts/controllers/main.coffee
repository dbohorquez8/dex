'use strict'

angular.module('dexApp')
  .controller 'MainCtrl', ($scope, $routeParams, $timeout, pokemonService, filterFilter) ->
    init = ->
      pokedexData = pokemonService.getPokedex()
      pokedexData.then (data) ->
        $scope.pokedex = pokemonService.parsePokedexData(data.pokemon)

        pokemonNationalID = (if ($routeParams.pokemonID) then parseInt($routeParams.pokemonID) else 1)
        getPokemonData pokemonNationalID if pokemonNationalID > 0
        return
      return

    getPokemonData = (pokemonID) ->
      pokemonData = pokemonService.getPokemon(pokemonID)
      pokemonData.then (data) ->
        pokemon = data
        $scope.pokemon = pokemon

        setPokemonImage(pokemon, $scope.pokemon)
        setPokemonDescription(pokemon, $scope.pokemon)
        setEvolutionLine(pokemon, $scope.pokemon)

        console.log $scope.pokemon.evolutions

        # Calculate total stats
        $scope.pokemon.total =  $scope.pokemon.hp + $scope.pokemon.attack +
                                $scope.pokemon.defense + $scope.pokemon.sp_atk +
                                $scope.pokemon.sp_def + $scope.pokemon.speed

        return

      return

    setPokemonImage = (pokemon, scope) ->
      scope.image_url = 'images/sprites/' + pokemon.name.toLowerCase() + '.gif'
      scope.image_url = 'images/pokemon-placeholder.png'
      if !_.isEmpty pokemon.sprites
        spriteData = pokemonService.getPokemonImage(pokemon.sprites[0].resource_uri)
        spriteData.then (data) ->
          scope.image_url = 'http://pokeapi.co' + data.image
          return
      return

    setPokemonDescription = (pokemon, scope) ->
      scope.description = ''
      if !_.isEmpty pokemon.descriptions
        descriptionIndex = _.last pokemon.descriptions
        descriptionData = pokemonService.getPokemonDescription(descriptionIndex.resource_uri)
        descriptionData.then (data) ->
          scope.description = data.description
          return


    setEvolutionLine = (pokemon, scope) ->
      evolutions = []
      if !_.isEmpty pokemon.evolutions
        for evolution in pokemon.evolutions
          evolution.description = 'Evolves to <strong>' + evolution.to + '</strong>'
          switch evolution.method
            when 'level_up'
              evolution.description += ' starting at <strong>Level ' + evolution.level + '</strong>'
            when 'trade'
              evolution.description += ' when <strong>Traded</strong>'
            when 'stone'
              evolution.description += ' when is exposed to a <strong>Stone</strong>'
            when 'other'
              evolution.description += ' by <strong>' + evolution.detail + '</strong>'
          evolutions.push evolution
      scope.evolutions = evolutions
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
    

