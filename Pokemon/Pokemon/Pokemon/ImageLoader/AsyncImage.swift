// AsyncImage.swift
// View for asynchronously loading and displaying an image from a URL.

import Foundation
import SwiftUI

struct AsyncImage: View {
    @ObservedObject private var loader: ImageLoader
    private let placeholder: Image

    init(url: URL, placeholder: Image = Image(systemName: "photo")) {
        self.placeholder = placeholder
        loader = ImageLoader(url: url)
    }

    var body: some View {
        image
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }

    private var image: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                placeholder
            }
        }
    }
}
