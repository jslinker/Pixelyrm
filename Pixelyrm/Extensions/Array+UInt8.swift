//
//  Array+UInt8.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 6/10/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Foundation
import UIKit

extension Array where Element == UInt8 {
        
    mutating func set(value: UInt8, at location: IntPoint, imageSize size: IntSize) {
//        guard count > 0 else { return } // TODO: Remove this check for speed?
//        guard location.x >= 0, location.x < size.width, location.y >= 0, location.y < size.height else { return }
        let index: Int = size.width * location.y + location.x
//        if index < 0 || index >= count { return }  // TODO: Remove this check for speed?
        self[index] = value
    }

    func value(at location: IntPoint, imageSize size: IntSize) -> UInt8 {
        let index: Int = size.width * location.y + location.x
        return self[index]
//        if index < 0 || index >= count { return }  // TODO: Remove this check for speed?
    }
    
    func averageOfPoints(_ points: [IntPoint], imageSize size: IntSize) -> UInt8 {
        let values: [Int] = points.map { Int(self.value(at: $0, imageSize: size)) }
        let average: Int = values.reduce(0, +)
        return UInt8(average / values.count)
    }
    
}

extension Array where Element == UInt8 {
    
    var pixelArray: [PixelColor] {
        let count = self.count / MemoryLayout<PixelColor>.size
        let buffer = UnsafePointer(self).withMemoryRebound(to: PixelColor.self, capacity: count) {
            UnsafeBufferPointer(start: $0, count: count)
        }
        return [PixelColor](buffer)
    }
    
}

public protocol ArrayImageConverable {
    /// Multiplier to add up to 32.
    /// EX: UInt8 should be 4
    /// EX: UInt32 should be 1
    var imageConvertableMultiplier: Int { get }
}

extension UInt8: ArrayImageConverable {
    public var imageConvertableMultiplier: Int { 4 }
}

extension PixelColor: ArrayImageConverable {
    public var imageConvertableMultiplier: Int { 1 }
}

extension Array where Element == PixelColor {
    
    public func image(size: IntSize) throws -> UIImage {
        guard let firstItem = first else { throw NSLocalizedString("[ArrayImageConverable] must not be empty", comment: "") }
        guard count == size.width * size.height * firstItem.imageConvertableMultiplier else { throw NSLocalizedString("[ArrayImageConverable] size didn't match the desired image size", comment: "") }
        var data = self
        let providerRef = CGDataProvider(data: NSData(bytes: &data, length: data.count * MemoryLayout<UInt32>.size))
        let cgImage = CGImage(
            width: size.width,
            height: size.height,
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: size.width * MemoryLayout<PixelColor>.size,
            space: UIImage.rgbColorSpace,
            bitmapInfo: UIImage.bitmapInfo,
            provider: providerRef!,
            decode: nil,
            shouldInterpolate: true,
            intent: CGColorRenderingIntent.defaultIntent
        )
        
        if let cgImage = cgImage {
            return UIImage(cgImage: cgImage)
        }
        
        throw NSLocalizedString("Failed to get cgImage from [ArrayImageConverable] of size (\(size.width), \(size.height))", comment: "")
    }
    
}

extension Array where Element == UInt8 {
    
    public func uInt8Image(size: IntSize) throws -> UIImage {
        guard let firstItem = first else { throw NSLocalizedString("[ArrayImageConverable] must not be empty", comment: "") }
        guard count == size.width * size.height * firstItem.imageConvertableMultiplier else { throw NSLocalizedString("[ArrayImageConverable] size didn't match the desired image size", comment: "") }
        var data = self
        let providerRef = CGDataProvider(data: NSData(bytes: &data, length: data.count * MemoryLayout<UInt32>.size))
        let cgImage = CGImage(
            width: size.width,
            height: size.height,
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: size.width * MemoryLayout<PixelColor>.size,
            space: UIImage.rgbColorSpace,
            bitmapInfo: UIImage.bitmapInfo,
            provider: providerRef!,
            decode: nil,
            shouldInterpolate: true,
            intent: CGColorRenderingIntent.defaultIntent
        )
        
        if let cgImage = cgImage {
            return UIImage(cgImage: cgImage)
        }
        
        throw NSLocalizedString("Failed to get cgImage from [ArrayImageConverable] of size (\(size.width), \(size.height))", comment: "")
    }
    
}
