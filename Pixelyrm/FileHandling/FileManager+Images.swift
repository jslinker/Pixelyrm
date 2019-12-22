//
//  FileManager+Images.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/22/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    public func save(toURL url: URL) throws {
        try FileManager.default.save(image: self, toURL: url)
    }
    
    public func image(fromURL url: URL) -> UIImage? {
        return UIImage(contentsOfFile: url.path)
    }
    
}

extension FileManager {
    
    public func save(image: UIImage, toURL url: URL) throws {
        guard let data = image.pngData() else { throw "Failed to get pngData" }
        try data.write(to: url)
    }
    
}
