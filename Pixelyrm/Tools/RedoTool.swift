//
//  RedoTool.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/21/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Foundation
import UIKit

extension RedoTool: ToolDisplayable {
    static let toolDisplayableImage: UIImage.AssetName = .circle
}

struct RedoTool: ToolProtocol {
    
    let historyManager: HistoryManager
    let isSelectable: Bool = false
    
    init(historyManager: HistoryManager) {
        self.historyManager = historyManager
    }
    
    func didTap() {
        historyManager.redo()
    }
    
}
