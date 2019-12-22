//
//  URL+Additions.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/22/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Foundation

extension URL {
    
    static var documentsURL = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
    static var imagesURL: URL = documentsURL.appendingPathComponent("images", isDirectory: true)
    
    func urlExcludedFromBackup() throws -> URL {
        var url = self
        var resourceValues = URLResourceValues()
        resourceValues.isExcludedFromBackup = true
        try url.setResourceValues(resourceValues)
        return url
    }
    
}
