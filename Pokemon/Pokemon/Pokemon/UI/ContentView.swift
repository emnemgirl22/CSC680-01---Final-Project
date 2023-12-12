import SwiftUI

// Defines the main content view of the app.
struct ContentView: View {
    // State variables to manage the dynamic parts of the view.
    @State private var pokemonList = [NamedAPIResource]()   // List of basic Pokémon data.
    @State private var isLoading = false    // Tracks if the app is currently loading more Pokémon.
    @State private var offset = 0           // Offset for pagination of the Pokémon list.
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var selectedPokemonURL: String?      // URL of the selected Pokémon to fetch details.
    @State private var pokemonDetail: PokemonDetail?    // The detailed data of the selected Pokémon.
    @State private var showingDetailSheet = false       // Controls the display of the bottom sheet.

    // The body of the ContentView where the UI is described.
    var body: some View {
        NavigationView {
            List(pokemonList, id: \.name) { pokemon in
                HStack {
                    // Extract the Pokémon ID from the URL and construct the image URL.
                    let pokemonId = pokemon.url.components(separatedBy: "/")[6]
                    let spritesUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemonId).png"
                    AsyncImage(url: URL(string: spritesUrl)!)
                        .frame(width: 75, height: 75)
                    Text(pokemon.name.capitalized).font(.system(size: 24))
                    // Show a progress view when the last item is visible, triggering more data to load.
                    if pokemonList.isLastItem(pokemon) {
                        ProgressView()
                            .onAppear(perform: loadMorePokemon)
                    }
                }
                .onTapGesture {
                    // Set the selected Pokémon URL and fetch its details when tapped.
                    selectedPokemonURL = pokemon.url
                    fetchPokemonDetail()
                }
            }
            // Presents the detail sheet when a Pokémon is selected.
            .sheet(isPresented: Binding<Bool>(
                get: { self.pokemonDetail != nil },
                set: { if !$0 { self.pokemonDetail = nil } }
            )) {
                if let pokemonDetail = pokemonDetail {
                    PokemonDetailSheet(pokemonDetail: pokemonDetail)
                }
            }
            .navigationTitle("Pokémon")         // Sets the title of the navigation bar.
            .onAppear(perform: loadMorePokemon) // Fetches the initial Pokémon data when the view appears.
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    // Function to load more Pokémon data.
    private func loadMorePokemon() {
        guard !isLoading else { return }
        isLoading = true

        // Fetches the list of Pokémon using the API.
        PokemonAPI().fetchPokemonList(offset: offset) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let list):
                    // Updates the offset and appends the new Pokémon to the list.
                    self.offset += list.results.count
                    self.pokemonList.append(contentsOf: list.results)
                case .failure(let error):
                    // Sets the alert message and shows the alert.
                    self.alertMessage = error.localizedDescription
                    self.showAlert = true
                }
                self.isLoading = false
            }
        }
    }
    
    // Fetches the detailed information of a Pokémon.
    private func fetchPokemonDetail() {
        guard let url = selectedPokemonURL else { return }
        // Fetches the details and prefetches images.
        PokemonAPI().fetchPokemonDetail(url: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detail):
                    self.pokemonDetail = detail
                    self.prefetchImages(sprites: detail.sprites)
                    self.showingDetailSheet = true
                case .failure(let error):
                    self.alertMessage = error.localizedDescription
                    self.showAlert = true
                }
            }
        }
    }

    // Pre-fetches all the sprite images for a Pokémon.
    private func prefetchImages(sprites: PokemonDetail.Sprites) {
        let spriteUrls = sprites.all.compactMap { URL(string: $0) }
        spriteUrls.forEach { url in
            ImageLoader(url: url).load()
        }
    }
}

// Extension to help identify if an element is the last in the list, for lazy loading.
extension Array where Element: Identifiable {
    func isLastItem(_ item: Element) -> Bool {
        guard let itemIndex = lastIndex(where: { $0.id == item.id }) else {
            return false
        }
        let thresholdIndex = index(endIndex, offsetBy: -1)
        return itemIndex >= thresholdIndex
    }
}
