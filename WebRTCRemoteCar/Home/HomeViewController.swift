//
//  HomeViewController.swift
//  WebRTCRemoteCar
//
//  Created by Developer on 5/15/20.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import WebKit

class HomeViewController: UIViewController {
    @IBOutlet private weak var webview: WKWebView!

    let webRTCServices = WebRTCServices()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    private func setupView() {
        webview.scrollView.isScrollEnabled = false
        let touchView = TouchHandlingView(frame: webview.frame)
        touchView.touchMoved = { [unowned self] output in
            self.didTouchMove(angle: output.angle, distance: output.distance)
        }
        touchView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        view.addSubview(touchView)
        view.bringSubviewToFront(touchView)
    
    }
}

private extension HomeViewController {
    func didTouchMove(angle: CGFloat, distance: CGFloat) {
        print("\n\nAngle in radius --------- \(angle)")
        print("Angle in degree --------- \(angle * 180.0 / 3.14)")
        print("Distance --------- \(distance)")
        
        webRTCServices.fetchSome {[weak self] response in
            guard let _ = self else { return }
            switch response {
            case .success(let value): print("Value: \(value?.someAttribute ?? "")")
            case .failure(let error): print("Error: \(error.localizedDescription)")
            }
            
        }
    }
}


