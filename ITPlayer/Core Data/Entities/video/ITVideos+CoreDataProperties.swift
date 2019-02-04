//
//  ITVideos+CoreDataProperties.swift
//  ITPlayer
//
//  Created by Admin on 04/02/19.
//  Copyright © 2019 Test. All rights reserved.
//
//

import Foundation
import CoreData


extension ITVideos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ITVideos> {
        return NSFetchRequest<ITVideos>(entityName: "ITVideos")
    }

    @NSManaged public var id: Int64
    @NSManaged public var playBackTime: Float
    @NSManaged public var thumb: String?
    @NSManaged public var title: String?
    @NSManaged public var videoDescription: String?
    @NSManaged public var videoUrl: String?

}
