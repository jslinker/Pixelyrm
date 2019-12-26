//
//  ViewModifiers.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/26/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import SwiftUI

extension Image {

    enum Modifier {
        case pixelArt
    }
    
    // TODO: Find a better way to do this for SwiftUI.Image
    func apply(modifier: Modifier) -> some View {
        switch modifier {
        case .pixelArt:
            return self
                .resizable()
                .interpolation(.none)
                .renderingMode(.original)
        }
    }
    
}
