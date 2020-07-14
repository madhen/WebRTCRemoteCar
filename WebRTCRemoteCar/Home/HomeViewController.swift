//
//  HomeViewController.swift
//  WebRTCRemoteCar
//
//  Created by Developer on 5/15/20.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet private weak var webview: TouchHandlingWebView!

    let webRTCServices = WebRTCServices()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Receive App active/inactive notification
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: nil, using: willResignActive)
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil, using: didBecomeActive)
        
        setupView()
    }

    private func setupView() {
        //proxy2.remot3.it:30740
        webview.load(NSURLRequest(url: NSURL(string: "http://10.0.0.77:8888/fordev.html")! as URL) as URLRequest)
        webview.scrollView.isScrollEnabled = false
        webview.touchMoved = { [unowned self] output in
            self.didTouchMove(angle: output.angle, distance: output.distance)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        handleWebView(turn: false)
    }
    
    func willResignActive(notification: Notification) {
        print("willResignActive")
        handleWebView(turn: false)
    }
    
    func didBecomeActive(notification: Notification) {
        print("didBecomeActive")
        handleWebView(turn: true)
    }
    
    func handleWebView(turn on: Bool) {
        var script: String;
        if (on) {
            script = "viewResume()"
        }
        else {
            script = "viewPause()"
        }
        webview.evaluateJavaScript(script) { (result, error) in
            if let e = error {
                print(e)
            }
        }
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


