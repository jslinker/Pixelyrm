//
//  MenuView.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/26/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import SwiftUI

struct MenuView: View {
    
    @EnvironmentObject var menuManager: MenuManager
    
    private let cellSize: CGSize
    private let layout: GridViewLayout
    
    public init(layout: GridViewLayout, cellSize: CGSize = .init(width: 44, height: 44)) {
        self.layout = layout
        self.cellSize = cellSize
    }
    
    var body: some View {
        GridListView(items: menuManager.actions,
                     layout: layout,
                     cellSize: cellSize,
                     cellForItem: { action, _ in
                        PalettePixelContent(fillColor: Color.white, strokeColor: Color.black) {
                            action.image
                                .padding(4)
                        }
        }, didSelect: { action, _ in
            self.menuManager.perform(action: action)
        })
    }
    
}

