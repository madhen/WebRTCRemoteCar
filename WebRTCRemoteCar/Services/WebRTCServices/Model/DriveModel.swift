//
//  DriveModel.swift
//  WebRTCRemoteCar
//
//  Created by Developer on 5/15/20.
//  Copyright © 2020 Developer. All rights reserved.
//

import Foundation

struct DriveModel: Codable {
    let fontObstacle: Double
    let reverseObstacle: Double
    
    private enum CodingKeys: String, CodingKey {
        case fontObstacle
        case reverseObstacle
    }
}

extension DriveModel {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        fontObstacle = try values.decode(Double.self, forKey: .fontObstacle)
        reverseObstacle = try values.decode(Double.self, forKey: .reverseObstacle)
    }
}
