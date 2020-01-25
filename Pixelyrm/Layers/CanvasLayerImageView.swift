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
    let showsBorder: Bool
    let showsBackground: Bool
    let selected: Bool
    
    private var borderOpacity: Double {
        guard showsBorder else { return 0 }
        return selected ? 0.5 : 0.1
    }
    
    private var borderWidth: CGFloat {
        guard showsBorder else { return 0 }
        return selected ? 1 : 1
    }
    
    public init (canvasLayer: CanvasLayer, showsBorder: Bool = false, showsBackground: Bool = false, selected: Bool = false) {
        self.canvasLayer = canvasLayer
        self.showsBorder = showsBorder
        self.showsBackground = showsBackground
        self.selected = selected
    }
    
    private func drawView(layer: LayerData?) -> Image? {
        if let drawLayer = layer {
            return Image(uiImage: drawLayer.image)
            .resizable()
            .interpolation(.none)
            .renderingMode(.original)
        }
        
        return nil
    }
    
    // TODO: Find a better way to do this
    private struct Border: ViewModifier {
        let show: Bool
        let borderOpacity: Double
        let borderWidth: CGFloat
        
        func body(content: Content) -> some View {
            if show {
                return AnyView(content
                .border(Color(hue: 0, saturation: 0, brightness: 0, opacity: borderOpacity), width: borderWidth))
            }
            return AnyView(content)
        }
    }
    
    private func backgroundView() -> Color? {
        if self.showsBackground {
            return Color(hue: 0.65, saturation: 0.1, brightness: 1, opacity: 0.5)
        } else {
            return nil
        }
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
        .background(backgroundView())
//        .border(Color(hue: 0, saturation: 0, brightness: 0, opacity: borderOpacity), width: borderWidth)
        .modifier(Border(show: showsBorder, borderOpacity: borderOpacity, borderWidth: borderWidth)) // TODO: Find a better way to do this
    }
    
}
