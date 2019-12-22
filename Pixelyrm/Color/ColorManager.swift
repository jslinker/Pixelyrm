//
//  ColorManager.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/1/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Combine
import Foundation

public class ColorManager: ObservableObject {
    
    public let objectWillChange = ObservableObjectPublisher()
    
    @Published public var primaryColor: PixelColor = .white {
        didSet {
            objectWillChange.send()
        }
    }
    
    @Published public var secondaryColor: PixelColor = .white {
        didSet {
            objectWillChange.send()
        }
    }
    
}
