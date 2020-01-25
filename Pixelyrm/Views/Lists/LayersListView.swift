//
//  LayersListView.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/19/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import SwiftUI

struct LayersListView : View {
    
    @EnvironmentObject var frameManager: FrameManager
    
    private let cellSize: CGSize
    private let layout: GridViewLayout
    
    public init(layout: GridViewLayout, cellSize: CGSize = .init(width: 32, height: 32)) {
        self.layout = layout
        self.cellSize = cellSize
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(frameManager.layeredCanvases.reversed()) { layeredCanvas in
                return GridListView(items: layeredCanvas.layers,
                                    layout: self.layout,
                                    cellSize: self.cellSize,
                                    cellForItem: { layer, _ in
                                        CanvasLayerView(canvasLayer: layer, showsBorder: true, selected: self.frameManager.activeCanvasLayer == layer)
                }, didSelect: { layer, _ in
//                    self.frameManager.updateActiveLayeredCanvas(layeredCanvas: layeredCanvas)
                    self.frameManager.updateActiveCanvas(layer: layer, inLayeredCanvas: layeredCanvas)
                })
            }
        }
    }
    
}
