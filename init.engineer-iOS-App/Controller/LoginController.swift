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
import NVActivityIndicatorView

class LoginController: UIViewController, GADBannerViewDelegate {
    
    private var authState: OIDAuthState?
    var bannerView: GADBannerView!
    
    var loadingView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .randomPick(), color: .cyan, padding: .none)
    
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
        bannerView.adUnitID = K.getInfoPlistByKey("GAD Login") ?? ""
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
        
        self.loadingView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.loadingView)
        NSLayoutConstraint.init(item: self.loadingView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint.init(item: self.loadingView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
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
            OIDAuthState.authState(byPresenting: request, presenting: self) { [weak self] authState, error in
                if let authState = authState {
                    self?.authState = authState
                    print("Got authorization tokens. Access token: " +
                            "\(authState.lastTokenResponse?.accessToken ?? "nil")")
                    KeyChainManager.shared.saveToken((authState.lastTokenResponse?.accessToken)!)
                    //self.navigationController?.popViewController(animated: true)
                    if let tabbarVC = self?.tabBarController as? KaobeiTabBarController {
                        self?.loadingView.startAnimating()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            tabbarVC.signedIn()
                            self?.loadingView.stopAnimating()
                        }
                    }
                } else {
                    print("Authorization error: \(error?.localizedDescription ?? "Unknown error")")
                    self?.authState = nil
                    self?.loginFailed()
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
                              toItem: view.safeAreaLayoutGuide,
                              attribute: .bottom,
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
