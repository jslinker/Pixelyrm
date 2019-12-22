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
    return PixelColor(a: lhs.a + rhs.a, r: lhs.r + rhs.r, g: lhs.g + rhs.g, b: lhs.b + rhs.b)
}

func -(lhs: PixelColor, rhs: PixelColor) -> PixelColor {
    return PixelColor(a: lhs.a - rhs.a, r: lhs.r - rhs.r, g: lhs.g - rhs.g, b: lhs.b - rhs.b)
}

extension PixelColor: Identifiable {
    public var id: UInt {
        return intValue
    }
}

// TODO: Store hash value on init and when the value changes so equality checks are faster
// TODO: Look into making the pixel data a UInt32 so comparisons are faster?
public struct PixelColor: Hashable, Equatable {
    
    var a: UInt8
    var r: UInt8
    var g: UInt8
    var b: UInt8
    
    public init(a: UInt8 = 255, r: UInt8, g: UInt8, b: UInt8) {
        self.a = a
        self.r = r
        self.g = g
        self.b = b
    }
    
    public init(r: UInt8, g: UInt8, b: UInt8) {
        self.init(a: 255, r: r, g: g, b: b)
    }
    
//    var hashValue: Int { get { return a.hashValue ^ r.hashValue ^ g.hashValue ^ b.hashValue } }
    
    var intValue: UInt {
        return (UInt(a) << 24) | (UInt(r) << 16) | (UInt(b) << 8) | UInt(g)
    }
    
}

extension PixelColor {
    
    static var clear: PixelColor { .init(a: 0, r: 0, g: 0, b: 0) }
    static var white: PixelColor { .init(r: 255, g: 255, b: 255) }
    static var black: PixelColor { .init(r: 0, g: 0, b: 0) }
    static var red: PixelColor { .init(r: 255, g: 0, b: 0) }
    static var green: PixelColor { .init(r: 0, g: 255, b: 0) }
    static var blue: PixelColor { .init(r: 0, g: 0, b: 255) }
    
    var color: Color {
        return Color(red: Double(r) / 255.0, green: Double(g) / 255.0, blue: Double(b) / 255.0).opacity(Double(a) / 255.0)
    }
    
}
