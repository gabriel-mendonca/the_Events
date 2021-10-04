//
//  ErrorHandler.swift
//  The_Events
//
//  Created by Gabriel Mendonça on 02/10/21.
//

import Foundation

struct ErrorHandler: Codable {
    
    enum Error: Int, Codable {
        //generic error
        case timeout = -1001
        case unknown = -1
        case parseError = -2
    }
    
    struct ErrorResponse: Codable {
        var errors: [ErrorMessage]
    }
    
    
    struct ErrorMessage: Codable {
        var errorType: Error? {
            guard let code = Int(self.code) else { return Error.unknown}
            if let selectedError = Error(rawValue: code) {
                return selectedError
            }
            return Error.unknown
        }
        
        var code: String
        var message: String
    }
}
