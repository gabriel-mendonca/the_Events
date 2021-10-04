//
//  DetailsModel.swift
//  The_Events
//
//  Created by Gabriel Mendonça on 03/10/21.
//

import Foundation

struct DetailsModel: Codable {
    var people: [String]?
    var date: Double?
    var description: String?
    var image: String?
    var longitude: Double?
    var latitude: Double?
    var price: Double?
    var title: String?
    var id: String?
}
