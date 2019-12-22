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
    
    @discardableResult func createFolder(atURL url: URL) throws -> Bool {
        let url = try url.urlExcludedFromBackup()
        return createFolder(atPath: url.path)
    }
    
    private func createFolder(atPath path: String) -> Bool {
        let manager = FileManager.default
        guard !manager.fileExists(atPath: path) else { return true } // Already exists
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Failed to create folder at path: \(path) - Error: \(error.localizedDescription)");
            return false
        }
        
        return true
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
