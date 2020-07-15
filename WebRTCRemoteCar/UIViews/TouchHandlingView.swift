//
//  TouchManagingWebView.swift
//  Angle
//
//  Created by Developer on 5/14/20.
//  Copyright © 2020 Developer. All rights reserved.
//

import CoreGraphics
import UIKit

class TouchHandlingView: UIView {
    struct Output {
        let angle: CGFloat
        let distance: CGFloat
    }
    
    var touchDown = CGPoint.zero
    
    var touchMoved: ((Output) -> ())?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    private func setup() {
        let tapGesture = UIPanGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
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
