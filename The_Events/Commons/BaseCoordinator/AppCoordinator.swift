//
//  AppCoordinator.swift
//  The_Events
//
//  Created by Gabriel Mendonça on 29/09/21.
//

import UIKit

class AppCoordinator {
    var window: UIWindow
    var homeCoordinator: HomeCoordinator!
    
    required init(window: UIWindow) {
        self.window = window
        self.window.makeKeyAndVisible()
    }
    
    func start() {
        homeCoordinator = HomeCoordinator(window: window)
        homeCoordinator.start()
    }
}
