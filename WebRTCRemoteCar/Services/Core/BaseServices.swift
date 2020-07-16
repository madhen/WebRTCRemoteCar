//
//  BaseServices.swift
//  EmployeesApp
//
//  Created by Naveen Shan on 2/14/20.
//  Copyright © 2020 Naveen Shan. All rights reserved.
//

import Foundation

//MARK: - HTTPMethod

public enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
}

//MARK: - APIRequestable

protocol APIRequestable {
    func request<Response: Decodable>(_ url: URL, completion: @escaping (_ result: Result<Response?, Error>) -> ())
    func request<Response: Decodable>(_ url: URL, keypath: String?, completion: @escaping (_ result: Result<Response?, Error>) -> ())
    
    func request<Response: Decodable>(_ url: URL, method: HTTPMethod, headers: [String: String]?, body: [String: Any]?, keypath: String?, completion: @escaping (_ result: Result<Response?, Error>) -> ())
    func request(_ url: URL, completion: @escaping (_ result: Result<Data?, Error>) -> ()) -> URLSessionDataTask?
}

// Note : The following method helps to abstract the non-required parameters, due to the limitation that the protocol will not support default parameters.
extension APIRequestable {
    func request<Response: Decodable>(_ url: URL, completion: @escaping (_ result: Result<Response?, Error>) -> ()) {
        request(url, method: .get, headers: nil, body: nil, keypath: nil, completion: completion)
    }
    
    func request<Response>(_ url: URL, keypath: String?, completion: @escaping (Result<Response?, Error>) -> ()) where Response : Decodable {
        request(url, method: .get, headers: nil, body: nil, keypath: keypath, completion: completion)
    }
}

//MARK: - BaseServices

/// Core class responsible for a network request using NSURLSession.
///
/// Review Note :
/// Implemented a thin version by referencing one of my previous project.
/// Its support only json format now, easily expandable to support other data types such as XML, Protobuf, Data, Form etc.
/// Provided shared instance as well for keeping the instance in memory during to avoid deallocation in the middle of execution of a request.
final class BaseServices: APIRequestable {
    private let session: URLSession
    public var dispatchQueue: DispatchQueue = DispatchQueue.main
    
    static let shared = BaseServices(session: URLSession.shared)

    init(session: URLSession) {
        self.session = session
    }
    
    //MARK: -
    
    /// Method that executes the service request.
    /// - parameter url: Request URL.
    /// - parameter method: Request HTTPMethod.
    /// - parameter headers: Request headers.
    /// - parameter body: Request body.
    /// - parameter keypath: Response key name where decoding need to begin.
    /// - parameter completion: completion of request.
    /// - parameter result: Codable response model or Error.
    func request<Response: Decodable>(_ url: URL, method: HTTPMethod, headers: [String: String]?, body: [String: Any]?, keypath: String?, completion: @escaping (_ result: Result<Response?, Error>) -> ()) {
        let postBody: Data? = {
            guard let body = body else { return nil }
            
            return try? NSKeyedArchiver.archivedData(withRootObject: body, requiringSecureCoding: false)
        }()
        
        let request = executableURLRequest(url, method: method, headers: headers, body: postBody)
        
        let dataTask: URLSessionDataTask = session.dataTask(with: request) { [weak self] (data, _, error) in
            
            if let error = error {
                self?.dispatchQueue.async {
                    completion(.failure(error))
                }
                return
            }
            
            self?.serialize(keypath: keypath, data: data, completion: { (result: Result<Response?, Error>) in
                self?.dispatchQueue.async {
                    completion(result)
                }
            })
        }
        dataTask.resume()
    }
    
    /// Method that executes the service request.
    ///
    /// Useful for image downloads
    /// - parameter url: Request URL.
    /// - parameter completion: completion of request.
    /// - parameter result: Data response model or Error.
    func request(_ url: URL, completion: @escaping (_ result: Result<Data?, Error>) -> ()) -> URLSessionDataTask? {
        let request = URLRequest(url: url)
        
        let dataTask: URLSessionDataTask = session.dataTask(with: request) { [weak self] (data, _, error) in
            
            if let error = error {
                self?.dispatchQueue.async {
                    completion(.failure(error))
                }
                return
            }
            
            self?.dispatchQueue.async {
                completion(.success(data))
            }
        }
        dataTask.resume()
        return dataTask
    }
}

//MARK: -

extension BaseServices {
    private func executableURLRequest(_ url: URL, method: HTTPMethod = .get, headers: [String: String]? = nil, body: Data? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        // Header Parameters
        request.allHTTPHeaderFields = headers
        // Additional headers required for json request.
        // Will be optimize later when we need to use other type of request.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        // Body Parameters
        if method != .get, let requestBody = body, requestBody.count >= 1 {
            let contentLength = String(format: "%lu", requestBody.count)
            request.addValue(contentLength, forHTTPHeaderField: "Content-Length")
            
            request.httpBody = requestBody
        }
        
        return request
    }
    
    private func serialize<Response: Decodable>(keypath: String? = nil, data: Data?, completion: (_ result: Result<Response?, Error>) -> ()) {
        guard let data = data, !data.isEmpty else {
            completion(.success(nil))
            return
        }
        
        let result: Result<Response?, Error> = JSONSerializer.decode(data: data, keypath: keypath)
        
        completion(result)
    }
}
