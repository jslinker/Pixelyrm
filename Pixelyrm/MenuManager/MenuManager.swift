//
//  MenuManager.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/22/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

public class MenuManager: ObservableObject {
    
    weak var appModel: AppModel?
    
    public enum Action {
        case save
        case load
        
        public var name: String {
            switch self {
                case .save: return NSLocalizedString("Save", comment: "Title for saving the project")
                case .load: return NSLocalizedString("Load", comment: "Title for loading a project")
            }
        }
        
        public var image: Image {
            switch self {
            case .save: return .symbol(.save)
            case .load: return .symbol(.load)
            }
        }
    }
    
    @Published public private(set) var actions: [Action]
    
    public init() {
        actions = [.save, .load]
    }
    
    public func perform(action: Action) {
        switch action {
        case .save: save()
        case .load: load()
        }
    }
    
    // TODO: Update this
    let tempURL: URL = URL.documentsURL.appendingPathComponent("files", isDirectory: true)
    var tempFile: URL { tempURL.appendingPathComponent("test.hi", isDirectory: false) }
    
    private func save() {
        guard let appModel = appModel else { return }
        do {
            let data = try JSONEncoder().encode(appModel.layerManager.makeLayerManagerData())
            print("data! \(data)")
            try FileManager.default.createFolder(atURL: tempURL)
            try data.write(to: tempFile)
            print("Save")
        } catch {
            print("Failed to save `LayerManager`: \(error.localizedDescription)")
        }
    }
    
    private func load() {
        guard let appModel = appModel else { return }
        do {
            let data = try Data(contentsOf: tempFile)
            let layerManagerData = try JSONDecoder().decode(LayerManagerData.self, from: data)
            appModel.layerManager.configure(with: layerManagerData) // TODO: Handle this better
            print("Load")
            appModel.historyManager.clearHistory()
        } catch {
            print("Failed to load `LayerManager`: \(error.localizedDescription)")
        }
    }
    
}
