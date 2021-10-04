//
//  Requester.swift
//  The_Events
//
//  Created by Gabriel Mendonça on 02/10/21.
//

import Foundation
import UIKit
import SystemConfiguration

/// Closure that get the success requested object
/// - Parameter: object: Value (Generic)
typealias CompletionWithSuccess<Value> = ( (_ object: Value) -> Void )
typealias CompletionSuccess = ( () -> Void )

/// Closure that get the error
/// - Parameter: failure: Error
typealias CompletionWithFailure    = ( (_ failure: ErrorHandler.ErrorResponse) -> Void )
typealias CompletionFailure = ( () -> Void )

enum TimeoutRequestType: TimeInterval {
    case normal = 30.0
    case long = 60.0
}

class Requester {
    /// Variable that stores the environmet parâmeter.
    let env: String
    
    weak var task: URLSession?
    var executor: RequestExecutor
    
    /// Initializer with the selected environment
    /// - Parameter: environment: API.Environment
    init(withEnvironment environment: API.Environment) {
        env  = environment.getValue()
        task = URLSession.shared
        self.executor = NetworkingRequestExecutor()
    }
    
    /// Return the full URI to deal with the request
    /// - Parameter: endpoint: The given endpoint in String Format
    func urlComposer(using endpoint: Endpoint.EndpointType) -> (url: URL?, method: String) {
        let url = (url: URL(string: "\(env)\(endpoint.uri)"), method: endpoint.method)
        return url
    }
    
    func urlComposer(using endpoint: Endpoint.EndpointType, complement: String) -> (url: URL?, method: String) {
        let url = (url: URL(string: "\(env)\(endpoint.uri)/\(complement)"), method: endpoint.method)
        return url
    }
    
    /// Create an URLRequest Object with the given URL
    ///
    /// - Parameters:
    ///   - urlEndpoint: URL - The full URL to be requested
    ///   - headers: HeaderHandler.Header - The request headers
    ///   - body: [String: String] - The request body
    /// - Returns: URLRequest
    func requestComposer(using urlEndpoint: (url: URL?, method: String),
                         headers: HeaderHandler.Header,
                         body: [String: Any]? = nil) -> URLRequest {
        
        var request = URLRequest(url: urlEndpoint.url!)
        request.allHTTPHeaderFields = headers
        request.httpMethod = urlEndpoint.method
        
        if let body = body {
            let isGet = urlEndpoint.method == "GET"
            let isUrlEncoded = headers["Content-Type"] == "application/x-www-form-urlencoded"
            
            if isGet || isUrlEncoded {
                let paramsUrlEncoded = getParamsUrlEncoded(body: body)
                
                if isGet {
                    let urlEndpoint = urlEndpoint.url!.absoluteString + "?\(paramsUrlEncoded)"
                    request.url = URL(string: urlEndpoint)
                } else {
                    request.httpBody = paramsUrlEncoded.data(using: .utf8)
                }
            } else {
                let jsonData = try? JSONSerialization.data(withJSONObject: body)
                request.httpBody = jsonData
            }
        }
        
        return request
    }
    
    private func getParamsUrlEncoded(body: [String: Any]) -> String {
        var getParams = ""
        
        for key in body.keys {
            getParams += "\(key)=\(body[key]!)&"
        }
        let lastChar = getParams.index(getParams.endIndex, offsetBy: -1)
        let getParam = String(getParams[..<lastChar])
        
        return getParam
    }
    
    /// Session Configuration for all requests
    ///
    /// - Returns: URLSessionConfiguration
    func sessionConfigComposer(timeoutRequestType: TimeoutRequestType = .normal) -> URLSessionConfiguration {
        let urlSessionConfiguration = URLSessionConfiguration.default
        urlSessionConfiguration.urlCache = nil
        urlSessionConfiguration.urlCredentialStorage = nil
        urlSessionConfiguration.httpCookieAcceptPolicy = .always
        urlSessionConfiguration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        urlSessionConfiguration.timeoutIntervalForRequest = timeoutRequestType.rawValue
        
        if #available(iOS 11.0, *) {
            urlSessionConfiguration.waitsForConnectivity = false
        }
        return urlSessionConfiguration
    }
    
    func dataTask(using request: URLRequest,
                  completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: ErrorHandler.ErrorResponse?) -> Void) {
        let urlSession = URLSession(configuration: sessionConfigComposer())
        executor.execute(request: request, in: urlSession) { data, response, error in
            DispatchQueue.main.async {
                let error = self.checkForResponseErrors(using: data, response)
                completion(data, response, error)
            }
        }
    }
    
    func dataTask<T: Codable>(
        using request: URLRequest,
        success: @escaping (( _ response: T, _ response: URLResponse?) -> Void ),
        failure: @escaping ((_ error: ErrorHandler.ErrorResponse) -> Void )) {
        
        self.dataTask(using: request) { (data, response, error) in
            if error == nil {
                guard let data = data else {return}
                
                guard let responseDecoded = self.JSONDecode(to: T.self, from: data) else {
                    failure(ErrorHandler.ErrorResponse(errors: [ErrorHandler.ErrorMessage(code:
                        "\(ErrorHandler.Error.parseError.rawValue)",
                        message: "parece que algo saiu fora do previsto...")]))
                    return
                }
                success(responseDecoded, response)
            } else {
                failure(error!)
            }
        }
    }
    
    /// Basic parser to easily deal with object parse
    ///
    /// - Parameters:
    ///   - object: T - The Object type
    ///   - data: Data - The data that will be parsed to object
    /// - Returns: T?
    func JSONDecode<T: Codable>(to object: T.Type, from data: Data) -> T? {
        //        let dict = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        do {
            let object = try JSONDecoder().decode(T.self, from: data) as T
            return object
        } catch let error {
            if object != ErrorHandler.ErrorResponse.self {
                #if DEBUG
                print("\n❓JSONDecoder -> \(T.self): \(error)\n")
                #endif
            }
            
            return nil
        }
    }
    
    /// Checks for response errors based on status code
    ///
    /// - Parameter response: HTTPURLResponse - The HTTP response sended by the URLSession Request
    /// - Returns: ErrorHandler.Error? - Error handler enum
    func checkForResponseErrors(using data: Data?, andError error: Error? = nil, _ response: URLResponse?) -> ErrorHandler.ErrorResponse? {
        guard let data = data else {
            return nil
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            switch httpResponse.statusCode {
                case 200...204:
                    return  nil
                default: break
                
            }
        }
        let errorCheck = JSONDecode(to: ErrorHandler.ErrorMessage.self, from: data)
        
        guard let responseError = errorCheck else {
            let err = ErrorHandler.ErrorMessage(code: "-2", message: "parece que algo saiu fora do previsto...")
            return ErrorHandler.ErrorResponse(errors: [err])
        }
        
        let errorArr: ErrorHandler.ErrorResponse = ErrorHandler.ErrorResponse(errors: [responseError])
        
        return errorArr
    }
    
}
