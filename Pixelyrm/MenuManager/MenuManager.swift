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
    
    private func save() {
        print("Save")
    }
    
    private func load() {
        print("Load")
    }
    
}
