//
//  KaobeiTabBarController.swift
//  init.engineer-iOS-App
//
//  Created by 楊承昊 on 2021/2/2.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import UIKit

class KaobeiTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        if self.traitCollection.userInterfaceStyle == .dark {
            self.tabBar.tintColor = .green
        } else {
            self.tabBar.tintColor = .none
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.userInterfaceStyle == .dark {
            self.tabBar.tintColor = .green
        } else {
            self.tabBar.tintColor = .none
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true //(viewController != tabBarController.selectedViewController)
    }

}
