//
//  RectangleOutlineTool.swift
//  Pixel
//
//  Created by Michael Daniels on 10/9/16.
//  Copyright © 2016 Michael Daniels. All rights reserved.
//

import Foundation
import SwiftUI

class RectangleOutlineTool: Tool {
    
    public init() {
        super.init(image: .symbol(.rect),
                   isSelectable: true,
                   clearOnMoved: true,
                   moveToDrawCanvasOnBegin: false,
                   updateFromStart: true,
                   color: nil)
    }
    
    public override func canDraw(for state: ToolRunState) -> Bool {
        switch state {
        case .begin, .move: return true
        case .end: return false
        }
    }
    
    public override class func pointsToModify(startPoint: IntPoint, endPoint: IntPoint, inPixels pixels: [PixelColor], withSize size: IntSize, selectedColor: PixelColor) -> [IntPoint] {
        let minX = min(startPoint.x, endPoint.x)
        let maxX = max(startPoint.x, endPoint.x)
        let minY = min(startPoint.y, endPoint.y)
        let maxY = max(startPoint.y, endPoint.y)
        var points: [IntPoint] = []
        for y in [minY, maxY] {
            for x in minX...maxX {
                points.append(IntPoint(x: x, y: y))
            }
        }
        for x in [minX, maxX] {
            if minY == maxY {
                points.append(IntPoint(x: x, y: minY))
            } else {
                for y in (minY + 1)..<maxY {
                    points.append(IntPoint(x: x, y: y))
                }
            }
        }
        return points
    }
    
}
