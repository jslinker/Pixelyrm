//
//  LayerData.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/15/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Combine
import Foundation
import UIKit

extension LayerData: Equatable {
    public static func == (lhs: LayerData, rhs: LayerData) -> Bool {
        lhs.identifier == rhs.identifier
    }
}

public class LayerData: ObservableObject, Codable {
    
    // MARK: Codable Keys
    
    enum Key: String, CodingKey {
        case data = "d"
        case identifier = "id"
        case size = "s"
    }
    
    // MARK: Properties
    
    public let objectWillChange = ObservableObjectPublisher()
    
    // Needed for displaying with SwiftUI.
    // Would reuse `identifier` but it has issues when creating a new `CanvasLayer` witht he same `identifier`
    private let layoutIdentifier: String = UUID().uuidString
    
    let identifier: String
    let size: IntSize
    var isHidden: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }
    
    private(set) var pixels: [PixelColor] = [] {
        willSet {
            cachedImage = nil
            self.objectWillChange.send()
        }
    }
    
    private var cachedImage: UIImage?
    public var image: UIImage {
        if let cachedImage = cachedImage {
            return cachedImage
        }

        do {
            let image = try pixels.image(size: size)
            cachedImage = image
            return image
        } catch {
            fatalError("Failed to get image from `pixels` array.")
        }
    }
    
    // MARK: Initializers
    
    init(size: IntSize, pixels: [PixelColor]? = nil, identifier: String = UUID().uuidString) {
        self.size = size
        let pixels = pixels ?? [PixelColor](repeating: PixelColor(red: 0, green: 0, blue: 0, alpha: 0), count: size.width * size.height)
        self.pixels = pixels
        self.identifier = identifier
    }
    
    convenience init(image: UIImage, identifier: String = UUID().uuidString) {
        self.init(size: image.intSize, pixels: image.pixelArray, identifier: identifier)
        cachedImage = image
    }
    
    // MARK: Codable
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(pixels, forKey: .data)
        try container.encode(size, forKey: .size)
        try container.encode(identifier, forKey: .identifier)
    }
    
    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let pixelData = try container.decode([PixelColor].self, forKey: .data)
        let size = try container.decode(IntSize.self, forKey: .size)
        let identifier = try container.decode(String.self, forKey: .identifier)
        self.init(size: size, pixels: pixelData, identifier: identifier)
    }
    
    // MARK: Methods
    
    public func set(pixels: [PixelColor]) {
        self.pixels = pixels
    }
    
    public func set(locations: [IntPoint], to color: PixelColor) {
        locations.forEach { pixels.set(pixel: color, at: $0, imageSize: size) }
    }
}

extension LayerData: Identifiable {
    public var id: String {
        layoutIdentifier
    }
}
