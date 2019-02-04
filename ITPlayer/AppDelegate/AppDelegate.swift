//
//  AppDelegate.swift
//  ITPlayer
//
//  Created by Admin on 01/02/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate{

    fileprivate var preferencesManager: PreferencesManagerProtocol = UserDefaultsManager.shared

    var window: UIWindow?
    
    class func sharedDelegate() -> AppDelegate? {
        
        return UIApplication.shared.delegate as? AppDelegate
    }

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        guard let modelURL = Bundle.main.url(forResource: "ITPlayer", withExtension: "momd") else {
            fatalError("failed to locate core data bundle")
        }
        let coreDataConfiguration = CoreDataStackConfiguration(modelURL: modelURL)
        
        CoreDataStack.shared(with: coreDataConfiguration)
        
        let directory: URL? = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).last
        
        print("----****----\(directory?.path ?? "")")
        
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        GIDSignIn.sharedInstance().delegate = self
        
        setupViewControllers()

        return true
    }
    
    func setupViewControllers() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        var intialVC: UIViewController?
        
        if preferencesManager.isUserLogged  {
           intialVC = ITHomeViewController()
        } else {
           intialVC = ITLoginViewController()
        }
        
        let navigationController = UINavigationController(rootViewController: intialVC!)
        
        navigationController.setNavigationBarHidden(true, animated: false)
        
        window.rootViewController = navigationController
        
        window.makeKeyAndVisible()
        
        self.window = window
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print(error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
        print(credential)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print(error)
                return
            }
            // User is signed in
            // ...
            self.preferencesManager.isUserLogged = true
            
            self.setupViewControllers()
        }
        
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        print("Disconnected")
    }
}

    
