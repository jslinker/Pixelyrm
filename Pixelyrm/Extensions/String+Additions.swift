//
//  String+Additions.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 6/11/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? {
        return self
    }
}
