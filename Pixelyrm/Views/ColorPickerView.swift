//
//  ColorPickerView.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/1/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import SwiftUI

struct ColorPickerView : View {
    
    @EnvironmentObject var colorPalette: ColorPalette
    @EnvironmentObject var colorManager: ColorManager
    
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
                 count: self.colorPalette.colors.count,
                 view: { index in
                    return PalettePixel(fillColor: self.colorPalette.colors[index].color,
                                        strokeColor: self.colorManager.primaryColor == self.colorPalette.colors[index] ? .black : self.colorPalette.colors[index].darkerPixel().color,
                                        lineWidth: self.colorManager.primaryColor == self.colorPalette.colors[index] ? 4 : 2)
                        .gesture(TapGesture()
                            .onEnded { _ in
                                self.colorManager.primaryColor = self.colorPalette.colors[index]
                        })
        })
    }
}
