# CSC680-01---Final-Project
CSC 680-01 Final Project - Pokemon Project

● Main Interface: The app's main view (ContentView) displays a list of
Pokémon, showcasing SwiftUI's capabilities in creating a user-friendly
interface.

● Lazy Loading Feature: Implements a lazy loading mechanism for the
Pokémon list, enhancing performance and user experience. It fetches
additional Pokémon data as the user scrolls to the bottom of the list.

● Detailed Pokémon View: A detailed sheet (PokemonDetailSheet) for each
Pokémon, showing more information like stats and types when a Pokémon
is selected.

● Image Carousel: Includes an image carousel in the detail sheet, allowing
users to swipe through various Pokémon sprites.

● Networking and Data Management: Utilizes a dedicated PokemonAPI
class to handle REST API requests, fetching data from the PokeAPI and
managing the responses.

● Async Image Loading with Caching: Implements an AsyncImage view
and ImageLoader class for efficient asynchronous image loading and
caching, reducing load times and improving performance.
