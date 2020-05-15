//
//  WebRTCServices.swift
//  WebRTCRemoteCar
//
//  Created by Developer on 5/15/20.
//  Copyright © 2020 Developer. All rights reserved.
//

import Foundation

struct WebRTCServices {
    private let service: APIRequestable

    init(service: APIRequestable = BaseServices.shared) {
        self.service = service
    }
    
    enum EndPoint: String {
        case some = "some.json"
        
        private static var hostURL: String {
            return "www.apple.com"
        }
        
        private var fullPath: String {
            return "\(EndPoint.hostURL)/\(rawValue)"
        }
        
        var url: URL? {
            return URL(string: fullPath)
        }
    }
}

extension WebRTCServices {
    func fetchSome(completion: @escaping (_ result: Result<SomeModel?, Error>) -> ()) {
        guard let url = EndPoint.some.url else {
            return
        }
        
        service.request(url, completion: completion)
    }
}