//
//  KaobeiTabBarController.swift
//  init.engineer-iOS-App
//
//  Created by 楊承昊 on 2021/2/2.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import UIKit

class KaobeiTabBarController: UITabBarController, UITabBarControllerDelegate {
    var reviewFragment: UINavigationController?
    var publishFragment: UINavigationController?
    var dashboardFragment: UINavigationController?
    var expirationPopup: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        if self.traitCollection.userInterfaceStyle == .dark {
            self.tabBar.tintColor = .green
        } else {
            self.tabBar.tintColor = .none
        }
        
        guard let VCs = self.viewControllers else { return }
        self.reviewFragment = VCs[1] as? UINavigationController
        self.publishFragment = VCs[2] as? UINavigationController
        self.dashboardFragment = VCs[3] as? UINavigationController
        
        if KeyChainManager.shared.getToken() == nil {
            self.viewControllers?.replaceSubrange(2...4, with: repeatElement(UIStoryboard(name: "LoginView", bundle: nil).instantiateViewController(identifier: "LoginController"), count: 1))
        }
    }
    
    func expiredTimeoutToLogout() {
        KeyChainManager.shared.deleteToken()
        
        if expirationPopup == nil {
            expirationPopup = UIAlertController(title: "您的登入時效已過", message: "Token 已過期，請重新登入。", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Peko~", style: .default) { [weak self] _ in
                self?.signedOut()
                self?.expirationPopup = nil
            }
            expirationPopup!.addAction(okAction)
            present(expirationPopup!, animated: true, completion: nil)
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
        return true
    }
    
    func signedIn() {
        if self.viewControllers?.count != 2 {
            return
        }
        guard let review = self.reviewFragment, let publish = self.publishFragment, let dashboard = self.dashboardFragment else { return }
        let VCs = [review, publish, dashboard]
        
        self.viewControllers?.replaceSubrange(1...1, with: VCs)
        self.selectedIndex = 3
        if let reviewList = self.reviewFragment?.topViewController as? ReviewTabController {
            guard reviewList.reviewTable != nil else { return }
            reviewList.reloadReviews()
        }
    }
    
    func signedOut() {
        if self.viewControllers?.count != 4 {
            return
        }
        self.viewControllers?.replaceSubrange(1...3, with: repeatElement(UIStoryboard(name: "LoginView", bundle: nil).instantiateViewController(identifier: "LoginController"), count: 1))
        self.selectedIndex = 1
        
        self.reviewFragment?.popToRootViewController(animated: false)
    }

}
