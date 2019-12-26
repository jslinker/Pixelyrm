//
//  UndoTool.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/21/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Foundation
import SwiftUI

public class UndoTool: Tool {
    
    private let historyManager: HistoryManager
    
    public init(historyManager: HistoryManager) {
        self.historyManager = historyManager
        super.init(image: .symbol(.undo), isSelectable: false)
    }
    
    public override func didTap() {
        historyManager.undo()
    }
    
}
