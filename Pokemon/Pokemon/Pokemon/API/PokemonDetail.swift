// PokemonDetail.swift
// Model for detailed Pokémon data, including stats, abilities, and types.

import Foundation

struct PokemonDetail: Codable, Identifiable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let abilities: [AbilityEntry]
    let sprites: Sprites
    let stats: [StatEntry]
    let types: [TypeEntry]

    struct AbilityEntry: Codable, Hashable {
        let ability: Ability
        let is_hidden: Bool
        let slot: Int

        struct Ability: Codable, Hashable {
            let name: String
            let url: String
        }
    }

    struct Sprites: Codable {
        let back_default: String?
        let back_shiny: String?
        let front_default: String?
        let front_shiny: String?
        let back_female: String?
        let back_shiny_female: String?
        let front_female: String?
        let front_shiny_female: String?
    }

    struct StatEntry: Codable {
        let base_stat: Int
        let effort: Int
        let stat: Stat

        struct Stat: Codable {
            let name: String
            let url: String
        }
    }

    struct TypeEntry: Codable, Hashable {
        let slot: Int
        let type: Type

        struct `Type`: Codable, Hashable {
            let name: String
            let url: String
        }
    }
}
