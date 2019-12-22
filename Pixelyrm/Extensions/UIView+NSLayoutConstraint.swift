//
//  UIView+NSLayoutConstraint.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 6/16/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import UIKit

extension UIView {
    
    public func constrainToSuperview() {
        guard let superview = superview else { fatalError("constrainToSuperview() - Missing superview") }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            self.topAnchor.constraint(equalTo: superview.topAnchor),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
    
}
