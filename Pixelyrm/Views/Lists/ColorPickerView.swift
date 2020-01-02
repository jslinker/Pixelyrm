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
        return GridListView(items: colorPalette.colors,
                     layout: layout,
                     cellSize: cellSize,
                     cellForItem: { pixelColor, _ in
                        PalettePixel(fillColor: pixelColor.color,
                                     strokeColor: self.colorManager.primaryColor == pixelColor ? .black : pixelColor.darkerPixel().color,
                        lineWidth: self.colorManager.primaryColor == pixelColor ? 4 : 2)
                            .padding(self.colorManager.primaryColor == pixelColor ? 0 : 0)
        }, didSelect: { color, _ in
            self.colorManager.primaryColor = color
        })
    }
    
}
