// Pokemons.swift
// Model for decoding a list of Pokémon names and URLs from the PokeAPI.

import Foundation

struct PokemonList: Codable {
    let results: [NamedAPIResource]
}

struct NamedAPIResource: Codable, Identifiable {
    let name: String
    let url: String
    var id: String { name }
}
