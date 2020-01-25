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

public class FrameManager: ObservableObject, Codable {
    
    // MARK: Codable Keys

    enum Key: String, CodingKey {
        case layeredCanvases = "lc"
        case size = "s"
        case activeLayeredCanvasIndex = "acli"
        case activeFrameIndex = "afi"
    }
    
    // MARK: Properties
    
    @Published private(set) var size: IntSize
    
    @Published private(set) var activeFrame: Int = 0
    
    @Published private(set) var activeCanvasLayer: CanvasLayer!
    
    @Published public var drawLayer: LayerData
    
    @Published var layeredCanvases: [LayeredCanvas] {
        didSet {
            if activeFrame > frames - 1 {
                updateActive(frame: 0, layeredCanvasIndex: 0)
            }
        }
    }
    
    var frames: Int {
        return layeredCanvases.first?.layers.count ?? 0
    }
    
    weak var historyManager: HistoryManager?
    
    private var activeLayeredCanvasIndex: Int = 0
    
    private var drawLayerChangeHandler: AnyCancellable?
    
    @Published var activeCanvasLayers: [CanvasLayer] = []
    
    // MARK: Initializers
    
    init(size: IntSize = .init(width: 32, height: 32)) {
        self.size = size
        let drawLayer = LayerData(size: size)
        let layeredCanvases: [LayeredCanvas] = Array(1...1).map { _ in LayeredCanvas(size: size) }
        self.layeredCanvases = layeredCanvases
        self.drawLayer = drawLayer
        setupDrawLayerWillChangeHandler()
        updateActiveCanvas(layer: layeredCanvases[0].layers[0], inLayeredCanvas: layeredCanvases[0], forceReload: true)
    }
    
    init(size: IntSize, layeredCanvases: [LayeredCanvas], activeLayeredCanvasIndex: Int, activeFrame: Int) {
        self.size = size
        self.layeredCanvases = layeredCanvases
        self.drawLayer = LayerData(size: size)
        self.activeFrame = activeFrame
        self.activeLayeredCanvasIndex = activeLayeredCanvasIndex
        setupDrawLayerWillChangeHandler()
        updateActiveCanvas(layer: layeredCanvases[activeLayeredCanvasIndex].layers[activeFrame], inLayeredCanvas: layeredCanvases[activeLayeredCanvasIndex], forceReload: true)
    }
    
    // MARK: Codable

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(layeredCanvases, forKey: .layeredCanvases)
        try container.encode(size, forKey: .size)
        try container.encode(activeLayeredCanvasIndex, forKey: .activeLayeredCanvasIndex)
        try container.encode(activeFrame, forKey: .activeFrameIndex)
    }

    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let layeredCanvases = try container.decode([LayeredCanvas].self, forKey: .layeredCanvases)
        let size = try container.decode(IntSize.self, forKey: .size)
        let activeLayeredCanvasIndex = try container.decode(Int.self, forKey: .activeLayeredCanvasIndex)
        let activeFrame = try container.decode(Int.self, forKey: .activeFrameIndex)
        self.init(size: size, layeredCanvases: layeredCanvases, activeLayeredCanvasIndex: activeLayeredCanvasIndex, activeFrame: activeFrame)
    }
    
    // MARK: Methods
    
    func addLayer() {
        layeredCanvases.append(LayeredCanvas(size: size, frames: frames))
        updateActive(frame: activeFrame, layeredCanvasIndex: activeLayeredCanvasIndex, forceReload: true) // TODO: Handle this better
    }
    
    func removeFrameAt(index: Int) {
        // TODO: Handle
    }
    
    func addFrame() {
        layeredCanvases.forEach { $0.layers.append(CanvasLayer(size: size)) }
        updateActive(frame: activeFrame, layeredCanvasIndex: activeLayeredCanvasIndex, forceReload: true) // TODO: Handle this better
    }
    
    private func updateActive(frame: Int, layeredCanvasIndex: Int, forceReload: Bool = false) {
        let newFrame = activeFrame != frame
        let newLayeredCanvas = activeLayeredCanvasIndex != layeredCanvasIndex
        if newFrame || newLayeredCanvas {
            let previousActiveFrame = activeFrame
            let previousActiveLayeredCanvasIndex = activeLayeredCanvasIndex
            print("set    previousActiveFrame: \(previousActiveFrame),    previousActiveLayeredCanvasIndex: \(previousActiveLayeredCanvasIndex)")
            historyManager?.registerUndo(withTarget: self) { [weak self] target in
                guard let myself = self else { return }
                print("previousActiveFrame: \(previousActiveFrame),    previousActiveLayeredCanvasIndex: \(previousActiveLayeredCanvasIndex)")
                myself.updateActiveCanvas(layer: myself.layeredCanvases[previousActiveLayeredCanvasIndex].layers[previousActiveFrame], inLayeredCanvas: myself.layeredCanvases[previousActiveLayeredCanvasIndex], forceReload: true)
            }
        }
        
        if newFrame || forceReload {
            activeFrame = frame
            activeCanvasLayers = layeredCanvases.map { $0.layers[frame] }
        }
        
        activeLayeredCanvasIndex = layeredCanvasIndex
    }
    
    public func prepareForNewFrameManager() {
        objectWillChange.send()
        for layeredCanvas in layeredCanvases {
            layeredCanvas.objectWillChange.send()
        }
    }
    
    public func updateActiveCanvas(layer: CanvasLayer, inLayeredCanvas layeredCanvas: LayeredCanvas) {
        updateActiveCanvas(layer: layer, inLayeredCanvas: layeredCanvas, forceReload: false)
    }
    
    private  func updateActiveCanvas(layer: CanvasLayer, inLayeredCanvas layeredCanvas: LayeredCanvas, forceReload: Bool = false) {
        guard let frame = layeredCanvas.layers.firstIndex(of: layer) else { fatalError("Failed to get frame for layer") }
        guard let activeLayeredCanvasIndex = layeredCanvases.firstIndex(of: layeredCanvas) else { fatalError("Failed to get index for layeredCanvas") }
        updateActive(frame: frame, layeredCanvasIndex: activeLayeredCanvasIndex, forceReload: forceReload)
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

