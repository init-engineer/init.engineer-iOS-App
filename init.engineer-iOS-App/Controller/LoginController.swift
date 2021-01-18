//
//  LoginController.swift
//  init.engineer-iOS-App
//
//  Created by horo on 6/8/20.
//  Copyright © 2020 Kantai Developer. All rights reserved.
//

import UIKit

protocol LoginCheckerProtocol {
    func isLoggingIn() -> Bool
}

class LoginController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func loginBtn(_ sender: Any) {
        AuthenticationManager.loginWithKaobeiAccount() { token in
            print("Get: \(token)")
        }
    }
}
