//
//  UserDefaultsManager.swift
//  ITPlayer
//
//  Created by Admin on 01/02/19.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation

import UIKit

extension UserDefaults {
    func set<T>(_ value: T?, forKey key: UserDefaultsManager.Key) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func value<T>(forKey key: UserDefaultsManager.Key) -> T? {
        return value(forKey: key.rawValue) as? T
    }
}

class UserDefaultsManager: PreferencesManagerProtocol {
    
    static let shared = UserDefaultsManager()
    
    private init() {
        setupDefaultValue()
    }
}

extension UserDefaultsManager {
    enum Key: String, CaseIterable {
        case isUserLogged = "fr.appsolute.tutorial.is.user.logged.key"
    }
    
    var isUserLogged: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: .isUserLogged)
        }
        get {
            return UserDefaults.standard.value(forKey: .isUserLogged)!
        }
    }
    
    fileprivate func setupDefaultValue() {
        
        UserDefaults.standard.register(defaults: [Key.isUserLogged.rawValue : false])
        
    }
    
    func removeSavedData() {
        Key.allCases.forEach {
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
        }
    }
}
