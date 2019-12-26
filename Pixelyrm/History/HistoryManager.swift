//
//  HistoryManager.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/21/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Combine
import Foundation

public class HistoryManager: ObservableObject {
    
    private let undoManager: UndoManager = UndoManager()
    
    public func undo() {
        undoManager.undo()
    }
    
    public func redo() {
        undoManager.redo()
    }
    
    public func registerUndo<TargetType>(withTarget target: TargetType, handler: @escaping (TargetType) -> Void) where TargetType : AnyObject {
        undoManager.registerUndo(withTarget: target, handler: handler)
    }
    
}
