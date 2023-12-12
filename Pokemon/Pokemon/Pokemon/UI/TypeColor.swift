// TypeColor.swift
// Utility struct providing a mapping of Pokémon types to corresponding colors.

import SwiftUI

struct TypeColor {
    static let colors: [String: Color] = [
        "normal": .gray,
        "fire": .red,
        "water": .blue,
        "electric": .yellow,
        "grass": .green,
        "ice": .cyan,
        "fighting": .orange,
        "poison": .purple,
        "ground": .brown,
        "flying": .skyBlue,
        "psychic": .pink,
        "bug": .grassGreen,
        "rock": .lightBrown,
        "ghost": .lightPurple,
        "dragon": .indigo,
        "dark": .black,
        "steel": .steelBlue,
        "fairy": .lightPink
    ]
    
    static func forType(_ type: String) -> Color {
        return colors[type.lowercased()] ?? .black
    }
}

extension Color {
    static let skyBlue = Color(red: 135/255, green: 206/255, blue: 235/255)
    static let grassGreen = Color(red: 173/255, green: 255/255, blue: 47/255)
    static let lightBrown = Color(red: 210/255, green: 180/255, blue: 140/255)
    static let lightPurple = Color(red: 153/255, green: 102/255, blue: 204/255)
    static let steelBlue = Color(red: 70/255, green: 130/255, blue: 180/255)
    static let lightPink = Color(red: 255/255, green: 182/255, blue: 193/255)
}


func randomColor() -> Color {
    return Color(
        red: .random(in: 0...1),
        green: .random(in: 0...1),
        blue: .random(in: 0...1),
        opacity: 1
    )
}
