//
//  ToolPickerView.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/4/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import SwiftUI
import UIKit

struct ToolPickerView : View {
    
    @EnvironmentObject var toolManager: ToolManager
    
    private let cellSize: CGSize
    private let layout: GridViewLayout
    
    public init(layout: GridViewLayout, cellSize: CGSize = .init(width: 32, height: 32)) {
        self.layout = layout
        self.cellSize = cellSize
    }
    
    private func toolCell(for tool: Tool, at index: Int) -> some View {
        let isActive = self.toolManager.activeTool == tool
        let fillColor: Color = isActive ? .white : .gray // TODO: Update to use a theme color
        let strokeColor: Color = isActive ? .black : .gray // TODO: Update to use a theme color
        return PalettePixelContent(fillColor: fillColor, strokeColor: strokeColor) {
            tool.image
                .apply(modifier: .pixelArt)
                .padding(4)
        }
    }
    
    var body: some View {
        GridListView(items: toolManager.tools,
                     layout: layout,
                     cellSize: cellSize,
                     cellForItem: { tool, index in
                        self.toolCell(for: tool, at: index)
        }, didSelect: { tool, _ in
            if tool.isSelectable {
                self.toolManager.activeTool = tool
            }
            tool.didTap()
        })
    }
    
}
