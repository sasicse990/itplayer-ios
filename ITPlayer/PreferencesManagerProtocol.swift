//
//  PreferencesManagerProtocol.swift
//  ITPlayer
//
//  Created by Admin on 01/02/19.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation
import UIKit

protocol PreferencesManagerProtocol {
    var isUserLogged: Bool { get set }
    
    func removeSavedData()
}
