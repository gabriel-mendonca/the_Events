//
//  DetailsService.swift
//  The_Events
//
//  Created by Gabriel Mendonça on 03/10/21.
//

import Foundation

class DetailsService: Requester {
    
    
    func getDetailsEvent(id: String, onSucess: @escaping CompletionWithSuccess<DetailsModel>, onFailure: @escaping CompletionWithFailure) {
        let header = HeaderHandler().generate(header: .basic)
        let url = urlComposer(using: Endpoint.details(id: id))
        let request = requestComposer(using: url, headers: header)
        dataTask(using: request) { (info: DetailsModel, response) in
            onSucess(info)
        } failure: { (error) in
            onFailure(error)
        }

    }
}
