//
//  PixelColor+Colors.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/2/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import CoreGraphics
import Foundation
import SwiftUI

extension PixelColor {
    
    static var clear: PixelColor { .init(red: 0, green: 0, blue: 0, alpha: 0) }
    static var white: PixelColor { .init(red: 255, green: 255, blue: 255) }
    static var black: PixelColor { .init(red: 0, green: 0, blue: 0) }
    static var red: PixelColor { .init(red: 255, green: 0, blue: 0) }
    static var green: PixelColor { .init(red: 0, green: 255, blue: 0) }
    static var blue: PixelColor { .init(red: 0, green: 0, blue: 255) }
    
    var color: Color {
        return Color(red: Double(red) / 255.0, green: Double(green) / 255.0, blue: Double(blue) / 255.0).opacity(Double(alpha) / 255.0)
    }
    
}

extension PixelColor {
    
    // TODO: Update - temp solution
    func lighterPixel() -> PixelColor {
        let (hue, saturationHSV, brightness) = PixelColor.rgbToHSV(red: red, green: green, blue: blue)
        // TODO: Don't clamp at 0/360, needs to wrap
        let (red, green, blue) = PixelColor.hsvToRGB(hue: max(0, hue - 15), saturation: UInt8(min(100, Int(saturationHSV) - 5)), brightness: UInt8(min(100, Int(brightness) - 5)))
        return PixelColor(red: red, green: green, blue: blue)
    }
    
    func darkerPixel() -> PixelColor {
        let (hue, saturationHSV, brightness) = PixelColor.rgbToHSV(red: red, green: green, blue: blue)
        // TODO: Don't clamp at 0/360, needs to wrap
        let (red, green, blue) = PixelColor.hsvToRGB(hue: min(360, hue + 15), saturation: UInt8(max(0, Int(saturationHSV) - 5)), brightness: UInt8(max(0, Int(brightness) - 5)))
        return PixelColor(red: red, green: green, blue: blue)
    }
    
    static func hsvToRGB(hue: CGFloat, saturation: UInt8, brightness: UInt8) -> (red: UInt8, green: UInt8, blue: UInt8) {
        let s = CGFloat(saturation) / 100.0
        let v = CGFloat(brightness) / 100.0
        let c = v * s
        let x = c * (1 - abs((hue / 60).truncatingRemainder(dividingBy: 2) - 1))
        let m = v - c
        var red: CGFloat
        var green: CGFloat
        var blue: CGFloat
        switch hue {
        case 0..<60: (red, green, blue) = (c, x, 0)
        case 60..<120: (red, green, blue) = (x, c, 0)
        case 120..<180: (red, green, blue) = (0, c, x)
        case 180..<240: (red, green, blue) = (0, x, c)
        case 240..<300: (red, green, blue) = (x, 0, c)
        case 300..<360: (red, green, blue) = (c, 0, x)
        default: (red, green, blue) = (0, 0, 0)
        }
        
        return (UInt8(floor((red + m) * 255.0)), UInt8(floor((green + m) * 255.0)), UInt8(floor((blue + m) * 255.0)))
    }
    
    static func rgbToHSV(red: UInt8, green: UInt8, blue: UInt8) -> (hue: CGFloat, saturation: UInt8, value: UInt8) {
        let r = CGFloat(red) / 255.0
        let g = CGFloat(green) / 255.0
        let b = CGFloat(blue) / 255.0
        let cMax = max(r, g, b)
        let cMin = min(r, g, b)
        let delta = cMax - cMin
        var hue: CGFloat
        
        if delta == 0 {
            hue = 0
        } else {
            switch cMax {
            case b: hue = 60 * (((r - g) / delta) + 4)
            case g: hue = 60 * (((b - r) / delta) + 2)
            case r: hue = 60 * (((g - b) / delta).truncatingRemainder(dividingBy: 6))
            default: hue = 0
            }
        }
        let saturation = cMax == 0 ? 0 : delta / cMax
        
        return (ceil(hue), UInt8(ceil(saturation * 100.0)), UInt8(ceil(cMax * 100))) // value = cMax
    }
    
    static func hslToRGB(hue: CGFloat, saturation: UInt8, lightness: UInt8) -> (red: UInt8, green: UInt8, blue: UInt8) {
        let s = CGFloat(saturation) / 100.0
        let l = CGFloat(lightness) / 100.0
        
        let c = s * (1 - abs(l * 2 - 1))
        let x = c * (1 - abs((hue / 60).truncatingRemainder(dividingBy: 2) - 1))
        let m = l - c / 2
        var red: CGFloat
        var green: CGFloat
        var blue: CGFloat
        switch hue {
        case 0..<60: (red, green, blue) = (c, x, 0)
        case 60..<120: (red, green, blue) = (x, c, 0)
        case 120..<180: (red, green, blue) = (0, c, x)
        case 180..<240: (red, green, blue) = (0, x, c)
        case 240..<300: (red, green, blue) = (x, 0, c)
        case 300..<360: (red, green, blue) = (c, 0, x)
        default: (red, green, blue) = (0, 0, 0)
        }
        
        return (UInt8(floor((red + m) * 255.0)), UInt8(floor((green + m) * 255.0)), UInt8(floor((blue + m) * 255.0)))
    }
    
    static func rgbToHSL(red: UInt8, green: UInt8, blue: UInt8) -> (hue: CGFloat, saturation: UInt8, lightness: UInt8) {
        let r = CGFloat(red) / 255.0
        let g = CGFloat(green) / 255.0
        let b = CGFloat(blue) / 255.0
        let cMax = max(r, g, b)
        let cMin = min(r, g, b)
        let delta = cMax - cMin
        var hue: CGFloat
        
        if delta == 0 {
            hue = 0
        } else {
            switch cMax {
            case b: hue = 60 * (((r - g) / delta) + 4)
            case g: hue = 60 * (((b - r) / delta) + 2)
            case r: hue = 60 * (((g - b) / delta).truncatingRemainder(dividingBy: 6))
            default: hue = 0
            }
        }
        let lightness = (cMax + cMin) / 2.0
        let saturation = delta == 0 ? 0 : delta / (1.0 - abs(lightness * 2.0 - 1.0))
        
        return (ceil(hue), UInt8(ceil(saturation * 100.0)), UInt8(ceil(lightness * 100)))
    }
    
    static func rgbToGrayScale(red: UInt8, green: UInt8, blue: UInt8) -> (red: UInt8, green: UInt8, blue: UInt8) {
        let value = ceil(CGFloat(red + green + blue) / 3.0)
        return (UInt8(value), UInt8(value), UInt8(value))
    }
    
}
