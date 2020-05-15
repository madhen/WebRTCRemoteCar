//
//  TouchManagingWebView.swift
//  Angle
//
//  Created by Developer on 5/14/20.
//  Copyright © 2020 Developer. All rights reserved.
//

import CoreGraphics
import UIKit
import WebKit

class TouchHandlingWebView: WKWebView {
    struct Output {
        let angle: CGFloat
        let distance: CGFloat
    }
    
    var touchDown = CGPoint.zero
    
    var touchMoved: ((Output) -> ())?
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    private func setup() {
        let tapGesture = UIPanGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        guard let touchMoved = touchMoved else { return }
        
        if gesture.state == .began {
            touchDown = gesture.location(in: self)
        }
        else if gesture.state == .changed ||  gesture.state == .ended {
            let endPoint = gesture.location(in: self)
            let output = Output(angle: touchDown.angle(to: endPoint), distance: touchDown.distance(to: endPoint))
            touchMoved(output)
        }
    }
}

extension TouchHandlingWebView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
