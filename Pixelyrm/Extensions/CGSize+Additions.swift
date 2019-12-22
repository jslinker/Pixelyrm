//
//  CGSize+Additions.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 6/16/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import CoreGraphics

extension CGSize {
    var bounds: CGRect { .init(origin: .zero, size: self) }
}
