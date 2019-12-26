//
//  PencilTool.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 6/18/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Foundation
import UIKit

extension PencilTool: ToolDisplayable {
    static let toolDisplayableImage: UIImage.AssetName = .pencil
}

class PencilTool: Tool, ToolProtocol {
    
    let clearOnMoved: Bool = false
    let moveToDrawCanvasOnBegin: Bool = true
    let updateFromStart: Bool = false
    
    func canDraw(for state: ToolRunState) -> Bool {
        switch state {
        case .begin, .move: return true
        case .end: return false
        }
    }
    
    static func pointsToModify(startPoint: IntPoint, endPoint: IntPoint, inPixels pixels: [PixelColor], withSize size: IntSize, selectedColor: PixelColor) -> [IntPoint] {
        return LineTool.lineBresenham(startPoint: startPoint, endPoint: endPoint)
    }
    
}
