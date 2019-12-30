//
//  CanvasLayer.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/18/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

public struct CanvasLayerData: Codable {
    
    enum Key: String, CodingKey {
        case layerData = "ld"
        case size = "s"
        case identifier = "i"
    }
    
    let size: IntSize
    let layerData: [PixelColor]
    let identifier: String
    
    public init (size: IntSize, layerData: [PixelColor], identifier: String) {
        self.size = size
        self.layerData = layerData
        self.identifier = identifier
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(layerData, forKey: .layerData)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(size, forKey: .size)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let layerData = try container.decode([PixelColor].self, forKey: .layerData)
        let size = try container.decode(IntSize.self, forKey: .size)
        let identifier = try container.decode(String.self, forKey: .identifier)
        self.init(size: size, layerData: layerData, identifier: identifier)
    }
    
}

extension CanvasLayer {
    
    func makeCanvasLayerData() -> CanvasLayerData {
        return CanvasLayerData(size: layer.size, layerData: layer.pixels, identifier: layer.identifier)
    }
    
}

extension CanvasLayer: Equatable {
    public static func == (lhs: CanvasLayer, rhs: CanvasLayer) -> Bool {
        lhs.identifier == rhs.identifier
    }
}

extension CanvasLayer: Identifiable {
    public var id: String {
        return layoutIdentifier
    }
}

// TODO: Revisit live effect layers
public class CanvasLayer: ObservableObject, Codable {
    
    // MARK: Codable Keys
    
    enum Key: String, CodingKey {
        case layerData = "ld"
        case identifier = "id"
    }
    
    // MARK: Properties
    
//    public let objectWillChange = ObservableObjectPublisher()
    
    @Published public var drawLayer: LayerData? {
        willSet {
            objectWillChange.send()
        }
    }
    
//    public var effectLayers: [LayerData] = [] // TODO: Make private and add/remove layers via methods?
    public private(set) var layer: LayerData
    
    // Needed for displaying with SwiftUI.
    // Would reuse `identifier` but it has issues when creating a new `CanvasLayer` witht he same `identifier`
    private let layoutIdentifier: String = UUID().uuidString
    
    let identifier: String
    
    // MARK: Initializers
    
    public init(size: IntSize, identifier: String = UUID().uuidString) {
        layer = LayerData(size: size)
        self.identifier = identifier
    }
    
    private init(layerData: LayerData, identifier: String = UUID().uuidString) {
        layer = layerData
        self.identifier = identifier
    }
    
    func configure(with layerData: CanvasLayerData) {
        // TODO: Find a better way to handle this
        layer = LayerData(size: layerData.size, pixels: layerData.layerData, identifier: layerData.identifier)
//        layer.size = canvasLayerData.size
//        layer.set(pixels: canvasLayerData.layer)
    }
    
    // MARK: Codable
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(layer, forKey: .layerData)
        try container.encode(identifier, forKey: .identifier)
    }

    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let layerData = try container.decode(LayerData.self, forKey: .layerData)
        let identifier = try container.decode(String.self, forKey: .identifier)
        self.init(layerData: layerData, identifier: identifier)
    }
    
}
