//
//  LoginController.swift
//  init.engineer-iOS-App
//
//  Created by horo on 6/8/20.
//  Copyright © 2020 Kantai Developer. All rights reserved.
//

import UIKit
import AppAuth
import GoogleMobileAds

class LoginController: UIViewController, GADBannerViewDelegate {
    
    private var authState: OIDAuthState?
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if KeyChainManager.shared.getToken() != nil {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setupUI() {
        navigationItem.hidesBackButton = true
        // In this case, we instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: kGADAdSizeLargeBanner)
        bannerView.adUnitID = K.getInfoPlistByKey("GAD AdsBanner1") ?? ""
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
    }
    
    
    func loginFailed(failedMessage: String = "授權未成功 QAQ，請稍後再試") {
        let controller = UIAlertController(title: "OAuth 登入失敗", message: failedMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Peko~", style: .default, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let authorizationEndpoint = URL(string: "https://kaobei.engineer/oauth/authorize")!
        let tokenEndpoint = URL(string: "https://kaobei.engineer/oauth/token")!
        let configuration = OIDServiceConfiguration(authorizationEndpoint: authorizationEndpoint,
                                                    tokenEndpoint: tokenEndpoint)
        // builds authentication request
        let request = OIDAuthorizationRequest(configuration: configuration,
                                              clientId: K.getInfoPlistByKey("OAuth2 Client ID")!,
                                              clientSecret: K.getInfoPlistByKey("OAuth2 Client Secret")!,
                                              scopes: ["*"],
                                              redirectURL: URL(string: K.getInfoPlistByKey("OAuth2 Redirect URI")!)!,
                                              responseType: OIDResponseTypeCode,
                                              additionalParameters: nil)

        // performs authentication request
        print("Initiating authorization request with scope: \(request.scope ?? "nil")")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.currentAuthorizationFlow =
            OIDAuthState.authState(byPresenting: request, presenting: self) { authState, error in
                if let authState = authState {
                    self.authState = authState
                    print("Got authorization tokens. Access token: " +
                            "\(authState.lastTokenResponse?.accessToken ?? "nil")")
                    KeyChainManager.shared.saveToken((authState.lastTokenResponse?.accessToken)!)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    print("Authorization error: \(error?.localizedDescription ?? "Unknown error")")
                    self.authState = nil
                    self.loginFailed()
                }
            }
    }
}

extension LoginController {
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: bottomLayoutGuide,
                              attribute: .top,
                              multiplier: 1,
                              constant: 0),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
       }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        addBannerViewToView(bannerView)
    }
}
