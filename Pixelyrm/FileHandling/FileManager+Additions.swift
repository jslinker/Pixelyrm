//
//  FileManager+Additions.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/22/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Foundation

extension FileManager {
    
    func fileExists(atURL url: URL) -> Bool {
        return fileExists(atPath: url.path)
    }
    
    func createFolder(atURL url: URL) throws {
        try createFolder(atPath: url.path)
        // TODO: Is the url used earlier excluded from backup?
        _ = try url.urlExcludedFromBackup() // TODO: Update this to exclude without returning anything
    }
    
    private func createFolder(atPath path: String) throws {
        let manager = FileManager.default
        guard !manager.fileExists(atPath: path) else { return } // Already exists
        try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
    }
    
    public func removeFile(atURL url: URL) -> Bool {
        guard FileManager.default.fileExists(atURL: url) else { return false }
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Failed to remove file at url: \(url)")
            return false
        }
        
        return true
    }
    
    public func save(data: Data, toURL url: URL) throws {
        try createFolder(atURL: url)
        try data.write(to: url)
    }
    
}
