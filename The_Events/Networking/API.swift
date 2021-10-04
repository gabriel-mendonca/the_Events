//
//  API.swift
//  The_Events
//
//  Created by Gabriel Mendonça on 02/10/21.
//

import Foundation

class API {
    enum Environment: String {
        case mock = "https://5f5a8f24d44d640016169133.mockapi.io/api"
        
        func getValue() -> String {
            return self.rawValue
        }
    }
    
    let environment: Environment
    
    init(withEnvironment env: Environment? = nil) {
        if let envi = env {
            environment = envi
        } else {
            environment = EnvConfig.baseURL
        }
    }
    
    
    lazy var homeService = HomeServiceApi(withEnvironment: environment)
    lazy var detailsServie = DetailsService(withEnvironment: environment)
}
