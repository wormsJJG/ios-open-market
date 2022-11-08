//
//  Cordinator.swift
//  Solution
//
//  Created by 정재근 on 2022/10/30.
//

import UIKit

class Cordinator {
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let rootViewContoller = MainViewController()
        let navigationRootViewController = UINavigationController(rootViewController: rootViewContoller)
        window.rootViewController = navigationRootViewController
        window.makeKeyAndVisible()
    }
}
