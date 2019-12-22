//
//  DrawView.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/21/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import SwiftUI

struct DrawView: View {
    
    @EnvironmentObject var drawManager: DrawManager
    @EnvironmentObject var layerManager: LayerManager
    
    var body: some View {
        ZoomView {
            ZStack {
                ForEach(self.layerManager.layers) { layer in
                    CanvasLayerView(canvasLayer: layer)
                }
                TouchInputView(inputViewHandler: self.drawManager)
            }
            .edgesIgnoringSafeArea(.all)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
}

