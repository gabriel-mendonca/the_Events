//
//  Reachability.swift
//  The_Events
//
//  Created by Gabriel Mendonça on 02/10/21.
//

import Foundation
import SystemConfiguration

public class Reachability {
    class func isConnectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in(sin_len: 0,
                                      sin_family: 0,
                                      sin_port: 0,
                                      sin_addr: in_addr(s_addr: 0),
                                      sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags(rawValue: 0)

        if let defaultRouteReachability = defaultRouteReachability,
            SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == false {
            return false
        }

        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret
    }
}

class PSReachability {
    static let shared = PSReachability()
    
    /// Check internet connection
    ///
    /// - Parameters:
    ///   - url: URL to check connection
    ///   - method: http method
    ///   - completion: completion handler with connection result
    func checkConnection(_ url: URL, method: String = "GET", completion: @escaping (_ isConnected: Bool) -> Void) {
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        request.cachePolicy = .reloadIgnoringCacheData
        request.httpMethod = method
        
        URLSession(configuration: .default).dataTask(with: request) { _, response, _ in
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            guard let code = statusCode, code >= 100 else {
                completion(false)
                return
            }
            completion(true)
        }.resume()
    }
}
