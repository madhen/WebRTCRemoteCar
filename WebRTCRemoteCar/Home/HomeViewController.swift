//
//  HomeViewController.swift
//  WebRTCRemoteCar
//
//  Created by Anish on 5/15/20.
//  Copyright © 2020 Anish. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet private weak var webview: TouchHandlingWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    private func setupView() {
        webview.touchMoved = { [unowned self] output in
            self.didTouchMove(angle: output.angle, distance: output.distance)
        }
    }
}

private extension HomeViewController {
    func didTouchMove(angle: CGFloat, distance: CGFloat) {
        print("Angle --------- \(angle)")
        print("Distance --------- \(distance)")
    }
}


