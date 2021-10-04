//
//  HomeViewModel.swift
//  The_Events
//
//  Created by Gabriel Mendonça on 29/09/21.
//

import UIKit

class HomeViewModel {
    
    var model: [EventModel]
    var coordinatorDelegate: HomeViewModelDelegate?
    var statusObservable: Observable<RequestStates<[EventModel]>>
    let imageMock = "http://lproweb.procempa.com.br/pmpa/prefpoa/seda_news/usu_img/Papel%20de%20Parede.png"
    
    init(with model: [EventModel]) {
        self.model = model
        self.statusObservable = Observable(RequestStates.loading)
    }
    
    func numberOfEvents() -> Int {
        return model.count
    }
    
    func setupImageUrl(get row: Int) -> URL? {
        if let image = model[row].image {
            return URL(string: image)
        }
        return nil
    }
    
    func fetchEvent(env: API.Environment? = nil) {
        API(withEnvironment: env).homeService.getEvents { [weak self] (response) in
            guard let self = self else { return }
            self.model = response
            self.statusObservable.value = .load(data: response)
        } onFailure: { [weak self] (error) in
            guard let self = self else { return }
            self.statusObservable.value = .errored(error: error)
        }

    }
    
    func goToDetailsEvent(id: String) {
        coordinatorDelegate?.sendDetailsEvent(id: id)
    }
    
    func handlerError() {
        
    }
}
