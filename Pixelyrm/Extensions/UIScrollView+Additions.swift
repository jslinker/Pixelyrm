//
//  UIScrollView+Additions.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 6/16/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    public func centerFirstSubview() {
        guard let firstView = subviews.first else { return }
        // TODO: Needs testing
        let xOffset = max(0.0, (bounds.size.width - contentSize.width + contentInset.left - contentInset.right) * 0.5)
        let yOffset = max(0.0, (bounds.size.height - contentSize.height + contentInset.top - contentInset.bottom) * 0.5)
        // Account for `safeAreaInsets` and changes in `adjustedContentInset`
//        let xOffset = max(0.0, (bounds.size.width - contentSize.width + contentInset.left - contentInset.right + safeAreaInsets.left - safeAreaInsets.right + adjustedContentInset.left - adjustedContentInset.right) * 0.5)
//        let yOffset = max(0.0, (bounds.size.height - contentSize.height + contentInset.top - contentInset.bottom + safeAreaInsets.top - safeAreaInsets.bottom + adjustedContentInset.top - adjustedContentInset.bottom) * 0.5)
        firstView.center = CGPoint(x: contentSize.width * 0.5 + xOffset, y: contentSize.height * 0.5 + yOffset)
    }
    
}
