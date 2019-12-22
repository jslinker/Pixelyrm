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
        return identifier
    }
}

// TODO: Revisit live effect layers
public class CanvasLayer: ObservableObject {
    
    public let objectWillChange = ObservableObjectPublisher()
    
    @Published public var drawLayer: LayerData? {
        willSet {
            objectWillChange.send()
        }
    }
    
    public var effectLayers: [LayerData] = [] // TODO: Make private and add/remove layers via methods?
    public let layer: LayerData
    
    private let identifier: String = UUID().uuidString
    
    public init(size: IntSize) {
        layer = LayerData(size: size)
    }
    
}
