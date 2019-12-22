//
//  MenuView.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/21/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import SwiftUI

struct MenuView: View {
    
    var body: some View {
        VStack(spacing: 4) {
            ColorPickerView(cellSize: .init(width: 30, height: 30))
            LayersListView(cellSize: CGSize(width: 44, height: 44))
//            EffectsView(cellSize: .init(width: 56, height: 56))
            ToolPickerView(cellSize: .init(width: 40, height: 40))
        }
        .padding(2)
            .background(Color.init(red: 0.9, green: 0.9, blue: 0.9).edgesIgnoringSafeArea(.all)) // TODO: Make a color theme
    }
    
}

