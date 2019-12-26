//
//  SelectedColorsView.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/1/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Foundation
import SwiftUI

struct SelectedColorsView : View {
    
    @EnvironmentObject var colorManager: ColorManager
    
    var showOutline: Bool
    
    var body: some View {
        let gradient: Gradient = .init(colors: [.red, .orange, .yellow, .green, .blue, .purple, .red])
        let strokeGradient: AngularGradient = .init(gradient: gradient, center: .center, startAngle: .zero, endAngle: .degrees(360))
        return ZStack {
            Circle()
                .fill(self.colorManager.primaryColor.color)
            if showOutline {
                Circle()
                    .strokeBorder(strokeGradient, lineWidth: 2)
                    .animation(.easeIn(duration: 0.1))
            }
        }
    }
}
