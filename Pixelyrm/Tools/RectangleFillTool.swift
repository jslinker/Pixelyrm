//
//  RectangleFillTool.swift
//  Pixel
//
//  Created by Michael Daniels on 10/9/16.
//  Copyright © 2016 Michael Daniels. All rights reserved.
//

import Foundation
import UIKit

extension RectangleFillTool: ToolDisplayable {
    static let toolDisplayableImage: UIImage.AssetName = .square
}

struct RectangleFillTool: ToolProtocol {
    
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
        let minX = min(startPoint.x, endPoint.x)
        let maxX = max(startPoint.x, endPoint.x)
        let minY = min(startPoint.y, endPoint.y)
        let maxY = max(startPoint.y, endPoint.y)
        var points: [IntPoint] = []
        for y in minY...maxY {
            for x in minX...maxX {
                points.append(IntPoint(x: x, y: y))
            }
        }
        return points
    }
    
}
