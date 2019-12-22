//
//  ContentView.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 6/10/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            DrawView()
            MenuView()
        }
            .background(Color.init(red: 0.1, green: 0.1, blue: 0.1).edgesIgnoringSafeArea(.all)) // TODO: Make a color theme
    }
    
}
