//
//  ToolPickerView.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/4/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import SwiftUI

struct ToolPickerView : View {
    
    @EnvironmentObject var toolManager: ToolManager
    
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
                 count: self.toolManager.tools.count,
                 view: { index in
                 Button(action: {
                     let tool = self.toolManager.tools[index]
                     if tool.isSelectable {
                         self.toolManager.activeTool = self.toolManager.tools[index]
                     }
                     tool.didTap()
                 }) {
                     PalettePixelContent(fillColor: self.toolManager.tools[index] == self.toolManager.activeTool ? Color.white : Color.gray,
                                         strokeColor: self.toolManager.tools[index] == self.toolManager.activeTool ? Color.black : Color.gray) {
                                             Image(uiImage: self.toolManager.tools[index].toolImage)
                                                 .resizable()
                                                 .interpolation(.none)
                                                 .renderingMode(.original)
                                                 .padding(4)
                     }
                 }
        })
    }
}
