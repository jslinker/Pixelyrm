//
//  IntSize.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 6/16/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Foundation
import UIKit

public struct IntSize: Codable {
    let width: Int
    let height: Int
    
    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
    
    public init(size: CGSize) {
        self.width = Int(size.width)
        self.height = Int(size.height)
    }
}

extension CGSize {
    public var intSize: IntSize { .init(width: Int(width), height: Int(height)) }
}

extension UIImage {
    var intSize: IntSize { .init(size: size) }
}

extension IntSize {
    static var zero: IntSize { .init(width: 0, height: 0) }
    var cgSize: CGSize { .init(width: width, height: height) }
    var bounds: CGRect { .init(origin: .zero, size: CGSize(width: width, height: height)) }
}
