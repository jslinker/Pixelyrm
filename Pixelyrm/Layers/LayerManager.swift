//
//  LayerManager.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/15/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

public class LayerManager: ObservableObject, Codable {
    
    // MARK: Codable Keys
    
    enum Key: String, CodingKey {
        case canvasLayers = "cl"
        case size = "s"
        case activeCanvasIndex = "aci"
    }
    
    // MARK: Properties
    
    private var drawLayerChangeHandler: AnyCancellable?
    
    @Published private(set) var size: IntSize
    
    @Published private(set) var activeCanvasLayer: CanvasLayer!
    
    @Published public var drawLayer: LayerData
    
    @Published var layers: [CanvasLayer] {
        didSet {
            guard !layers.contains(activeCanvasLayer) else { return } // Don't change the `activeLayer` if it wasn't removed
            guard let layer = layers.last else { return }
            self.updateActiveCanvas(layer: layer)
        }
    }
    
    // MARK: Initializers
    
    init(size: IntSize = .init(width: 32, height: 32)) {
        self.size = size
        let drawLayer = LayerData(size: size)
        let layers: [CanvasLayer] = Array(1...3).map { _ in CanvasLayer(size: size) }
        self.layers = layers
        self.drawLayer = drawLayer
        self.updateActiveCanvas(layer: layers[0])
        setupDrawLayerWillChangeHandler()
    }
    
    init(size: IntSize, layers: [CanvasLayer], activeCanvasIndex: Int) {
        self.size = size
        self.layers = layers
        self.drawLayer = LayerData(size: size)
        self.updateActiveCanvas(layer: layers[activeCanvasIndex])
        setupDrawLayerWillChangeHandler()
    }
    
    // MARK: Codable
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(layers, forKey: .canvasLayers)
        try container.encode(size, forKey: .size)
        let activeCanvasLayerIndex = layers.firstIndex(of: activeCanvasLayer) ?? 0
        try container.encode(activeCanvasLayerIndex, forKey: .activeCanvasIndex)
    }
    
    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let layers = try container.decode([CanvasLayer].self, forKey: .canvasLayers)
        let size = try container.decode(IntSize.self, forKey: .size)
        let activeCanvasIndex = try container.decode(Int.self, forKey: .activeCanvasIndex)
        self.init(size: size, layers: layers, activeCanvasIndex: activeCanvasIndex)
    }
    
    // MARK: Methods
    
    public func prepareForNewLayerManager() {
        objectWillChange.send()
        drawLayer.objectWillChange.send()
        for layer in layers {
            layer.drawLayer = nil // Triggers layer.objectWillChange.send()
        }
    }
    
    public func updateActiveCanvas(layer: CanvasLayer) {
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
