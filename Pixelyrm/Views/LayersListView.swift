//
//  LayersListView.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/19/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

struct LayersListView: View {
    
    @EnvironmentObject var layerManager: LayerManager
    let cellSize: CGSize
    
    var body: some View {
        SizeToFitView { _ in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
                    ForEach(self.layerManager.layers) { layer in
                        CanvasLayerView(canvasLayer: layer)
                            .frame(width: self.cellSize.width, height: self.cellSize.height)
                            .background(Color(hue: 0, saturation: 0, brightness: 1, opacity: 0.5))
                            .border(Color(hue: 0, saturation: 0, brightness: 0, opacity: 0.5), width: 1)
                            .gesture(TapGesture()
                                .onEnded { _ in
                                    self.layerManager.activeCanvasLayer = layer
                            })
                    }
                }
            }
        }
    }

}
