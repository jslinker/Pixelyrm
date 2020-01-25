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
    
    public enum Action: String, Identifiable {
        case save
        case load
        case addLayer
        case removeLayer
        case addFrame
        case removeFrame
        
        public var id: String {
            rawValue
        }
        
        public var name: String {
            switch self {
                case .save: return NSLocalizedString("Save", comment: "Title for saving the project")
                case .load: return NSLocalizedString("Load", comment: "Title for loading a project")
                case .addLayer: return NSLocalizedString("Add Layer", comment: "Title for adding a layer")
                case .removeLayer: return NSLocalizedString("Remove Layer", comment: "Title for removing a layer")
                case .addFrame: return NSLocalizedString("Add Frame", comment: "Title for adding a frame")
                case .removeFrame: return NSLocalizedString("Remove Frame", comment: "Title for removing a frame")
            }
        }
        
        public var image: Image {
            switch self {
            case .save: return .symbol(.save)
            case .load: return .symbol(.load)
            case .addLayer: return .symbol(.addLayer)
            case .removeLayer: return .symbol(.removeLayer)
            case .addFrame: return .symbol(.addFrame)
            case .removeFrame: return .symbol(.removeFrame)
            }
        }
    }
    
    @Published public private(set) var actions: [Action]
    
    public init() {
        actions = [.save, .load, .removeLayer, .addLayer, .removeFrame, .addFrame]
    }
    
    public func perform(action: Action) {
        switch action {
        case .save: save()
        case .load: load()
        case .addLayer: appModel?.frameManager.addLayer()
        case .removeLayer: break // TODO: Handle
        case .addFrame: appModel?.frameManager.addFrame() // TODO: Handle
        case .removeFrame: break // TODO: Handle
        }
    }
    
    // TODO: Move/Update this
    let tempURL: URL = URL.documentsURL.appendingPathComponent("files", isDirectory: true)
    var tempFile: URL { tempURL.appendingPathComponent("test.hi", isDirectory: false) }
    
    private func save() {
        guard let appModel = appModel else { return }
        do {
            let data = try JSONEncoder().encode(appModel.frameManager)
            try FileManager.default.createFolder(atURL: tempURL)
            try data.write(to: tempFile)
        } catch {
            print("Failed to save `FrameManager`: \(error.localizedDescription)")
        }
    }
    
    private func load() {
        guard let appModel = appModel else { return }
        do {
            let data = try Data(contentsOf: tempFile)
            let frameManager = try JSONDecoder().decode(FrameManager.self, from: data)
            appModel.frameManager = frameManager
            appModel.historyManager.clearHistory()
        } catch {
            print("Failed to load `LayerManager`: \(error.localizedDescription)")
        }
    }
    
}
