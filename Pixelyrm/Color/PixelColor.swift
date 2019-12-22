//
//  Pixel.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 6/10/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Foundation
import SwiftUI

import CoreGraphics

func +(lhs: PixelColor, rhs: PixelColor) -> PixelColor {
    return PixelColor(red: min(255, lhs.red + rhs.red), green: min(255, lhs.green + rhs.green), blue: min(255, lhs.blue + rhs.blue), alpha: min(255, lhs.alpha + rhs.alpha))
}

func -(lhs: PixelColor, rhs: PixelColor) -> PixelColor {
    return PixelColor(red: max(0, lhs.red - rhs.red), green: max(0, lhs.green - rhs.green), blue: max(0, lhs.blue - rhs.blue), alpha: max(0, lhs.alpha - rhs.alpha))
}

extension PixelColor: Identifiable {
    public var id: UInt {
        return intValue
    }
}

// TODO: Store hash value on init and when the value changes so equality checks are faster
// TODO: Look into making the pixel data a UInt32 so comparisons are faster?
public struct PixelColor: Hashable, Equatable {
    
    var alpha: UInt8
    var red: UInt8
    var green: UInt8
    var blue: UInt8
    
    public init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8 = 255) {
        self.alpha = alpha
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    public init(red: UInt8, green: UInt8, blue: UInt8) {
        self.init(red: red, green: green, blue: blue, alpha: 255)
    }
    
    public init(_ pixelColor: PixelColor) {
        self.init(red: pixelColor.red, green: pixelColor.green, blue: pixelColor.blue, alpha: pixelColor.alpha)
    }
    
    public init(_ hexRGB: UInt32) {
        self.init(hexRGB: hexRGB)
    }

    public init(hexRGB: UInt32) {
        self.init(red: UInt8(hexRGB >> 16 & 0xFF), green: UInt8(hexRGB >> 8 & 0xFF), blue: UInt8(hexRGB & 0xFF), alpha: 255)
    }

    public init(hexRGBA: UInt32) {
        self.init(red: UInt8(hexRGBA >> 24 & 0xFF), green: UInt8(hexRGBA >> 16 & 0xFF), blue: UInt8(hexRGBA >> 8 & 0xFF), alpha: UInt8(hexRGBA & 0xFF))
    }
    
    public init(_ hexRGBAString: String) {
        var string: String = hexRGBAString
        if string.hasPrefix("#") {
            string.remove(at: string.startIndex)
        }

        var value:UInt64 = 0
        Scanner(string: string).scanHexInt64(&value)
        
        if string.count == 6 {
            self.init(hexRGB: UInt32(value))
        } else if string.count == 8 {
            self.init(hexRGBA: UInt32(value))
        } else {
            self.init(PixelColor.black)
        }
    }
    
//    var hashValue: Int { get { return a.hashValue ^ r.hashValue ^ g.hashValue ^ b.hashValue } }
    
    var intValue: UInt {
        return (UInt(red) << 24) | (UInt(blue) << 16) | UInt(green) << 8 | (UInt(alpha))
    }
    
}
