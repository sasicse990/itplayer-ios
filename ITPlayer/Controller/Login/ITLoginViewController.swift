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
        
        GIDSignIn.sharedInstance().uiDelegate = self

        setNeedsStatusBarAppearanceUpdate()
        
        setupViews()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        
        navigationController?.navigationBar.barTintColor = UIColor.clear
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationController?.navigationBar.shadowImage = UIImage()
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
        
        view.addSubview(signInButton)
        
        self.signInButton = signInButton
        
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        signInButton.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
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


