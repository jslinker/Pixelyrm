//
//  PencilTool.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 6/18/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Foundation
import SwiftUI

public class PencilTool: Tool {
    
    public init() {
        super.init(image: .symbol(.pencil),
                   isSelectable: true,
                   clearOnMoved: false,
                   moveToDrawCanvasOnBegin: true,
                   updateFromStart: false,
                   color: nil)
    }
    
    public override func canDraw(for state: ToolRunState) -> Bool {
        switch state {
        case .begin, .move: return true
        case .end: return false
        }
    }
    
    public override class func pointsToModify(startPoint: IntPoint, endPoint: IntPoint, inPixels pixels: [PixelColor], withSize size: IntSize, selectedColor: PixelColor) -> [IntPoint] {
        return LineTool.lineBresenham(startPoint: startPoint, endPoint: endPoint)
    }
    
}
