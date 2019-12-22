//
//  ToolProtocol.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 6/17/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Foundation

public enum ToolRunState {
    case begin
    case move
    case end
}

public protocol ToolProtocol {
    
    /// Determines if the tool can be selected or not, `didTap()` should still run if this value is false. EX: Use for Undo/Redo
    var isSelectable: Bool { get }
    
    /// Clear the DrawableCavas draw layer every time the tool moves
    var clearOnMoved: Bool { get }
    
    /// Hides the current layer and displays it on the draw canvas
    var moveToDrawCanvasOnBegin: Bool { get }
    
    /// When the tool is updating pixels it'll use its start coordinates instead of the current coordinates
    var updateFromStart: Bool { get }
    
    /// Color provided by the tool if any. EX: Clear for Erasing
    var color: PixelColor? { get }
    
    static func pointsToModify(startPoint: IntPoint, endPoint: IntPoint, inPixels pixels: [PixelColor], withSize size: IntSize, selectedColor: PixelColor) -> [IntPoint]
    
    /// Returns true if a tool should update pixels for a given state
    /// - Parameter state: State the tool should update pixels for
    func canDraw(for state: ToolRunState) -> Bool
    func didTap()
    
}

extension ToolProtocol {
    
    var isSelectable: Bool { true }
    var clearOnMoved: Bool { false }
    var moveToDrawCanvasOnBegin: Bool { false }
    var updateFromStart: Bool { false }
    var color: PixelColor? { return nil }
    
    func canDraw(for state: ToolRunState) -> Bool { return false }
    func didTap() {}
    static func pointsToModify(startPoint: IntPoint, endPoint: IntPoint, inPixels pixels: [PixelColor], withSize size: IntSize, selectedColor: PixelColor) -> [IntPoint] { return [] }
    
}
