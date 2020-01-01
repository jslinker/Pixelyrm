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
    
    @Published public var drawLayer: LayerData? {
        willSet {
            objectWillChange.send()
        }
    }
    
//    public var effectLayers: [LayerData] = [] // TODO: Make private and add/remove layers via methods?
    public private(set) var layer: LayerData
    
    // Needed for displaying with SwiftUI.
    // Would reuse `identifier` but it has issues when creating a new `CanvasLayer` with the same `identifier`
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
