//
//  RequestExecutor.swift
//  The_Events
//
//  Created by Gabriel Mendonça on 02/10/21.
//

import Foundation
import SystemConfiguration

/// Defines a protocol for any new executor
protocol RequestExecutor {
    func execute(request: URLRequest,
                 in session: URLSession,
                 completion: @escaping (Data?, URLResponse?, ErrorHandler.ErrorResponse?) -> Void)
}

/// Default networking class to execute requests
class NetworkingRequestExecutor: RequestExecutor {
    func execute(request: URLRequest,
                 in session: URLSession,
                 completion: @escaping (Data?, URLResponse?, ErrorHandler.ErrorResponse?) -> Void) {
        if Reachability.isConnectedToNetwork() {
            session.dataTask(with: request) { data, response, error in
                let error = self.checkForResponseErrors(using: data)
                self.debugResponse(request, data, response, error)
                if error == nil && data == nil {
                    let err = ErrorHandler.ErrorMessage(code: "-1004", message: "Não foi possivel conectar com o servidor. host nao foi encontrado.")
                    completion(data, response, ErrorHandler.ErrorResponse(errors: [err]))
                    return
                }
                completion(data, response, error)
            }.resume()
            session.finishTasksAndInvalidate()
        } else {
            let err = ErrorHandler.ErrorMessage(code: "-1009", message: "Sem conexão com a internet.")
            completion(nil, nil, ErrorHandler.ErrorResponse(errors: [err]))
        }
    }
    
    /// Checks for response errors based on status code
    ///
    /// - Parameter response: HTTPURLResponse - The HTTP response sended by the URLSession Request
    /// - Returns: ErrorHandler.Error? - Error handler enum
    func checkForResponseErrors(using data: Data?) -> ErrorHandler.ErrorResponse? {
        guard let data = data else {
            return nil
        }
        return JSONDecode(to: ErrorHandler.ErrorResponse.self, from: data)
    }
    
    /// Basic parser to easily deal with object parse
    ///
    /// - Parameters:
    ///   - object: T - The Object type
    ///   - data: Data - The data that will be parsed to object
    /// - Returns: T?
    func JSONDecode<T: Codable>(to object: T.Type, from data: Data) -> T? {
        do {
            let object = try JSONDecoder().decode(T.self, from: data) as T
            return object
        } catch {
            if object != ErrorHandler.ErrorResponse.self {
                #if DEBUG
                print("\n❓JSONDecoder -> \(T.self): \(error)\n")
                #endif
            }
            return nil
        }
    }
    
    // MARK: - DEBUGABLE RESPONSE
    func debugResponse(_ request: URLRequest, _ responseData: Data?, _ response: URLResponse?, _ error: ErrorHandler.ErrorResponse?) {
        #if DEBUG
        let uuid = UUID().uuidString
        print("\n↗️ ======= REQUEST =======")
        print("↗️ REQUEST #: \(uuid)")
        print("↗️ URL: \(request.url?.absoluteString ?? "")")
        print("↗️ HTTP METHOD: \(request.httpMethod ?? "GET")")
        
        if let requestHeaders = request.allHTTPHeaderFields,
            let requestHeadersData = try? JSONSerialization.data(withJSONObject: requestHeaders, options: .prettyPrinted),
            let requestHeadersString = String(data: requestHeadersData, encoding: .utf8) {
            print("↗️ HEADERS:\n\(requestHeadersString)")
        }
        
        if let requestBodyData = request.httpBody,
            let requestBody = String(data: requestBodyData, encoding: .utf8) {
            print("↗️ BODY: \n\(requestBody)")
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            print("\n↙️ ======= RESPONSE =======")
            switch httpResponse.statusCode {
            case 200...202:
                print("↙️ CODE: \(httpResponse.statusCode) - ✅")
            case 400...505:
                print("↙️ CODE: \(httpResponse.statusCode) - 🆘")
            default:
                print("↙️ CODE: \(httpResponse.statusCode) - ✴️")
            }
            
            if let responseHeadersData = try? JSONSerialization.data(withJSONObject: httpResponse.allHeaderFields, options: .prettyPrinted),
                let responseHeadersString = String(data: responseHeadersData, encoding: .utf8) {
                print("↙️ HEADERS:\n\(responseHeadersString)")
            }
            
            if let responseBodyData = responseData,
                let responseBody =  String(data: responseBodyData, encoding: .utf8),
                !responseBody.isEmpty {
                
                print("↙️ BODY:\n\(responseBody)\n")
            }
        }
        
        print("======== END OF: \(uuid) ========\n\n")
        #endif
    }
}

extension Data {
    func toString() -> String? {
        return String(data: self, encoding: .utf8)
    }
}
