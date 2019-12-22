//
//  DrawManager.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/17/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Combine
import Foundation

public class DrawManager: ObservableObject {
    
    var activeCanvasLayer: CanvasLayer
    let historyManager: HistoryManager
    var tool: ToolProtocol
    var color: PixelColor
    var drawColor: PixelColor { tool.color ?? color }
    
    private var modifiedPixels: Set<IntPoint> = Set()
    private var canvasStartLocation: IntPoint = .zero
    private var canvasCurrentLocation: IntPoint = .zero
    
    init(historyManager: HistoryManager, activeLayer: CanvasLayer, tool: ToolProtocol, color: PixelColor) {
        self.historyManager = historyManager
        self.activeCanvasLayer = activeLayer
        self.tool = tool
        self.color = color
    }
    
    private func setupUndoForLayer(_ layer: LayerData, inCanvasLayer canvasLayer: CanvasLayer) {
        let pixels = layer.pixels
        historyManager.registerUndo(withTarget: self) { [weak self] target in
            guard let myself = self else { return }
            myself.setupUndoForLayer(layer, inCanvasLayer: canvasLayer)
            canvasLayer.objectWillChange.send()
            layer.set(pixels: pixels)
        }
    }
    
}

extension DrawManager: InputViewHandler {
    
    func touchInputViewController(_ controller: TouchInputUIView, beginTouchAtPoint point: IntPoint) {
        guard let drawLayer = activeCanvasLayer.drawLayer else { return }
        let layer = activeCanvasLayer.layer
        let toolType = type(of: tool)
        
        setupUndoForLayer(layer, inCanvasLayer: activeCanvasLayer)
        
        if tool.moveToDrawCanvasOnBegin {
            drawLayer.set(pixels: layer.pixels)
            layer.isHidden = true // TODO: Should this be set for all tools?
        }
        
        canvasStartLocation = point
        canvasCurrentLocation = point
        if tool.canDraw(for: .begin) {
            let pixelsToModify = toolType.pointsToModify(startPoint: point, endPoint: point, inPixels: layer.pixels, withSize: layer.size, selectedColor: drawColor)
            modifiedPixels.formUnion(pixelsToModify)
            drawLayer.set(locations: pixelsToModify, to: drawColor)
        }
    }
    
    func touchInputViewController(_ controller: TouchInputUIView, movedTouchToPoint point: IntPoint) {
        guard let drawLayer = activeCanvasLayer.drawLayer else { return }
        let toolType = type(of: tool)
        let layer = activeCanvasLayer.layer
        
        if tool.clearOnMoved {
            let clearedPixels = drawLayer.pixels.clearedPixels(at: modifiedPixels, imageSize: drawLayer.size)
            drawLayer.set(pixels: clearedPixels)
            modifiedPixels.removeAll()
        }
        
        if tool.canDraw(for: .move) {
            if tool.updateFromStart {
                let pixelsToModify = toolType.pointsToModify(startPoint: canvasStartLocation, endPoint: point, inPixels: layer.pixels, withSize: layer.size, selectedColor: drawColor)
                modifiedPixels.formUnion(pixelsToModify)
                drawLayer.set(locations: pixelsToModify, to: drawColor)
            } else {
                let pixelsToModify = toolType.pointsToModify(startPoint: canvasCurrentLocation, endPoint: point, inPixels: layer.pixels, withSize: layer.size, selectedColor: drawColor)
                modifiedPixels.formUnion(pixelsToModify)
                drawLayer.set(locations: pixelsToModify, to: drawColor)
            }
        }
        
        canvasCurrentLocation = point
    }
    
    func touchInputViewController(_ controller: TouchInputUIView, endedTouchAtPoint point: IntPoint) {
        guard let drawLayer = activeCanvasLayer.drawLayer else { return }
        let layer = activeCanvasLayer.layer
        
        let drawnPixels = layer.pixels.drawnPixels(at: modifiedPixels, color: drawColor, imageSize: layer.size)
        layer.set(pixels: drawnPixels)
        
        // Clear all pixels on the drawLayer not just the modified ones
        let clearedPixels = drawLayer.pixels.clearedPixels(imageSize: layer.size)
        drawLayer.set(pixels: clearedPixels)
        
        modifiedPixels.removeAll()
        
        layer.isHidden = false
    }
    
}
