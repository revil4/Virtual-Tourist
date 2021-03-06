//
//  Photo.swift
//  Virtual Tourist Udacity
//
//  Created by Moritz Gort on 16/03/16.
//  Copyright © 2016 Gabriele Gort. All rights reserved.
//

import Foundation
import UIKit
import CoreData

@objc(Photo)

public class Photo: NSManagedObject {
    
    @NSManaged public var imagePath: String
    @NSManaged public var flickrURL: NSURL
    @NSManaged public var pinLocation: PinLocation?
    
    override public var description: String {
        get {
            return self.flickrURL.path!
        }
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(location: PinLocation, imageURL: NSURL, context: NSManagedObjectContext) {
        let name = self.dynamicType.entityName()
        let entity = NSEntityDescription.entityForName(name, inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        self.flickrURL = imageURL
        self.imagePath = self.flickrURL.lastPathComponent!
        self.pinLocation = location
        if self.image == nil {
            _ = PhotoDownloadWorker(photo: self)
        }
    }
    
    public override func prepareForDeletion() {
        self.image = nil
    }
    
    var image: UIImage? {
        get {
            return ImageCache.sharedInstance().imageWithIdentifier("\(self.imagePath)")
        }
        set {
            ImageCache.sharedInstance().storeImage(newValue, withIdentifier: "\(self.imagePath)")
        }
    }
}

public func ==(lhs: Photo, rhs: Photo) -> Bool {
    return lhs.flickrURL.isEqual(rhs)
}