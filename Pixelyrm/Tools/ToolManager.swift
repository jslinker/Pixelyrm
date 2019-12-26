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

extension Tool: Equatable {
    public static func == (lhs: Tool, rhs: Tool) -> Bool {
        lhs.id == rhs.id
    }
}

class Tool: ObservableObject, Identifiable {
    var toolDisplayableImage: UIImage.AssetName = .circle
    var id: String { String(describing: self) }
}

protocol ToolDisplayable {
    static var toolDisplayableImage: UIImage.AssetName { get }
}

extension ToolProtocol where Self: ToolDisplayable {
    var toolImage: UIImage { .image(Self.toolDisplayableImage) }
}

public class ToolManager: ObservableObject {
    
    @Published public var activeTool: ToolProtocol
    
    let historyManager: HistoryManager
    let tools: [Tool & ToolDisplayable & ToolProtocol] // Find a better way to do this. EX: Only using [Tool]
    
    init(historyManager: HistoryManager) {
        self.historyManager = historyManager
        tools = [UndoTool(historyManager: historyManager), RedoTool(historyManager: historyManager), PencilTool(), LineTool(), EraserTool(), EraserFloodTool(), RectangleOutlineTool(), RectangleFillTool(), FloodTool()]
        activeTool = tools.first(where: { $0 is PencilTool })!
    }

    internal var toolPublisher: AnyPublisher<ToolProtocol, Never> {
        $activeTool.eraseToAnyPublisher()
    }
    
}
