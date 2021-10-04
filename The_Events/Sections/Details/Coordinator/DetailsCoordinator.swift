//
//  DetailsCoordinator.swift
//  The_Events
//
//  Created by Gabriel Mendonça on 03/10/21.
//

import UIKit

class DetailsCoordinator: BaseCoordinator {
    
    var presentationType: PresentationType?
    var navigation: UINavigationController?
    var view: DetailsViewController?
    var viewModel: DetailsViewModel!
    var model: DetailsModel!
    var id: String!
    
    init(id: String) {
        model = DetailsModel()
        viewModel = DetailsViewModel(with: model!)
        viewModel.coordinatorDelegate = self
        navigation = UINavigationController()
        let viewController = DetailsViewController(id: id, viewModel: viewModel)
        view = viewController
        
    }
    
    func stop() {
        view = nil
        viewModel = nil
    }
}

extension DetailsCoordinator: DetailsViewModelDelegate {
    
}
