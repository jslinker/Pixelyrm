//
//  CompactView.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/22/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import SwiftUI

struct CompactView : View {
    
    @EnvironmentObject var appModel: AppModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    MenuView(layout: .wrapToNextLine(proxy: geometry, maxRows: 1), cellSize: .init(width: 44, height: 44))
                        .padding(2)
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    // TODO: Fix an issue where when there is 1 layer when scrolling left it won't snap back to its original position
                    LayersListView(layout: .wrapToNextLine(proxy: geometry, maxRows: 1), cellSize: CGSize(width: 44, height: 44))
                        .environmentObject(self.appModel.layerManager)
                        .padding(.horizontal, 2)
                }
                DrawView()
                    .environmentObject(self.appModel.layerManager)
                    .background(Color.init(red: 0.1, green: 0.1, blue: 0.1).edgesIgnoringSafeArea(.all)) // TODO: Make a color theme
                VStack(spacing: 0) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        ColorPickerView(layout: .wrapToNextLine(proxy: geometry, maxRows: 2), cellSize: .init(width: 32, height: 32))
                            .padding(.horizontal, 2)
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        ToolPickerView(layout: .wrapToNextLine(proxy: geometry, maxRows: 2), cellSize: .init(width: 40, height: 40))
                            .padding(.horizontal, 2)
                    }
                }
                .padding(.vertical, 2)
            }
            .padding(.vertical, 2)
                .background(Color.init(red: 0.9, green: 0.9, blue: 0.9).edgesIgnoringSafeArea(.all)) // TODO: Make a color theme
        }
    }
}