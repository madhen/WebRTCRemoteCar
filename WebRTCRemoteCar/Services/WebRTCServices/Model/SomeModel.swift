//
//  SomeModel.swift
//  WebRTCRemoteCar
//
//  Created by Developer on 5/15/20.
//  Copyright © 2020 Developer. All rights reserved.
//

import Foundation

struct SomeModel: Codable {
    let someAttribute: String
    
    private enum CodingKeys: String, CodingKey {
        case someAttribute = "someAttribute-key"
    }
}

extension SomeModel {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        someAttribute = try values.decode(String.self, forKey: .someAttribute)
    }
}
