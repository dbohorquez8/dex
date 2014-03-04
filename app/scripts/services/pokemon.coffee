angular.module('dexApp')
  .service 'pokemonService', (Server) ->
    service = {}

    apiUrl = 'http://pokeapi.co/api/v1/'
    apiCallback = '?callback=JSON_CALLBACK'

    service.getPokedex = ->
      Server.get apiUrl + 'pokedex/1/' + apiCallback

    service.getPokemon = (pokemonID) ->
      Server.get apiUrl + 'pokemon/' + pokemonID + apiCallback

    service.getPokemonImage = (spriteURI) ->
      spriteID = /\/(\d+)\//g.exec(spriteURI)[1]
      Server.get apiUrl + 'sprite/' + spriteID + apiCallback

    service.getPokemonDescription = (descriptionURI) ->
      descriptionID = /\/(\d+)\//g.exec(descriptionURI)[1]
      Server.get apiUrl + 'description/' + descriptionID + apiCallback

    service.parsePokedexData = (data) ->
      pokedex = []
      i = 0

      while i < data.length
        pokemonItem = data[i]
        remoteID = /\/(\d+)\//g.exec(pokemonItem.resource_uri)[1]
        pokemon =
          name: pokemonItem.name
          remote_id: parseInt(remoteID)
          url: '#/pokemon/' + parseInt(remoteID)

        pokedex.push pokemon
        i++
      pokedex.sort (a, b) ->
        return 1  if a.name > b.name
        return -1  if a.name < b.name
        0

      pokedex

    return service