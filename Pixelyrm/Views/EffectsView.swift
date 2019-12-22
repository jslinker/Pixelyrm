//
//  EffectsView.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/21/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import SwiftUI

struct EffectsView : View {
    
    @EnvironmentObject var effectManager: EffectManager
    
    let cellSize: CGSize
    
    var body: some View {
        ControlsView(verticalPadding: 2,
                     horizontalPadding: 2,
                     cellSize: cellSize,
                     count: self.effectManager.effects.count,
                     view: { index in
                        Button(action: {
                            // TODO: Handle!
                        }) {
                            PalettePixelContent(fillColor: .gray, strokeColor: .black) {
                                Text(self.effectManager.effects[index].name)
                                    .padding(1)
                                    .truncationMode(.middle)
                                    .font(.system(size: 14))
                            }
                        }
        })
    }
}
