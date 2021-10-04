//
//  BaseCoordinator.swift
//  The_Events
//
//  Created by Gabriel Mendonça on 29/09/21.
//

import Foundation
import UIKit

enum PresentationType {
    case push(navigationController: UINavigationController)
    case modal(viewController: UIViewController)
    
    func associatedValue() -> Any? {
        switch self {
        case .push(let value):
            return value
        case .modal(let value):
            value.modalPresentationStyle = .fullScreen
            return value
        }
    }
}

protocol BaseCoordinator: AnyObject {
    associatedtype V: UIViewController
    
    var view: V? { get set }
    var navigation: UINavigationController? { get set }
    var presentationType: PresentationType? { get set }
    
    func start() -> V
    
    func start(usingPresentation presentation: PresentationType, animated: Bool)
    
    func stop()
}

extension BaseCoordinator {
    
    func start() -> V {
        if view == nil {
            fatalError("you cannot start coordinator without initalize property view!")
        }
        return self.view!
    }
    
    func start(usingPresentation presentation: PresentationType, animated: Bool) {
        presentationType = presentation
        print(presentation.associatedValue() ?? "none")
        switch presentationType {
        case .push(let navigation):
            self.navigation = navigation
            navigation.pushViewController(start(), animated: animated)
        case .modal(let navigation):
            self.navigation = UINavigationController(rootViewController: start())
            guard let nav = self.navigation else { return }
            nav.modalPresentationStyle = .fullScreen
            navigation.present(nav, animated: animated, completion: nil)
        case .none:
            break
        }
    }
}
