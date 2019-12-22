//
//  FloodTool.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/18/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Foundation
import UIKit

extension FloodTool: ToolDisplayable {
    static let toolDisplayableImage: UIImage.AssetName = .circle // TODO: Update
}

struct FloodTool: ToolProtocol {
    
    let clearOnMoved: Bool = false
    let moveToDrawCanvasOnBegin: Bool = true
    let updateFromStart: Bool = false
    
    func canDraw(for state: ToolRunState) -> Bool {
        switch state {
        case .begin, .move: return true
        case .end: return false
        }
    }
    
    // TODO: Optimize this
    // TODO: Convert to C function
    // https://lodev.org/cgtutor/floodfill.html#Recursive_Scanline_Floodfill_Algorithm
    // https://tech.bakkenbaeck.com/post/swift-c-interop
    static func pointsToModify(startPoint: IntPoint, endPoint: IntPoint, inPixels pixels: [PixelColor], withSize size: IntSize, selectedColor: PixelColor) -> [IntPoint] {
        let startColor = pixels.pixel(at: startPoint, imageSize: size)
        guard selectedColor != startColor else { return [] } // Already the correct color
        
        var x = startPoint.x
        var y = startPoint.y
        let width = size.width
        let height = size.height
        
        var stack: [IntPoint] = [startPoint]
        var points: [IntPoint] = []
        var lookedAtPixels: Set<IntPoint> = Set()
        
        while stack.count > 0 {
            guard var nextLocation = stack.popLast() else { break }
            x = nextLocation.x
            y = nextLocation.y
            points.append(nextLocation)
            lookedAtPixels.insert(nextLocation)
            nextLocation = IntPoint(x: x + 1, y: y) // TODO: Instead of using IntPoint use the index, it'll prevent having to create point structs
            if !lookedAtPixels.contains(nextLocation), nextLocation.x < width {
                // TODO: Create method to get a pixel at x, y so it doesn't need to create a IntPoint
                let nextColor = pixels.pixel(at: nextLocation, imageSize: size)
                if startColor == nextColor {
                    stack.append(nextLocation)
                }
            }
            nextLocation = IntPoint(x: x - 1, y: y) // TODO: Instead of using IntPoint use the index, it'll prevent having to create point structs
            if !lookedAtPixels.contains(nextLocation), nextLocation.x >= 0 {
                // TODO: Create method to get a pixel at x, y so it doesn't need to create a IntPoint
                let nextColor = pixels.pixel(at: nextLocation, imageSize: size)
                if startColor == nextColor {
                    stack.append(nextLocation)
                }
            }
            nextLocation = IntPoint(x: x, y: y + 1) // TODO: Instead of using IntPoint use the index, it'll prevent having to create point structs
            if !lookedAtPixels.contains(nextLocation), nextLocation.y < height {
                // TODO: Create method to get a pixel at x, y so it doesn't need to create a IntPoint
                lookedAtPixels.insert(nextLocation)
                let nextColor = pixels.pixel(at: nextLocation, imageSize: size)
                if startColor == nextColor {
                    stack.append(nextLocation)
                }
            }
            nextLocation = IntPoint(x: x, y: y - 1) // TODO: Instead of using IntPoint use the index, it'll prevent having to create point structs
            if !lookedAtPixels.contains(nextLocation), nextLocation.y >= 0 {
                // TODO: Create method to get a pixel at x, y so it doesn't need to create a IntPoint
                let nextColor = pixels.pixel(at: nextLocation, imageSize: size)
                if startColor == nextColor {
                    stack.append(nextLocation)
                }
            }
        }
        
        return points
    }
    
}
