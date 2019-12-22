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
        GridView(layout: layout,
                 verticalPadding: 2,
                 horizontalPadding: 2,
                 cellSize: cellSize,
                 count: self.layerManager.layers.count,
                 view: { index in
                 Button(action: {
                    let layer = self.layerManager.layers[index]
                    self.layerManager.activeCanvasLayer = layer
                 }) {
                    return CanvasLayerView(canvasLayer: self.layerManager.layers[index])
                        .frame(width: self.cellSize.width, height: self.cellSize.height)
                        .background(Color(hue: 0, saturation: 0, brightness: 1, opacity: 0.5))
                        .border(
                            Color(hue: 0, saturation: 0, brightness: 0, opacity: self.layerManager.layers[index] == self.layerManager.activeCanvasLayer ? 0.5 : 0.25),
                            width: self.layerManager.layers[index] == self.layerManager.activeCanvasLayer ? 3 : 1
                    )
                 }
        })
    }
}
