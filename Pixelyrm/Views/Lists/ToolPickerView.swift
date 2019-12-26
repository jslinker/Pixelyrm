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
    
    private func toolCell(for tool: ToolProtocol & ToolDisplayable, at index: Int) -> some View {
        let isActive = self.toolManager.activeTool == tool
        return PalettePixelContent(fillColor: isActive ? Color.white : Color.gray,
                                   strokeColor: isActive ? Color.black : Color.gray) {
                                    Image(uiImage: tool.toolImage)
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
