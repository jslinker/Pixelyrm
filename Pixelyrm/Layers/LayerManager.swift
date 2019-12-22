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

public class LayerManager: ObservableObject {
    
    public let objectWillChange = ObservableObjectPublisher()
    
    private var drawLayerChangeHandler: AnyCancellable?
    
    @Published private(set) var size: IntSize {
        didSet {
            objectWillChange.send()
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
            activeCanvasLayer = layer
            objectWillChange.send()
        }
    }
    
    init(size: IntSize = .init(width: 32, height: 32)) {
        self.size = size
        let drawLayer = LayerData(size: size)
        let layers: [CanvasLayer] = Array(1...12).map { _ in CanvasLayer(size: size) }
        self.layers = layers
        self.activeCanvasLayer = layers.first!
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
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.activeCanvasLayer.objectWillChange.send()
        }
    }
    
}
