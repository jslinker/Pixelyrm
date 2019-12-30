//
//  AppModel.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/3/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Foundation
import Combine

public class AppModel: ObservableObject {

    let colorManager: ColorManager
    let drawManager: DrawManager
    let effectManager: EffectManager
    let historyManager: HistoryManager
    let layerManager: LayerManager
    let menuManager: MenuManager
    let toolManager: ToolManager
    
    private var toolChangedHandler: AnyCancellable?
    private var colorChangeHandler: AnyCancellable?
    private var activeLayerChangeHandler: AnyCancellable?
    
    @Published var colorPalette: ColorPalette = ColorPalette()
    
    public init() {
        colorManager = ColorManager()
        effectManager = EffectManager()
        historyManager = HistoryManager()
        layerManager = LayerManager()
        menuManager = MenuManager()
        toolManager = ToolManager(historyManager: historyManager)
        
        drawManager = DrawManager(historyManager: historyManager, activeLayer: layerManager.activeCanvasLayer, tool: toolManager.activeTool, color: colorManager.primaryColor)
        
        // TODO: Update to use objectWillChange?
        toolChangedHandler = self.toolChanged { [weak self] tool in
            guard let myself = self else { return }
            myself.drawManager.tool = tool
        }
        
        colorChangeHandler = self.colorManager.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let myself = self else { return }
                myself.drawManager.color = myself.colorManager.primaryColor
        }
        
        activeLayerChangeHandler = layerManager.objectWillChange
            .throttle(for: 0.0, scheduler: RunLoop.main, latest: true) // Prevents the sink from being triggered multiple times from `objectWillChange` sends in the same cycle
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                print("activeLayerChangeHandler()")
                guard let myself = self else { return }
                myself.drawManager.activeCanvasLayer = myself.layerManager.activeCanvasLayer
        }
        
        DispatchQueue.main.async {
            // Using `DispatchQueue.main.async` to fix an issue where the color isn't set for the mac catalyst app
            self.colorManager.primaryColor = self.colorPalette.colors.first ?? .black
        }
        
        menuManager.appModel = self // TODO: Handle this better
    }
    
//    func updateLayerManagerChangeHandler() {
//    }
    
}

// Tools

extension AppModel {
    
    public func toolChanged(_ closure: @escaping (_ tool: Tool) -> Void) -> AnyCancellable {
        return toolManager.toolPublisher
            .receive(on: RunLoop.main)
            .sink { closure($0) }
    }
    
}
