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
    let name: String
    
    init(palette: Palette = .nes) {
        self.name = palette.name
        self.colors = palette.pixelColors()
    }
    
}

extension ColorPalette {
    
    enum Palette {
        
        case nes
        case custom(name: String, hexValues: [String])
        
        func hexValues() -> [String] {
            switch self {
            case .nes: return NESPalette.hexValues
            case .custom(_, let hexValues): return hexValues
            }
        }
        
        func pixelColors() -> [PixelColor] {
            return hexValues().map { PixelColor($0) }
        }
        
        var name: String {
            switch self {
            case .nes: return NSLocalizedString("NES", comment: "Name for the NES color palette")
            case .custom(let name, _): return name
            }
        }
        
    }
    
}

private protocol HexPalette {
    
    static var hexValues: [String] { get }
    
}

private struct NESPalette: HexPalette {
    
    static let hexValues: [String] = ["7C7C7C", "BCBCBC", "F8F8F8", "FCFCFC", "0000FC", "0078F8", "3CBCFC", "A4E4FC", "0000BC", "0058F8", "6888FC", "B8B8F8", "4428BC", "6844FC", "9878F8", "D8B8F8", "940084", "D800CC", "F878F8", "F8B8F8", "A80020", "E40058", "F85898", "F8A4C0", "A81000", "F83800", "F87858", "F0D0B0", "881400", "E45C10", "FCA044", "FCE0A8", "503000", "AC7C00", "F8B800", "F8D878", "007800", "00B800", "B8F818", "D8F878", "006800", "00A800", "58D854", "B8F8B8", "005800", "00A844", "58F898", "B8F8D8", "004058", "008888", "00E8D8", "00FCFC", "000000", "787878", "D8D8D8"]
    
}
