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
    
    let cellSize: CGSize
    
    var body: some View {
        ControlsView(verticalPadding: 2,
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
                            PalettePixelContent(fillColor: .gray, strokeColor: .black) {
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

