//
//  CircleOutlineTool.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/18/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Foundation
import UIKit

extension CircleOutlineTool: ToolDisplayable {
    static let toolDisplayableImage: UIImage.AssetName = .circle
}

class CircleOutlineTool: Tool, ToolProtocol {
    
    let clearOnMoved: Bool = true
    let moveToDrawCanvasOnBegin: Bool = false
    let updateFromStart: Bool = true
    
    func canDraw(for state: ToolRunState) -> Bool {
        switch state {
        case .begin, .move: return true
        case .end: return false
        }
    }
    
    static func pointsToModify(startPoint: IntPoint, endPoint: IntPoint, inPixels pixels: [PixelColor], withSize size: IntSize, selectedColor: PixelColor) -> [IntPoint] {
        // TODO: Create oval tool so the user can create a oval between the start and end point
        return []
    }
    
}
