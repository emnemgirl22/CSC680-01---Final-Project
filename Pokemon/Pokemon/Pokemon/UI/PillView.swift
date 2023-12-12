// PillView.swift
// Reusable view component that displays text within a colored pill-shaped background.

import Foundation
import SwiftUI

struct PillView: View {
    var text: String
    var color: Color

    var body: some View {
        Text(text.capitalized)
            .font(.body)
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color)
            .cornerRadius(20)
    }
}
