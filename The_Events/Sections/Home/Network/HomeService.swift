//
//  HomeService.swift
//  The_Events
//
//  Created by Gabriel Mendonça on 02/10/21.
//

import Foundation

class HomeServiceApi: Requester {
    
    func getEvents(onSucess: @escaping CompletionWithSuccess<[EventModel]>, onFailure: @escaping CompletionWithFailure) {
        let header = HeaderHandler().generate(header: .basic)
        let url = urlComposer(using: Endpoint.event)
        let request = requestComposer(using: url, headers: header)
        dataTask(using: request) { (info: [EventModel], response) in
            onSucess(info)
        } failure: { (error) in
            onFailure(error)
        }

    }
    
}
