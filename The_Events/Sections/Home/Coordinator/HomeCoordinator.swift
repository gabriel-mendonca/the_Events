//
//  HomeCoordinator.swift
//  The_Events
//
//  Created by Gabriel Mendonça on 29/09/21.
//

import UIKit

class HomeCoordinator: BaseCoordinator {
    var navigation: UINavigationController?
    var presentationType: PresentationType?
    var view: HomeViewController?
    var viewModel: HomeViewModel!
    var model: [EventModel]!
    var window: UIWindow
    
    var detailsCoordinator: DetailsCoordinator!
    
    
    required init(window: UIWindow) {
        self.window = window
    }
    
    
    func start() {
        model = [EventModel]()
        viewModel = HomeViewModel(with: model!)
        viewModel.coordinatorDelegate = self
        view = HomeViewController(viewModel: viewModel)
        navigation = UINavigationController(rootViewController: view!)
        window.rootViewController = navigation
    }
    
    func stop() {
        view = nil
        viewModel = nil
        navigation = nil
    }
    
    func goDetailsEvent(id: String) {
        guard let navigation = navigation else { return }
        detailsCoordinator = DetailsCoordinator(id: id)
        detailsCoordinator.start(usingPresentation: .push(navigationController: navigation), animated: true)
    }
}


extension HomeCoordinator: HomeViewModelDelegate {
    func sendDetailsEvent(id: String) {
        goDetailsEvent(id: id)
    }
    
    
    
}
