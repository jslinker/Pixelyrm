//
//  LayersListView.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/19/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import SwiftUI

struct LayersListView : View {
    
    @EnvironmentObject var layerManager: LayerManager
    
    private let cellSize: CGSize
    private let layout: GridViewLayout
    
    public init(layout: GridViewLayout, cellSize: CGSize = .init(width: 32, height: 32)) {
        self.layout = layout
        self.cellSize = cellSize
    }
    
    var body: some View {
        return GridListView(items: layerManager.layers,
                     layout: layout,
                     cellSize: cellSize,
                     cellForItem: { layer, _ in
                        CanvasLayerView(canvasLayer: layer, showsBorder: true, selected: self.layerManager.activeCanvasLayer == layer)
        }, didSelect: { layer, _ in
            self.layerManager.updateActiveCanvas(layer: layer)
        })
    }
    
}
