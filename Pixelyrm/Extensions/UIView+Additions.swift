//
//  UIView+Additions.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 6/11/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import UIKit

extension UIView {
    
    func useNearestFilter() {
        self.layer.minificationFilter = .nearest
        self.layer.magnificationFilter = .nearest
        self.superview?.layer.minificationFilter = .nearest
        self.superview?.layer.magnificationFilter = .nearest
    }
    
}
