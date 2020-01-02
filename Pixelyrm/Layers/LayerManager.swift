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

extension LayerManager: Equatable {
    public static func == (lhs: LayerManager, rhs: LayerManager) -> Bool {
        lhs.id == rhs.id
    }
}

extension LayerManager: Identifiable {
    public var id: String {
        return layoutIdentifier
    }
}

// TODO: Update to FrameManager or CanvasFrames? and Change FrameManager to LayerManager?
public class LayerManager: ObservableObject, Codable {
    
    // MARK: Codable Keys
    
    enum Key: String, CodingKey {
        case canvasLayers = "cl"
        case size = "s"
        case activeCanvasIndex = "aci"
    }
    
    // MARK: Properties
    
    @Published private(set) var size: IntSize
    
//    @Published private(set) var activeCanvasLayer: CanvasLayer!
    
//    @Published public var drawLayer: LayerData
    
    @Published var layers: [CanvasLayer]
//        {
//        didSet {
//            guard !layers.contains(activeCanvasLayer) else { return } // Don't change the `activeLayer` if it wasn't removed
//            guard let layer = layers.last else { return }
//            self.updateActiveCanvas(layer: layer)
//        }
//    }
    
    // Needed for displaying with SwiftUI.
    // Would reuse `identifier` but it has issues when creating a new `CanvasLayer` with the same `identifier`
    private let layoutIdentifier: String = UUID().uuidString
    
    private var drawLayerChangeHandler: AnyCancellable?
    
    // MARK: Initializers
    
    init(size: IntSize = .init(width: 32, height: 32), frames: Int = 1) {
        self.size = size
//        let drawLayer = LayerData(size: size)
        let layers: [CanvasLayer] = Array(1...frames).map { _ in CanvasLayer(size: size) }
        self.layers = layers
//        self.drawLayer = drawLayer
//        self.updateActiveCanvas(layer: layers[0])
//        setupDrawLayerWillChangeHandler()
    }
    
    init(size: IntSize, layers: [CanvasLayer]) {
        self.size = size
        self.layers = layers
//        self.drawLayer = LayerData(size: size)
//        self.updateActiveCanvas(layer: layers[activeCanvasIndex])
//        setupDrawLayerWillChangeHandler()
    }
    
    // MARK: Codable
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(layers, forKey: .canvasLayers)
        try container.encode(size, forKey: .size)
//        let activeCanvasLayerIndex = layers.firstIndex(of: activeCanvasLayer) ?? 0
//        try container.encode(activeCanvasLayerIndex, forKey: .activeCanvasIndex)
    }
    
    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let layers = try container.decode([CanvasLayer].self, forKey: .canvasLayers)
        let size = try container.decode(IntSize.self, forKey: .size)
//        let activeCanvasIndex = try container.decode(Int.self, forKey: .activeCanvasIndex)
        self.init(size: size, layers: layers)
    }
    
    // MARK: Methods
    
    public func prepareForNewLayerManager() {
        objectWillChange.send()
//        drawLayer.objectWillChange.send()
        for layer in layers {
            layer.drawLayer = nil // Triggers layer.objectWillChange.send()
        }
    }
    
//    public func updateActiveCanvas(layer: CanvasLayer) {
//        activeCanvasLayer?.drawLayer = nil
//        activeCanvasLayer = layer
//        activeCanvasLayer.drawLayer = drawLayer // Moves the draw layer to the active canvas
//    }
    
//    private func setupDrawLayerWillChangeHandler() {
//        drawLayerChangeHandler = drawLayer.objectWillChange
//            .sink { [weak self] in
//                self?.activeCanvasLayer.objectWillChange.send()
//        }
//    }
    
}
