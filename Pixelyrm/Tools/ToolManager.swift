//
//  ToolManager.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/2/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Combine
import Foundation
import UIKit

protocol ToolDisplayable {
    static var toolDisplayableImage: UIImage.AssetName { get }
}

extension ToolProtocol where Self: ToolDisplayable {
    var toolImage: UIImage { .image(Self.toolDisplayableImage) }
}

public class ToolManager: ObservableObject {
    
    @Published public var activeTool: ToolProtocol
    
    let historyManager: HistoryManager
    let tools: [ToolProtocol & ToolDisplayable]
    
    init(historyManager: HistoryManager) {
        self.historyManager = historyManager
        tools = [UndoTool(historyManager: historyManager), RedoTool(historyManager: historyManager), PencilTool(), LineTool(), EraserTool(), EraserFloodTool(), RectangleOutlineTool(), RectangleFillTool(), FloodTool()]
        activeTool = tools.first(where: { $0 is PencilTool })!
    }

    internal var toolPublisher: AnyPublisher<ToolProtocol, Never> {
        $activeTool.eraseToAnyPublisher()
    }
    
}
