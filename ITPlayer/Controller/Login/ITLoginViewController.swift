//
//  ViewController.swift
//  ITPlayer
//
//  Created by Admin on 01/02/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ITLoginViewController: UIViewController {
    
    // MARK: - Properties
    
    fileprivate weak var signInButton: UIButton!
    
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNeedsStatusBarAppearanceUpdate()
        
        setupViews()
        
        GIDSignIn.sharedInstance().uiDelegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - User Interactions
    
    @objc fileprivate func signInButtonAction(_ sender: UIButton) {
        
        GIDSignIn.sharedInstance().signIn()
    }
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    // MARK: - Override Methods
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - UI and Constraints methods
    
    fileprivate func setupViews() {
        view.backgroundColor = UIColor.white
        
        let signInButton = UIButton()
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        signInButton.setTitle(NSLocalizedString("SignUp With Google", comment: ""), for: .normal)
        signInButton.setTitleColor(UIColor.white, for: .normal)
        signInButton.setTitleColor(UIColor.gray, for: .highlighted)
        signInButton.addTarget(self, action: #selector(signInButtonAction(_ :)), for: .touchUpInside)
        signInButton.layer.cornerRadius = 20.0
        signInButton.layer.masksToBounds = true
        
//        let logoutButton = UIButton()
//        logoutButton.translatesAutoresizingMaskIntoConstraints = false
//        logoutButton.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
//        logoutButton.setTitle(NSLocalizedString("logout", comment: ""), for: .normal)
//        logoutButton.setTitleColor(UIColor.white, for: .normal)
//        logoutButton.setTitleColor(UIColor.gray, for: .highlighted)
//        logoutButton.addTarget(self, action: #selector(logoutButton(_ :)), for: .touchUpInside)
//        logoutButton.layer.cornerRadius = 20.0
//        logoutButton.layer.masksToBounds = true
        
        view.addSubview(signInButton)
        //view.addSubview(logoutButton)

        self.signInButton = signInButton
       //self.logoutButton = logoutButton
        
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        signInButton.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
//        logoutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0).isActive = true
//        logoutButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20.0).isActive = true
//        logoutButton.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
//        logoutButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
    }
}

extension ITLoginViewController: GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print(error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        print(credential)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                 print(error)
                return
            }
            
        }
    }
    
}

