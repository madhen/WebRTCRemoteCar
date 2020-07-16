//
//  WebRTCError.swift
//  WebRTCRemoteCar
//
//  Created by Anish on 7/16/20.
//  Copyright © 2020 Anish. All rights reserved.
//

import Foundation

enum WebRTCError: Error {
    case unsopprtedURL
}

extension WebRTCError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unsopprtedURL: return "Unsupported URL"
        }
    }
}
