//
//  DetailsViewModel.swift
//  The_Events
//
//  Created by Gabriel Mendonça on 03/10/21.
//

import Foundation

class DetailsViewModel {
    
    var model: DetailsModel!
    var coordinatorDelegate: DetailsViewModelDelegate?
    var statusObservable: Observable<RequestStates<DetailsModel>>
    
    init(with model: DetailsModel) {
        self.model = model
        self.statusObservable = Observable(RequestStates.loading)
    }
    
    func getDetailsEvent(env: API.Environment? = nil, id: String) {
        API(withEnvironment: env).detailsServie.getDetailsEvent(id: id) { [weak self] (response) in
            guard let self = self else { return }
            self.model = response
            self.statusObservable.value = .load(data: response)
        } onFailure: { [weak self] (error) in
            guard let self = self else { return }
            self.statusObservable.value = .errored(error: error)
        }
    }
}
