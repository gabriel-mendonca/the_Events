//
//  RequestStates.swift
//  The_Events
//
//  Created by Gabriel Mendonça on 02/10/21.
//

import Foundation

enum RequestStates<T> {
    case loading
    case errored(error: ErrorHandler.ErrorResponse)
    case load(data: T)
    case empty
}
