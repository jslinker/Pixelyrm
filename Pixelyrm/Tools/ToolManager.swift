//
//  ToolManager.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/2/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Combine
import Foundation
import UIKit
import SwiftUI

extension Tool: Equatable {
    
    public static func == (lhs: Tool, rhs: Tool) -> Bool {
        lhs.id == rhs.id
    }
    
}

extension Tool: Identifiable {
    
    public var id: String { String(describing: self) }
    
}

public class Tool: ObservableObject, ToolProtocol {
    
    public var image: Image // TODO: Make custom images for all tools
    
    public var isSelectable: Bool
    public var clearOnMoved: Bool
    public var moveToDrawCanvasOnBegin: Bool
    public var updateFromStart: Bool
    public var color: PixelColor?
    
    public init(image: Image, isSelectable: Bool = true, clearOnMoved: Bool = false, moveToDrawCanvasOnBegin: Bool = false, updateFromStart: Bool = false, color: PixelColor? = nil) {
        self.image = image
        self.isSelectable = isSelectable
        self.clearOnMoved = clearOnMoved
        self.moveToDrawCanvasOnBegin = moveToDrawCanvasOnBegin
        self.updateFromStart = updateFromStart
        self.color = color
    }
    
    public func canDraw(for state: ToolRunState) -> Bool { return false }
    public func didTap() {}
    public class func pointsToModify(startPoint: IntPoint, endPoint: IntPoint, inPixels pixels: [PixelColor], withSize size: IntSize, selectedColor: PixelColor) -> [IntPoint] { return [] }
    
}

public class ToolManager: ObservableObject {
    
    @Published public var activeTool: Tool
    
    let historyManager: HistoryManager
    let tools: [Tool]
    
    init(historyManager: HistoryManager) {
        self.historyManager = historyManager
        tools = [UndoTool(historyManager: historyManager), RedoTool(historyManager: historyManager), PencilTool(), LineTool(), EraserTool(), EraserFloodTool(), RectangleOutlineTool(), RectangleFillTool(), FloodTool()]
        activeTool = tools.first(where: { $0 is PencilTool })!
    }

    internal var toolPublisher: AnyPublisher<Tool, Never> {
        $activeTool.eraseToAnyPublisher()
    }
    
}
