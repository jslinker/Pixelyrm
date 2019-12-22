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

public class LayerData: ObservableObject {
    
    public let objectWillChange = ObservableObjectPublisher()
    
    let identifier: String = UUID().uuidString
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
    
    init(size: IntSize, pixels: [PixelColor]? = nil) {
        self.size = size
        let pixels = pixels ?? [PixelColor](repeating: PixelColor(red: 0, green: 0, blue: 0, alpha: 0), count: size.width * size.height)
        self.pixels = pixels
    }
    
    convenience init(image: UIImage) {
        self.init(size: image.intSize, pixels: image.pixelArray)
        cachedImage = image
    }
    
    public func set(pixels: [PixelColor]) {
        self.pixels = pixels
    }
    
    public func set(locations: [IntPoint], to color: PixelColor) {
        locations.forEach { pixels.set(pixel: color, at: $0, imageSize: size) }
    }
}

extension LayerData: Identifiable {
    public var id: String {
        identifier
    }
}
