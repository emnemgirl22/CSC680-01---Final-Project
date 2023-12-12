import SwiftUI

// The view representing the detail sheet of a selected Pokémon, showcasing an image carousel, stats, abilities, and types.
struct PokemonDetailSheet: View {
    let pokemonDetail: PokemonDetail            // The detailed data for the selected Pokémon.
    @State private var selectedImageIndex = 0   // State to track the currently selected image in the carousel.
    let maxStatValue: CGFloat = 150             // The maximum value for stats to normalize the progress bars.

    var body: some View {
        VStack {
            // Carousel of images represented by a TabView.
            TabView(selection: $selectedImageIndex) {
                // Iterates through all available sprite indices to create image views.
                ForEach(pokemonDetail.sprites.all.indices, id: \.self) { index in
                    // Conditional unwrap of the sprite URL for safe image loading.
                    if let spriteURL = pokemonDetail.sprites.all[index] {
                        AsyncImage(url: URL(string: spriteURL)!)
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .cornerRadius(12)
                            .shadow(radius: 7)
                            .padding()
                            .tag(index) // Tag each image with its index to manage selection state.
                    }
                }
            }
            .frame(height: 300)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always)) // Page style tab view to show dots indicator.
            .onAppear {
                selectedImageIndex = 0 // Reset the image selection when the detail sheet appears.
            }

            // Dots indicator for the image carousel.
            HStack(spacing: 8) {
                // Creates a dot for each image in the carousel.
                ForEach(pokemonDetail.sprites.all.indices, id: \.self) { index in
                    Circle()
                        .fill(index == selectedImageIndex ? Color.blue : Color.gray)
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.top, 8)

            Divider()

            // Display the name of the Pokémon with a larger font.
            Text(pokemonDetail.name.capitalized)
                .font(.largeTitle)

            // Vertical stack for the various attributes of the Pokémon.
            VStack(alignment: .leading, spacing: 10) {
                // Display the height and weight of the Pokémon with headlines.
                HStack {
                    Text("Height:").font(.headline)
                    Spacer()
                    Text("\(pokemonDetail.height)").font(.headline)
                }
                HStack {
                    Text("Weight:").font(.headline)
                    Spacer()
                    Text("\(pokemonDetail.weight)").font(.headline)
                }

                // Display the abilities of the Pokémon using the PillView component.
                HStack {
                    Text("Abilities:").font(.headline)
                    Spacer()
                    ForEach(pokemonDetail.abilities, id: \.ability.name) { ability in
                        PillView(text: ability.ability.name, color: .gray)
                    }
                }

                // Display the types of the Pokémon using the PillView component with corresponding colors.
                HStack {
                    Text("Types:").font(.headline)
                    Spacer()
                    ForEach(pokemonDetail.types, id: \.type.name) { type in
                        PillView(text: type.type.name, color: TypeColor.forType(type.type.name))
                    }
                }

                // Display the stats of the Pokémon as progress bars.
                VStack(alignment: .leading) {
                    Text("Stats").font(.headline)
                    ForEach(pokemonDetail.stats, id: \.stat.name) { stat in
                        StatBarView(statName: stat.stat.name.capitalized, value: stat.base_stat, maxValue: maxStatValue)
                    }
                }
            }
            .padding([.horizontal, .bottom])
        }
        .background(Color.white)
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

// The view representing a stat as a progress bar.
struct StatBarView: View {
    var statName: String    // The name of the stat.
    var value: Int          // The current value of the stat.
    var maxValue: CGFloat   // The maximum value of the stat.

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(statName).font(.body)
                Spacer()
                Text(String(value)).font(.body)
            }
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background capsule representing the unfilled part of the progress bar.
                    Capsule().frame(width: geometry.size.width, height: 8).foregroundColor(Color.gray.opacity(0.2))
                    // Foreground capsule representing the filled part of the progress bar.
                    Capsule().frame(width: (geometry.size.width * CGFloat(value) / maxValue), height: 8).foregroundColor(Color.blue)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// Extension to provide an array of all sprite URLs from the Pokémon detail.
extension PokemonDetail.Sprites {
    var all: [String] {
        // Combines all sprite URLs into a single array, filtering out nil values.
        [
            front_default,
            front_shiny,
            back_default,
            back_shiny,
            front_female,
            front_shiny_female,
            back_female,
            back_shiny_female,
        ]
            .compactMap { $0 }
    }
}
