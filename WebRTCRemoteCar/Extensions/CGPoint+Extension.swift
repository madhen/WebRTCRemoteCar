//
//  CGPoint+Extension.swift
//  WebRTCRemoteCar
//
//  Created by Anish on 5/15/20.
//  Copyright © 2020 Anish. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    func angle(to endPoint: CGPoint) -> CGFloat {
        let dx = endPoint.x - x
        let dy = endPoint.y - y

        let theta = atan(abs(dy)/dx)
        return theta
    }
    
    func distance(to endPoint: CGPoint) -> CGFloat {
        return sqrt(pow((endPoint.x - x), 2) + pow((endPoint.y - y), 2))
    }
}
