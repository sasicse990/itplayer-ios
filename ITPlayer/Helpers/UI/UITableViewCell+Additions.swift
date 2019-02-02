//
//  UITableViewCell+Additions.swift
//  ITPlayer
//
//  Created by Admin on 02/02/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    static var reuseIdentifier: String! {
        
        let className = String(describing: self)
        
        return className
    }
}

extension UITableViewHeaderFooterView {
    
    static var reuseIdentifier: String! {
        
        let className = String(describing: self)
        
        return className
    }
}
