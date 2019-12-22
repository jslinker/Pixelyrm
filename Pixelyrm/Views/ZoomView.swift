//
//  ZoomView.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/16/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Combine
import SwiftUI
import UIKit

public struct ZoomView<Content: View>: UIViewControllerRepresentable {
    
    @EnvironmentObject var layerManager: LayerManager
    
    public let content: () -> Content
    
    public func makeUIViewController(context: Context) -> UIScrollViewController<Content> {
        let scrollViewController = UIScrollViewController(rootView: self.content(), contentSize: layerManager.size.cgSize)
        return scrollViewController
    }
    
    public func updateUIViewController(_ viewController: UIScrollViewController<Content>, context: Context) {
        viewController.hostingController.rootView = self.content()
    }
    
}

public class UIScrollViewController<Content: View>: UIViewController, UIScrollViewDelegate {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.maximumZoomScale = 200
        scrollView.minimumZoomScale = 0.5
        scrollView.panGestureRecognizer.minimumNumberOfTouches = 2
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    fileprivate var hostingController: UIHostingController<Content>
    private var isFirstLayout: Bool = true
    fileprivate var contentSize: CGSize {
        didSet {
            contentView.frame = CGRect(origin: .zero, size: contentSize)
        }
    }
    
    fileprivate let contentView: UIView = {
        let contentView = UIView()
        contentView.isMultipleTouchEnabled = true
        contentView.useNearestFilter()
        contentView.backgroundColor = UIColor(patternImage: UIImage.checkerImage)
        return contentView
    }()
    
    init(rootView: Content, contentSize: CGSize) {
        hostingController = UIHostingController<Content>(rootView: rootView)
        hostingController.view.backgroundColor = .clear
        self.contentSize = contentSize
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        hostingController.willMove(toParent: self)
        
        contentView.addSubview(hostingController.view)
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        
        hostingController.didMove(toParent: self)
        
        scrollView.constrainToSuperview()
        hostingController.view.constrainToSuperview()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard isFirstLayout else { return }
        isFirstLayout = false
        contentView.frame = CGRect(origin: .zero, size: contentSize)
        self.scrollView.zoomScale = min(self.view.bounds.size.width / contentSize.width, self.view.bounds.size.height / contentSize.height)
        self.scrollView.centerFirstSubview()
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.scrollView.centerFirstSubview()
        }, completion: nil)
    }
    
    // MARK: UIScrollViewDelegate
        
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollView.centerFirstSubview()
    }
    
}
