//
//  Utils.swift
//  The_Events
//
//  Created by Gabriel Mendonça on 04/10/21.
//

import Foundation

extension Date {
    
    enum FormatStyle: String {
        case dateIso = "yyyy-MM-dd'T'HH:mm:ss"
        case dateIso2 = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        case longDate = "dd/MM/yyyy - HH:mm"
    }
    func toString(with format: FormatStyle) -> String {
        return toString(withFormat: format.rawValue)
    }
    
    func toString(withFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = withFormat
        dateFormatter.locale = Locale(identifier: "pt_BR")
        return dateFormatter.string(from: self)
    }
}
