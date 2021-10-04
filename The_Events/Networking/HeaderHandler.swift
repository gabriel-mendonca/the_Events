//
//  HeaderHandler.swift
//  The_Events
//
//  Created by Gabriel Mendonça on 02/10/21.
//

import Foundation

struct HeaderHandler {
    typealias Header = [String: String]
    
    enum HeaderType {
        case basic
        case custom([String: String])
    }
    
    // User-Agent Header; see https://tools.ietf.org/html/rfc7231#section-5.5.3
    // Example: `App/1.0 (abc.bundle.com); build:1; iOS 10.0.0)`
    let userAgent: String = {
        if let info = Bundle.main.infoDictionary {
            let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
            let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
            let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
            let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"
            
            let osNameVersion: String = {
                let version = ProcessInfo.processInfo.operatingSystemVersion
                let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
                
                let osName: String = {
                    #if os(iOS)
                    return "iOS"
                    #elseif os(watchOS)
                    return "watchOS"
                    #elseif os(tvOS)
                    return "tvOS"
                    #elseif os(macOS)
                    return "OS X"
                    #elseif os(Linux)
                    return "Linux"
                    #else
                    return "Unknown"
                    #endif
                }()
                
                return "\(osName) \(versionString)"
            }()
            
            return "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion))"
        }
        
        return "Minha Conta"
    }()
    
    func generate(header: HeaderType) -> [String: String] {
        switch header {
            case .basic:
                return self.getBasicHeader()
            
            case .custom(let customHeader):
                return getCustomHeader(using: customHeader)
        }
    }
    
    // MARK: Header builder
    private func getBasicHeader() -> Header {
        let tokenPush: String = UserDefaults.standard.object(forKey: "token-push") as? String ?? ""
        let dictionary = ["X-UUID": Device.UIDD(),
                          "app_version": Device.appVersion(),
                          "device_os": Device.osVersion(),
                          "token-push": tokenPush,
                          "device_type": "0",
                          "device_model": "\(Device.version())",
            "Content-Type": "application/json",
            "User-Agent": userAgent]
        return dictionary
    }
    
    private func getCustomHeader(using dictionary: [String: String]) -> Header {
        return dictionary
    }
}
