//
//  LayeredCanvas.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/15/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

extension LayeredCanvas: Equatable {
    public static func == (lhs: LayeredCanvas, rhs: LayeredCanvas) -> Bool {
        lhs.id == rhs.id
    }
}

extension LayeredCanvas: Identifiable {
    public var id: String {
        return layoutIdentifier
    }
}

public class LayeredCanvas: ObservableObject, Codable {
    
    // MARK: Codable Keys
    
    enum Key: String, CodingKey {
        case canvasLayers = "cl"
        case size = "s"
        case activeCanvasIndex = "aci"
    }
    
    // MARK: Properties
    
    @Published private(set) var size: IntSize
    
    @Published var layers: [CanvasLayer]
    
    // Needed for displaying with SwiftUI.
    // Would reuse `identifier` but it has issues when creating a new `CanvasLayer` with the same `identifier`
    private let layoutIdentifier: String = UUID().uuidString
    
    private var drawLayerChangeHandler: AnyCancellable?
    
    // MARK: Initializers
    
    init(size: IntSize = .init(width: 32, height: 32), frames: Int = 1) {
        self.size = size
        let layers: [CanvasLayer] = Array(1...frames).map { _ in CanvasLayer(size: size) }
        self.layers = layers
    }
    
    init(size: IntSize, layers: [CanvasLayer]) {
        self.size = size
        self.layers = layers
    }
    
    // MARK: Codable
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(layers, forKey: .canvasLayers)
        try container.encode(size, forKey: .size)
    }
    
    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let layers = try container.decode([CanvasLayer].self, forKey: .canvasLayers)
        let size = try container.decode(IntSize.self, forKey: .size)
        self.init(size: size, layers: layers)
    }
    
    // MARK: Methods
    
    public func prepareForNewLayerManager() {
        objectWillChange.send()
        for layer in layers {
            layer.drawLayer = nil // Triggers layer.objectWillChange.send()
        }
    }
    
}
