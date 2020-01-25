//
//  CircleOutlineTool.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/18/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Foundation
import SwiftUI

public class CircleOutlineTool: Tool {
    
    public init() {
        super.init(image: .symbol(.circle),
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
        // TODO: Create oval tool so the user can create a oval between the start and end point
        return []
    }
    
}
