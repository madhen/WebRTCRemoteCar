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
    
    enum EndPoint {
        
        case fetchDrive(radiusAngle: Double, degree: Double, distance: Double, driver: String)
        case postDrive
        
        private static var hostURL: String {
            return "www.apple.com"
        }
        
        private var fullPath: String {
            let path: String = {
                switch self {
                case .fetchDrive(let radiusAngle, let degree, let distance, let driver): return "drive?radiusAngle=\(radiusAngle)&degree=\(degree)&distance=\(distance)&driver=\(driver)"
                case .postDrive: return "start"
                }
            }()
            return "\(EndPoint.hostURL)/\(path)"
        }
        
        var url: URL? {
            return URL(string: fullPath)
        }
    }
}

extension WebRTCServices {
    func fetchDrive(radiusAngle: Double, degree: Double, distance: Double, driver: String, completion: @escaping (_ result: Result<DriveModel?, Error>) -> ()) {
        guard let url = EndPoint.fetchDrive(radiusAngle: radiusAngle, degree: degree, distance: distance, driver: driver).url else {
            completion(.failure(WebRTCError.unsopprtedURL))
            return
        }
        service.request(url, completion: completion)
    }
    
    func postDrive(driver: String, completion: @escaping (_ result: Result<DriveModel?, Error>) -> ()) {
        guard let url = EndPoint.postDrive.url else {
            completion(.failure(WebRTCError.unsopprtedURL))
            return
        }
        
        let body = ["driverName": driver]
        service.request(url, method: .post, headers: nil, body: body, keypath: nil, completion: completion)
    }
}
