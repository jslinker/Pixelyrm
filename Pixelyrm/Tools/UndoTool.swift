//
//  UndoTool.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/21/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Foundation
import UIKit

extension UndoTool: ToolDisplayable {
    static let toolDisplayableImage: UIImage.AssetName = .circle
}

struct UndoTool: ToolProtocol {
    
    let historyManager: HistoryManager
    let isSelectable: Bool = false
    
    init(historyManager: HistoryManager) {
        self.historyManager = historyManager
    }
    
    func didTap() {
        historyManager.undo()
    }
    
}
