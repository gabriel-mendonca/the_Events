//
//  Observable.swift
//  The_Events
//
//  Created by Gabriel Mendonça on 03/10/21.
//

import Foundation

class Observable<T> {
    fileprivate var _value: T?
    var didChange: ((T) -> Void)?
    var value: T {
        set {
            _value = newValue
            didChange?(_value!)
        }
        get {
            return _value!
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    deinit {
        _value = nil
        didChange = nil
    }
}
