//
//  WideView.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/22/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import SwiftUI

struct WideView : View {
    
    @EnvironmentObject var frameManager: FrameManager
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    ScrollView(.vertical, showsIndicators: false) {
                        MenuView(layout: .maxColumns(1), cellSize: .init(width: 44, height: 44))
                            .padding(2)
                    }
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            ColorPickerView(layout: .maxColumns(4), cellSize: .init(width: 32, height: 32))
                                .padding(2)
                        }
                    }
                    
                    // TODO: Fix an issue where the inset isn't adjusted properly causing the bottom area to be uneditable in landscape
                    DrawView()
//                        .environmentObject(self.appModel.frameManager)
                        .edgesIgnoringSafeArea(.all)
                        .background(Color(red: 0.1, green: 0.1, blue: 0.1).edgesIgnoringSafeArea(.all)) // TODO: Make a color theme
                        .padding(.bottom) // TODO: There is an issue where the scrollview does adjust its insets correctly causing the draw area to be cut off, this is a temporary fix which is unpleasing to the eye
                    
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        ScrollView(.vertical, showsIndicators: false) {
                            // TODO: Fix an issue where when there is 1 layer when scrolling left it won't snap back to its original position
                            LayersListView(layout: .wrapToNextLine(proxy: geometry, maxRows: 1), cellSize: CGSize(width: 32, height: 32))
                                //                                .environmentObject(self.appModel.frameManager)
                                .padding(2)
                        }
                            .frame(width: CGFloat(self.frameManager.frames * 34)) // TODO: How does maxHeight work? Doesn't seem to do what I expect it to do.
                    }
                        .frame(width: min(106, CGFloat(self.frameManager.frames * 34))) // TODO: How does maxHeight work? Doesn't seem to do what I expect it to do.
                    
//                    ScrollView(.vertical, showsIndicators: false) {
//                        LayersListView(layout: .maxColumns(1), cellSize: .init(width: 32, height: 32))
////                            .environmentObject(self.appModel.frameManager)
//                            .padding(2)
//                    }
                    ScrollView(.vertical, showsIndicators: false) {
                        ToolPickerView(layout: .maxColumns(2), cellSize: .init(width: 40, height: 40))
                            .padding(2)
                    }
                }
            }
        }
            .background(Color.init(red: 0.9, green: 0.9, blue: 0.9).edgesIgnoringSafeArea(.all)) // TODO: Make a color theme
    }
}
