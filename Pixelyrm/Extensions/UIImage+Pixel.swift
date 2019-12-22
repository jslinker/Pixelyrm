//
//  UIImage+Pixel.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 6/10/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import UIKit

// MARK: - Additional Variables

extension UIImage {
    
    static let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    static let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
    
    var bounds: CGRect {
        return .init(origin: .zero, size: size)
    }
    
}

extension UIImage {
    
    var pixelArray: [PixelColor] {
        guard let imageRef = cgImage else { fatalError("Failed to get Pixels for a UIImage") }
        var pixelData = [UInt8](repeating: 0, count: Int(size.width * size.height) * 4)
        let context = CGContext(data: &pixelData,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: 8,
                                bytesPerRow: 4 * Int(size.width),
                                space: CGColorSpaceCreateDeviceRGB(),
                                bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue).rawValue)!
        context.draw(imageRef, in: CGRect(origin: .zero, size: size))
        return pixelData.pixelArray
    }

}

// MARK: - Actions

extension UIImage {
    
    func crop(rect: CGRect) -> UIImage {
        return UIImage(cgImage: (self.cgImage!.cropping(to: rect))!)
    }
    
}

// MARK: - Generated Images

extension UIImage {
    
    static var checkerImage: UIImage {
        var pixels: [PixelColor] = [PixelColor](repeating: PixelColor(r:240, g: 240, b: 240), count: 4)
        pixels[0] = PixelColor(r:230, g: 230, b: 230)
        pixels[3] = PixelColor(r:230, g: 230, b: 230)
        do {
            return try pixels.image(size: .init(width: 2, height: 2))
        } catch {
            return UIImage()
        }
    }
    
}
