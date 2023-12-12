// PokemonAPI.swift
// Networking class responsible for fetching Pokémon data from the PokeAPI.

import Foundation

class PokemonAPI {
    func fetchPokemonList(offset: Int, completion: @escaping (Result<PokemonList, Error>) -> Void) {
        let urlString = "https://pokeapi.co/api/v2/pokemon?offset=\(offset)&limit=20"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let pokemonList = try JSONDecoder().decode(PokemonList.self, from: data)
                completion(.success(pokemonList))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchPokemonDetail(url: String, completion: @escaping (Result<PokemonDetail, Error>) -> Void) {
        guard let url = URL(string: url) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let pokemonDetail = try JSONDecoder().decode(PokemonDetail.self, from: data)
                completion(.success(pokemonDetail))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
