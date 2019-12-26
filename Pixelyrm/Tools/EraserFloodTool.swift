//
//  EraserFloodTool.swift
//  Pixel
//
//  Created by Michael Daniels on 10/9/16.
//  Copyright © 2016 Michael Daniels. All rights reserved.
//

import Foundation
import UIKit

extension EraserFloodTool: ToolDisplayable {
    static let toolDisplayableImage: UIImage.AssetName = .eraser
}

class EraserFloodTool: Tool, ToolProtocol {
    
    let clearOnMoved: Bool = false
    let moveToDrawCanvasOnBegin: Bool = true
    let updateFromStart: Bool = false
    let color: PixelColor? = .clear
    
    func canDraw(for state: ToolRunState) -> Bool {
        switch state {
        case .begin, .move: return true
        case .end: return false
        }
    }
    
    static func pointsToModify(startPoint: IntPoint, endPoint: IntPoint, inPixels pixels: [PixelColor], withSize size: IntSize, selectedColor: PixelColor) -> [IntPoint] {
        return FloodTool.pointsToModify(startPoint: startPoint, endPoint: endPoint, inPixels: pixels, withSize: size, selectedColor: selectedColor)
    }
    
}
