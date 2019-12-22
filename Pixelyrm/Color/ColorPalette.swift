//
//  ColorPalette.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/1/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Combine
import Foundation

class ColorPalette: ObservableObject {
    
    @Published var colors: [PixelColor]  = [PixelColor]()
    
    init() {
        colors = [PixelColor(r: 50, g: 50, b: 50), PixelColor(r: 200, g: 200, b: 200), PixelColor(r: 200, g: 0, b: 0), PixelColor(r: 0, g: 200, b: 0), PixelColor(r: 0, g: 0, b: 200), PixelColor(r: 200, g: 200, b: 0), PixelColor(r: 0, g: 200, b: 200), PixelColor(r: 200, g: 0, b: 200), PixelColor(r: 150, g: 150, b: 150), PixelColor(r: 100, g: 100, b: 100), PixelColor(r: 100, g: 0, b: 0), PixelColor(r: 0, g: 100, b: 0), PixelColor(r: 0, g: 0, b: 100), PixelColor(r: 100, g: 100, b: 0), PixelColor(r: 0, g: 100, b: 100), PixelColor(r: 100, g: 0, b: 100)]
        
    }
    
}
