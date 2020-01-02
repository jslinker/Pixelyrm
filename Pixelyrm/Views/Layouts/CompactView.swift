//
//  CompactView.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/22/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import SwiftUI

struct CompactView : View {
    
    @EnvironmentObject var frameManager: FrameManager
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    MenuView(layout: .wrapToNextLine(proxy: geometry, maxRows: 1), cellSize: .init(width: 44, height: 44))
                        .padding(2)
                }
                DrawView()
//                    .environmentObject(self.appModel.frameManager)
                    .background(Color.init(red: 0.1, green: 0.1, blue: 0.1).edgesIgnoringSafeArea(.all)) // TODO: Make a color theme
                VStack(spacing: 0) {
                    ScrollView(.vertical, showsIndicators: false) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            // TODO: Fix an issue where when there is 1 layer when scrolling left it won't snap back to its original position
                            LayersListView(layout: .wrapToNextLine(proxy: geometry, maxRows: 1), cellSize: CGSize(width: 32, height: 32))
//                                .environmentObject(self.appModel.frameManager)
                                .padding(.horizontal, 2)
                        }
                        .frame(height: CGFloat(self.frameManager.layeredCanvases.count * 34)) // TODO: How does maxHeight work? Doesn't seem to do what I expect it to do.
                    }
                        .frame(height: min(104, CGFloat(self.frameManager.layeredCanvases.count * 34))) // TODO: How does maxHeight work? Doesn't seem to do what I expect it to do.
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
