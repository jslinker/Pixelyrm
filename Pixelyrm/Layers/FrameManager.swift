//
//  FrameManager.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 1/1/20.
//  Copyright © 2020 Michael Daniels. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

// TODO: Update to LayerManager? and Change LayerManager to FrameManager or CanvasFrames?
public class FrameManager: ObservableObject { //, Codable {
    
//    // MARK: Codable Keys
//
//    enum Key: String, CodingKey {
//        case canvasLayers = "cl"
//        case size = "s"
//        case activeCanvasIndex = "aci"
//    }
    
    // MARK: Properties
    
    private var drawLayerChangeHandler: AnyCancellable?
    
    @Published private(set) var size: IntSize
    
    @Published private(set) var activeFrame: Int = -1
    
    @Published private(set) var activeCanvasLayer: CanvasLayer!
    
    @Published public var drawLayer: LayerData
    
    var frames: Int {
        return layeredCanvases.first?.layers.count ?? 0
    }
    
    @Published var layeredCanvases: [LayerManager] {
        didSet {
            if activeFrame > frames - 1 {
                updateActiveFrame(0)
            }
        }
    }
    
    @Published var activeCanvasLayers: [CanvasLayer] = []
    
    // MARK: Initializers
    
    init(size: IntSize = .init(width: 32, height: 32)) {
        self.size = size
        let drawLayer = LayerData(size: size)
        let layeredCanvases: [LayerManager] = Array(1...1).map { _ in LayerManager(size: size) }
        self.layeredCanvases = layeredCanvases
        self.drawLayer = drawLayer
        setupDrawLayerWillChangeHandler()
//        updateActiveLayeredCanvas(layeredCanvas: layeredCanvases[0])
        updateActiveCanvas(layer: layeredCanvases[0].layers[0], inLayeredCanvas: layeredCanvases[0])
        updateActiveFrame(0, forceReload: true)
//        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
//            print("Frame: \((self.activeFrame + 1) % self.frames)")
//            self.updateActiveFrame((self.activeFrame + 1) % self.frames)
//        }
    }
    
    func addLayer() {
        layeredCanvases.insert(LayerManager(size: size, frames: frames), at: 0)
        updateActiveFrame(activeFrame, forceReload: true) // TODO: Handle this better
    }
    
    func addFrame() {
        layeredCanvases.forEach { $0.layers.append(CanvasLayer(size: size)) }
        updateActiveFrame(activeFrame, forceReload: true) // TODO: Handle this better
    }
    
    func updateActiveFrame(_ frame: Int, forceReload: Bool = false) {
        guard forceReload || activeFrame != frame else { return }
        activeFrame = frame
        activeCanvasLayers = layeredCanvases.reversed().map { $0.layers[frame] }
    }
    
//    init(size: IntSize, layeredCanvases: [LayerManager], activeLayeredCanvasIndex: Int, activeCanvasIndex: Int) {
//        self.size = size
//        self.layeredCanvases = layeredCanvases
//        self.drawLayer = LayerData(size: size)
//        setupDrawLayerWillChangeHandler()
//        updateActiveLayeredCanvas(layeredCanvas: layeredCanvases[0])
//        updateActiveCanvas(layer: activeLayeredCanvas.layers[0])
//    }
    
//    // MARK: Codable
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: Key.self)
//        try container.encode(layers, forKey: .canvasLayers)
//        try container.encode(size, forKey: .size)
//        let activeCanvasLayerIndex = layers.firstIndex(of: activeCanvasLayer) ?? 0
//        try container.encode(activeCanvasLayerIndex, forKey: .activeCanvasIndex)
//    }
//
//    required public convenience init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: Key.self)
//        let layers = try container.decode([CanvasLayer].self, forKey: .canvasLayers)
//        let size = try container.decode(IntSize.self, forKey: .size)
//        let activeCanvasIndex = try container.decode(Int.self, forKey: .activeCanvasIndex)
//        self.init(size: size, layers: layers, activeCanvasIndex: activeCanvasIndex)
//    }
    
    // MARK: Methods
    
    public func prepareForNewFrameManager() {
        objectWillChange.send()
        for layeredCanvas in layeredCanvases {
            layeredCanvas.objectWillChange.send()
        }
    }
    
//    public func updateActiveLayeredCanvas(layeredCanvas: LayerManager) {
//        guard activeLayeredCanvas != layeredCanvas else { return }
////        activeLayeredCanvas?.drawLayer = nil
//        activeLayeredCanvas = layeredCanvas
////        activeCanvasLayer.drawLayer = drawLayer // Moves the draw layer to the active canvas
//    }
    
    public func updateActiveCanvas(layer: CanvasLayer, inLayeredCanvas layeredCanvas: LayerManager) {
        guard let frame = layeredCanvas.layers.firstIndex(of: layer) else { fatalError("Failed to get frame for layer") }
        updateActiveFrame(frame)
        activeCanvasLayer?.drawLayer = nil
        activeCanvasLayer = layer
        activeCanvasLayer.drawLayer = drawLayer // Moves the draw layer to the active canvas
    }
    
    private func setupDrawLayerWillChangeHandler() {
        drawLayerChangeHandler = drawLayer.objectWillChange
            .sink { [weak self] in
                self?.activeCanvasLayer.objectWillChange.send()
        }
    }
    
}

