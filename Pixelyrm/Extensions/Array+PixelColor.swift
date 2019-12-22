//
//  Array+PixelColor.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/17/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Foundation

extension Array where Element == PixelColor {
    
    mutating func set(pixel: PixelColor, at location: IntPoint, imageSize size: IntSize) {
        guard count > 0 else { return } // TODO: Remove this check for speed?
        let index: Int = size.width * location.y + location.x
        if index < 0 || index >= count { return }  // TODO: Remove this check for speed?
        self[index] = pixel
    }
    
    mutating func set(pixel: PixelColor, atValidLocation location: IntPoint, imageSize size: IntSize) {
//        guard count > 0 else { return } // TODO: Remove this check for speed?
        guard location.x >= 0, location.x < size.width, location.y >= 0, location.y < size.height else { return }
        let index: Int = size.width * location.y + location.x
//        if index < 0 || index >= count { return }  // TODO: Remove this check for speed?
        self[index] = pixel
    }
    
    func pixel(at location: IntPoint, imageSize size: IntSize) -> PixelColor {
        let index: Int = size.width * location.y + location.x
        return self[index]
//        if index < 0 || index >= count { return }  // TODO: Remove this check for speed?
    }
    
    mutating func clearPixels(at locations: Set<IntPoint>, imageSize size: IntSize) {
        locations.forEach { (location) in
            let index: Int = size.width * location.y + location.x
            self[index] = .clear
        }
    }
    
    func clearedPixels(at locations: Set<IntPoint>, imageSize size: IntSize) -> [PixelColor] {
        var pixels = self
        locations.forEach { (location) in
            let index: Int = size.width * location.y + location.x
            pixels[index] = .clear
        }
        return pixels
    }
    
    func clearedPixels(imageSize size: IntSize) -> [PixelColor] {
        return [PixelColor].init(repeating: .clear, count: count)
    }
    
    mutating func drawPixels(at locations: Set<IntPoint>, color pixel: PixelColor, imageSize size: IntSize) {
        locations.forEach { (location) in
            let index: Int = size.width * location.y + location.x
            self[index] = pixel
        }
    }
    
    func drawnPixels(at locations: Set<IntPoint>, color pixel: PixelColor, imageSize size: IntSize) -> [PixelColor] {
        var pixels = self
        locations.forEach { (location) in
            let index: Int = size.width * location.y + location.x
            pixels[index] = pixel
        }
        return pixels
    }
    
}
