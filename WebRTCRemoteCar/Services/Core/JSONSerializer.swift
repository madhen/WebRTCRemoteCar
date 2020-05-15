//
//  JSONSerializer.swift
//  EmployeesApp
//
//  Created by Naveen Shan on 2/15/20.
//  Copyright © 2020 Naveen Shan. All rights reserved.
//

import Foundation

/// Helper class for json encoding and decoding from codable models.
///
/// Review Note :
/// Implemented by referencing one of my previous project.
/// Provided the static methods to improve performance of app by avoiding the creation of havy classes such as json decoder and encoder for each request made.
struct JSONSerializer {
    private static let jsonEncoder = JSONEncoder()
    private static let jsonDecoder = JSONDecoder()
}

// MARK: - Decoding Methods

extension JSONSerializer {
    /// Decode data to codable object.
    static func decode<T: Decodable>(data: Data, keypath: String? = nil) -> Result<T?, Error> {
        var result: Result<T?, Error>
        do {
            var json = try JSONSerialization.jsonObject(with: data, options: [])
            if let keypath = keypath {
                if let innerJson = ((json as AnyObject).value(forKeyPath: keypath)) {
                    json = innerJson as Any
                }
                else {
                    let decodingErrorContext = DecodingError.Context(codingPath: [], debugDescription: "The given keypath not found.", underlyingError: nil)
                    throw DecodingError.dataCorrupted(decodingErrorContext)
                }
            }
            
            let data = try JSONSerialization.data(withJSONObject: json)
            let object = try jsonDecoder.decode(T.self, from: data)
            result = .success(object)
        }
        catch {
            result = .failure(error)
        }
        return result
    }
}

// MARK: - Encoding Methods

extension JSONSerializer {
    /// Encode a codable object to dictionary.
    static func encode<T: Encodable>(object: T) -> Result<[String: Any]?, Error> {
        var result: Result<[String: Any]?, Error>
        do {
            let data = try jsonEncoder.encode(object)
            let serializeObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            let dictionary = (serializeObject as AnyObject?).flatMap { $0 as? [String: Any] }
            result = .success(dictionary)
        }
        catch {
            result = .failure(error)
        }
        return result
    }
}
