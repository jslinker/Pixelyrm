//
//  Line.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 6/18/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Foundation
import UIKit

// TODO: Add thickness https://saideepdicholkar.blogspot.com/2017/04/bresenhams-line-algorithm-thick-line.html
// https://saideepdicholkar.blogspot.com/2017/02/midpoint-ellipse-algorithm-ellipse.html

extension LineTool: ToolDisplayable {
    static let toolDisplayableImage: UIImage.AssetName = .line
}

struct LineTool: ToolProtocol {
    
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
        return LineTool.lineBresenham(startPoint: startPoint, endPoint: endPoint)
    }

    // TODO: Where is this algorithm from?
    static func lineBresenham(startPoint: IntPoint, endPoint: IntPoint) -> [IntPoint] {
        var x1 = startPoint.x
        var y1 = startPoint.y
        let x2 = endPoint.x
        let y2 = endPoint.y
        var dy = y2 - y1
        var dx = x2 - x1
        var stepX: Int
        var stepY: Int
        
        if dy < 0 {
            dy = -dy
            stepY = -1
        } else {
            stepY = 1
        }
        
        if dx < 0 {
            dx = -dx
            stepX = -1
        } else {
            stepX = 1
        }
        
        dx <<= 1 // 2dx
        dy <<= 1 // 2dy
        
        var points: [IntPoint] = []
        points.append(IntPoint(x: x1, y: y1))
        
        if dx > dy {
            var fraction = dy - (dx >> 1) // dy - dx/2
            while x1 != x2 {
                if fraction >= 0 {
                    y1 += stepY
                    fraction -= dx
                }
                x1 += stepX
                fraction += dy
                points.append(IntPoint(x: x1, y: y1))
            }
        } else {
            var fraction = dx - (dy >> 1) // dx - dy/2
            while y1 != y2 {
                if fraction >= 0 {
                    x1 += stepX
                    fraction -= dy
                }
                y1 += stepY
                fraction += dx
                points.append(IntPoint(x: x1, y: y1))
            }
        }
        
        return points
    }
    
}
