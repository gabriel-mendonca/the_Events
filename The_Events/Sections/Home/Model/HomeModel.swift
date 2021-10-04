//
//  HomeModel.swift
//  The_Events
//
//  Created by Gabriel Mendonça on 02/10/21.
//

import Foundation


struct ResultEvent: Codable {
    var result: [EventModel]?
}

struct EventModel: Codable {
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
