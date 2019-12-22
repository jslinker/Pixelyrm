//
//  CanvasLayerImageView.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/15/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import SwiftUI

struct CanvasLayerView: View {
    
    @ObservedObject var canvasLayer: CanvasLayer
    
    func drawView(layer: LayerData?) -> Image? {
        if let drawLayer = layer {
            return Image(uiImage: drawLayer.image)
            .resizable()
            .interpolation(.none)
            .renderingMode(.original)
        }
        
        return nil
    }
    
    var body: some View {
        ZStack {
            Image(uiImage: canvasLayer.layer.image)
                .resizable()
                .interpolation(.none)
                .renderingMode(.original)
                .opacity(canvasLayer.layer.isHidden ? 0 : 1)
            drawView(layer: self.canvasLayer.drawLayer)
        }
    }
    
}
