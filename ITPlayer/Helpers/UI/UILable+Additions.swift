//
//  UILable+Additions.swift
//  ITPlayer
//
//  Created by Admin on 02/02/19.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation

import UIKit

extension UILabel{
    
    class func defaultLabel(backgroundcolor: UIColor?, textColor: UIColor?, textFont: UIFont?) -> UILabel {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.numberOfLines = 0
        
        label.backgroundColor = backgroundcolor
        
        label.textColor = textColor
        
        label.font = textFont
        
        return label
        
    }
}

