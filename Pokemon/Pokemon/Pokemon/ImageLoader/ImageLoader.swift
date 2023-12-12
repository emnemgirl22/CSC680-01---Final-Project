// ImageLoader.swift
// Observable class for loading images from URLs with caching capabilities.

import Foundation
import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    static let cache = NSCache<NSString, UIImage>()

    @Published var image: UIImage?
    private var url: URL
    private var cancellable: AnyCancellable?

    init(url: URL) {
        self.url = url
        if let cachedImage = ImageLoader.cache.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
        }
    }

    deinit {
        cancellable?.cancel()
    }

    func load() {
        if let cachedImage = ImageLoader.cache.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] downloadedImage in
                if let self = self, let downloadedImage = downloadedImage {
                    ImageLoader.cache.setObject(downloadedImage, forKey: self.url.absoluteString as NSString)
                    self.image = downloadedImage
                }
            }
    }

    func cancel() {
        cancellable?.cancel()
    }
}
