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

public struct LayerManagerData: Codable {
    
    enum Key: String, CodingKey {
        case canvasLayerData = "cld"
        case size = "s"
        case activeCanvasIndex = "aci"
    }
    
    let size: IntSize
    let layersData: [CanvasLayer]
    let activeCanvasIndex: Int
    
    public init (size: IntSize, layersData: [CanvasLayer], activeCanvasIndex: Int) {
        self.size = size
        self.layersData = layersData
        self.activeCanvasIndex = activeCanvasIndex
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(layersData, forKey: .canvasLayerData)
        try container.encode(size, forKey: .size)
        try container.encode(activeCanvasIndex, forKey: .activeCanvasIndex)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let layersData = try container.decode([CanvasLayer].self, forKey: .canvasLayerData)
        let size = try container.decode(IntSize.self, forKey: .size)
        let activeCanvasIndex = try container.decode(Int.self, forKey: .activeCanvasIndex)
        self.init(size: size, layersData: layersData, activeCanvasIndex: activeCanvasIndex)
    }
    
}

extension LayerManager {
    
    func makeLayerManagerData() -> LayerManagerData {
        return LayerManagerData(size: size, layersData: layers, activeCanvasIndex: layers.firstIndex(of: activeCanvasLayer) ?? 0)
    }
    
}

public class LayerManager: ObservableObject {
    
    // MARK: Properties
    
//    public let objectWillChange = ObservableObjectPublisher() // TODO: Do I need to define this?
    
    private var drawLayerChangeHandler: AnyCancellable?
    
    @Published private(set) var size: IntSize {
        didSet {
            // TODO: Instead of preventing calls can I throttle them instead to only use the latest send change?
            objectWillChange.send() // TODO: Prevent from triggering if others have triggered. EX: Loading new layers
        }
    }
    
    @Published public var activeCanvasLayer: CanvasLayer {
        didSet {
            oldValue.drawLayer = nil
            updateDrawLayerPosition()
        }
    }
    @Published public var drawLayer: LayerData
    
    @Published var layers: [CanvasLayer] {
        didSet {
            guard !layers.contains(activeCanvasLayer) else { return } // Don't change the `activeLayer` if it wasn't removed
            guard let layer = layers.last else { return }
            objectWillChange.send() // TODO: Prevent from triggering if others have triggered. EX: Loading new layers
            activeCanvasLayer = layer
        }
    }
    
    // MARK: Initializers
    
    init(size: IntSize = .init(width: 32, height: 32)) {
        self.size = size
        let drawLayer = LayerData(size: size)
        let layers: [CanvasLayer] = Array(1...12).map { _ in CanvasLayer(size: size) }
        self.layers = layers
        self.activeCanvasLayer = layers.first!
        self.drawLayer = drawLayer
        updateDrawLayerPosition()
    }
    
    init(size: IntSize, layers: [CanvasLayer], activeCanvasIndex: Int) {
        self.size = size
        self.layers = layers
        self.activeCanvasLayer = layers[activeCanvasIndex]
        self.drawLayer = LayerData(size: size)
    }
    
    // MARK: Methods
    
    public func configure(with layerManagerData: LayerManagerData) {
        layers.forEach { $0.objectWillChange.send() } // Needed to refresh existing layer views that are going to be replaced
        let drawLayer = LayerData(size: layerManagerData.size)
        let layers: [CanvasLayer] = layerManagerData.layersData//[]
//        for layer in layerManagerData.layers {
//            let canvas = CanvasLayer(size: layer.layer.size, identifier: layer.identifier)
//            canvas.layer.set(pixels: layer.layer.pixels)
//            layers.append(canvas)
//        }
//        for layer in layerManagerData.layersData {
//            let canvasLayer = CanvasLayer(size: layer.size, identifier: layer.identifier)
//            layers.append(canvasLayer)
//        }
//        let layers: [CanvasLayer] = Array(0..<layerManagerData.layers.count).map { _ in CanvasLayer(size: size) }
//        let layers: [CanvasLayer] = layerManagerData.layers//Array(0..<layerManagerData.layers.count).map { _ in CanvasLayer(size: size) }
//        let colors: [PixelColor] = [.black, .blue, .green, .red, .white, .init(red: 200, green: 200, blue: 0), .init(red: 200, green: 0, blue: 200), .init(red: 200, green: 200, blue: 100)]
//        for index in 0..<layerManagerData.layersData.count {
//            layers[index].layer.set(pixels: layerManagerData.layersData[index].layerData)
//        }
//        for _ in 0...Int.random(in: 0..<layers.count) {
//            var locations: [IntPoint] = []
//            for _ in 0...Int.random(in: 0..<100) {
//                locations.append(IntPoint(x: Int.random(in: 0..<32), y: Int.random(in: 0..<32)))
//            }
//            layers.randomElement()?.layer.set(locations: locations, to: colors.randomElement()!)
//        }
        self.layers = layers
        self.activeCanvasLayer = layers[layerManagerData.activeCanvasIndex]// layers.first!
        self.drawLayer = drawLayer
        updateDrawLayerPosition()
    }
    
    private func updateDrawLayerPosition() {
        objectWillChange.send()
        for layer in layers {
            layer.drawLayer = nil
        }
        
        // Move the draw layer to the active canvas
        activeCanvasLayer.drawLayer = drawLayer
        
        drawLayerChangeHandler?.cancel()
        drawLayerChangeHandler = drawLayer.objectWillChange
            .receive(on: RunLoop.main) // TODO: Does this need to be on the main thread?
            .sink { [weak self] in
                self?.objectWillChange.send() // TODO: Is this needed?
                self?.activeCanvasLayer.objectWillChange.send()
        }
    }
    
}
