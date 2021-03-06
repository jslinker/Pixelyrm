//
//  EraserTool.swift
//  Pixel
//
//  Created by Michael Daniels on 10/9/16.
//  Copyright © 2016 Michael Daniels. All rights reserved.
//

import Foundation
import UIKit

// TODO: Make Eraser Rect/Circle
public class EraserTool: Tool {
    
    public init() {
        super.init(image: .symbol(.eraser),
                   isSelectable: true,
                   clearOnMoved: false,
                   moveToDrawCanvasOnBegin: true,
                   updateFromStart: false,
                   color: .clear)
    }
    
    public override func canDraw(for state: ToolRunState) -> Bool {
        switch state {
        case .begin, .move: return true
        case .end: return false
        }
    }
    
    public override class func pointsToModify(startPoint: IntPoint, endPoint: IntPoint, inPixels pixels: [PixelColor], withSize size: IntSize, selectedColor: PixelColor) -> [IntPoint] {
        return PencilTool.pointsToModify(startPoint: startPoint, endPoint: endPoint, inPixels: pixels, withSize: size, selectedColor: selectedColor)
    }
    
}
