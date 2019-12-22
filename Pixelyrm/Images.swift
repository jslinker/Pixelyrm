//
//  Images.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/10/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import UIKit

extension UIImage {
    
    enum AssetName: String {
        case circle, eraser, line, pencil, select, square
    }
    
    static func image(_ assetName: AssetName) -> UIImage {
        return self.init(named: assetName.rawValue)!
    }
}
