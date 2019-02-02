//
//  BaseObject.swift
//  ITPlayer
//
//  Created by Admin on 02/02/19.
//  Copyright © 2019 Test. All rights reserved.
//

import CoreData

extension NSManagedObject {
    
    class func entityName() -> String {
        
        return NSStringFromClass(self)
    }
}
