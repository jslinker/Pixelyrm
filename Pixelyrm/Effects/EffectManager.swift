//
//  EffectManager.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/10/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Combine
import Foundation

typealias PixelColorClosure = ([PixelColor]) -> Void

protocol PixelEffect {
    var name: String { get }
    func run(on pixels: [PixelColor], size: IntSize, closure: PixelColorClosure)
}

class EffectManager: ObservableObject {
    
    @Published var effects: [PixelEffect]  = [PixelEffect]()
    
    init() {
        effects = []
    }
    
}
