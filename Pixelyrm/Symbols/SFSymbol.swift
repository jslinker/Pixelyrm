//
//  SFSymbol.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/26/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Foundation
import SwiftUI

public extension Image {
    static func symbol(_ symbol: SFSymbol, filled: Bool = false) -> Image {
        if filled {
            return symbol.filledImage
        }
        
        return symbol.image
    }
}

public enum SFSymbol: String {
    
    // Menu
    case save = "arrow.down.doc"
    case load = "arrow.up.doc"
    
    // Tools
    case circle = "circle"
    case eraser = "drop.triangle" // TODO: Update to something that makes sense
    case flood = "paintbrush"
    case line = "pencil.and.outline" // TODO: Handle - Doesn't support fill
    case pencil = "pencil.circle"
    case redo = "arrow.uturn.right.circle"
    case rect = "square"
    case undo = "arrow.uturn.left.circle"
    
    private var filled: String {
        return "\(rawValue).fill"
    }
    
    public var image: Image {
        return Image(systemName: rawValue)
    }
    
    public var filledImage: Image {
        return Image(systemName: filled)
    }
    
}
