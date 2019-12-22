//
//  ContentView.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 6/10/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.verticalSizeClass) var sizeClass
    
    var useWide: Bool {
        #if targetEnvironment(macCatalyst)
        return true
        #else
        return self.sizeClass == .compact
        #endif
    }
    
    var body: some View {
        return VStack(spacing: 0) {
            if useWide {
                WideView()
            } else {
                CompactView()
            }
        }
            .background(Color.init(red: 0.1, green: 0.1, blue: 0.1).edgesIgnoringSafeArea(.all)) // TODO: Make a color theme
    }
    
}
