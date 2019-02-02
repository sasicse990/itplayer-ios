//
//  ITVideos+CoreDataClass.swift
//  ITPlayer
//
//  Created by Admin on 02/02/19.
//  Copyright © 2019 Test. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ITVideos)
public class ITVideos: NSManagedObject {
    class func fetchRequest(for itemCode: Int64) -> ITVideos {
        
        let viewContext = CoreDataStack.shared.viewContext
        
        let request = ITVideos.fetchRequest() as NSFetchRequest
        
        let predicate = NSPredicate(format: "%K = %d", "id", itemCode)
        
        request.predicate = predicate
        
        request.fetchLimit = 1
        
        let fetchResults = try! viewContext.fetch(request)
        
        if fetchResults.isEmpty {
            let user = NSEntityDescription.insertNewObject(forEntityName: ITVideos.entityName(), into: viewContext) as! ITVideos
            user.id = itemCode
            return user
        } else {
            return fetchResults.first!
        }
}
    class func fetchVideoList() -> [ITVideos] {
        let viewContext = CoreDataStack.shared.viewContext
        
        let request = ITVideos.fetchRequest() as NSFetchRequest
        
        let fetchResults = try! viewContext.fetch(request)
        
        if fetchResults.isEmpty {
            return []
        } else {
            return fetchResults
        }
    }
    
    func populateWithDetails(representation: Dictionary<String, Any>) {
        if let aDescription = representation["description"] as? String {
            self.videoDescription = aDescription
        }
        
        if let videoID = representation["id"] as? String {
            self.id = Int64(videoID)!
        }
        
        if let aTitle = representation["title"] as? String  {
            self.title = aTitle
        }
        
        if let aUrl = representation["url"] as? String {
            self.videoUrl = aUrl
        }
        
        if let aUrl = representation["thumb"] as? String {
            self.thumb = aUrl
        }
    }
}
