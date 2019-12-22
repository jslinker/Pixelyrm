//
//  PalettePixel.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/4/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Foundation
import SwiftUI

struct PalettePixelContent<Content>: View where Content: View {

    let content: () -> Content
    let fillColor: Color
    let strokeColor: Color
    let lineWidth: CGFloat
    let cornerRadius: CGFloat

    init(fillColor: Color, strokeColor: Color, lineWidth: CGFloat = 2, cornerRadius: CGFloat = 8, @ViewBuilder content: @escaping () -> Content) {
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.lineWidth = lineWidth
        self.cornerRadius = cornerRadius
        self.content = content
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(fillColor)
                .padding(lineWidth / 2)
                .overlay(
                content()
            )
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(strokeColor, lineWidth: lineWidth)
                .padding(lineWidth / 2)
        }
    }

}

struct PalettePixel: View {

    let fillColor: Color
    let strokeColor: Color
    let lineWidth: CGFloat
    let cornerRadius: CGFloat

    init(fillColor: Color, strokeColor: Color, lineWidth: CGFloat = 2, cornerRadius: CGFloat = 8) {
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.lineWidth = lineWidth
        self.cornerRadius = cornerRadius
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(fillColor)
                .padding(lineWidth / 2)
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(strokeColor, lineWidth: lineWidth)
                .padding(lineWidth / 2)
        }
    }

}
