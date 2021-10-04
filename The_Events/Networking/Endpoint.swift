//
//  Endpoint.swift
//  The_Events
//
//  Created by Gabriel Mendonça on 02/10/21.
//

import Foundation

public class Endpoint {
    typealias EndpointType = (uri: String, method: String)
    
    struct HTTPMethod {
        static let get = "GET"
        static let post = "POST"
    }
    
    static let event: EndpointType = (uri: "/events", method: HTTPMethod.get)
    static func details(id: String) -> EndpointType {
        return (uri: "/events/\(id)", method: HTTPMethod.get)
    }
}
