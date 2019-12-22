//
//  TouchInputView.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/16/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import SwiftUI
import UIKit

protocol InputViewHandler: class {
    func touchInputViewController(_ controller: TouchInputUIView, beginTouchAtPoint point: IntPoint)
    func touchInputViewController(_ controller: TouchInputUIView, movedTouchToPoint point: IntPoint)
    func touchInputViewController(_ controller: TouchInputUIView, endedTouchAtPoint point: IntPoint)
}

extension InputViewHandler {
    func touchInputViewController(_ controller: TouchInputUIView, beginTouchAtPoint point: IntPoint) {}
    func touchInputViewController(_ controller: TouchInputUIView, movedTouchToPoint point: IntPoint) {}
    func touchInputViewController(_ controller: TouchInputUIView, endedTouchAtPoint point: IntPoint) {}
}

struct TouchInputView<T: InputViewHandler>: UIViewRepresentable {
    
    var inputViewHandler: T
    
    func makeUIView(context: UIViewRepresentableContext<TouchInputView<T>>) -> TouchInputUIView {
        return TouchInputUIView(inputViewHandler: inputViewHandler)
    }
    
    func updateUIView(_ uiView: TouchInputUIView, context: UIViewRepresentableContext<TouchInputView<T>>) {
        uiView.inputViewHandler = inputViewHandler
    }
    
}

class TouchInputUIView: UIView {
    
    weak var inputViewHandler: InputViewHandler?
    
    /// Used to prevent redundant drawing if the tool moves around in the same pixel
    private var lastDrawnIntLocation: IntPoint?
    
    init(inputViewHandler: InputViewHandler?) {
        self.inputViewHandler = inputViewHandler
        super.init(frame: .zero)
        
        let panGesture = StartPanGestureRecognizer(target: self, action: #selector(panned(gesture:)))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped(gesture:)))
        tapGesture.numberOfTouchesRequired = 1
        
        addGestureRecognizer(panGesture)
        addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO: Fix an issue where going out of cound then back in draws a line to the place the touch entered from where it exited
    @objc private func panned(gesture: StartPanGestureRecognizer) {
        let location = gesture.location(in: self)
        guard frame.contains(location) else {
            if gesture.state == .ended {
                // Make sure ended is called even if the touch is ended outside the drawing area
                inputViewHandler?.touchInputViewController(self, endedTouchAtPoint: lastDrawnIntLocation ?? .zero)
            }
            return
        }
        let intLocation = location.intPoint
        switch gesture.state {
        case .began:
            inputViewHandler?.touchInputViewController(self, beginTouchAtPoint: gesture.startPoint.intPoint)
        case .changed:
            guard intLocation != lastDrawnIntLocation else { return }
            inputViewHandler?.touchInputViewController(self, movedTouchToPoint: intLocation)
        case .ended:
            inputViewHandler?.touchInputViewController(self, endedTouchAtPoint: intLocation)
        default:
            print("Other")
        }
        
        lastDrawnIntLocation = intLocation
    }
    
    // The `began` state isn't called for `UITapGestureRecognizer` so the `beginTouchAtPoint` and `endedTouchAtPoint` are both called in the `ended` state
    @objc private func tapped(gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        guard frame.contains(location) else { return }
        let intLocation = location.intPoint
        switch gesture.state {
        case .ended:
            inputViewHandler?.touchInputViewController(self, beginTouchAtPoint: intLocation)
            inputViewHandler?.touchInputViewController(self, endedTouchAtPoint: intLocation)
        default:
            print("Tap Other")
        }
        
        lastDrawnIntLocation = intLocation
    }
    
}

private class StartTapGestureRecognizer: UITapGestureRecognizer {
    
    var startPoint: CGPoint = .zero
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        startPoint = touches.first?.location(in: view) ?? .zero
    }
    
}

private class StartPanGestureRecognizer: UIPanGestureRecognizer {
    
    var startPoint: CGPoint = .zero
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        startPoint = touches.first?.location(in: view) ?? .zero
    }
    
}
