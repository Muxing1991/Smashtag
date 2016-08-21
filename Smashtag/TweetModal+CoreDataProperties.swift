//
//  TweetModal+CoreDataProperties.swift
//  Smashtag
//
//  Created by 杨威 on 16/8/21.
//  Copyright © 2016年 demo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TweetModal {

    @NSManaged var text: String?
    @NSManaged var posted: NSDate?
    @NSManaged var unique: String?
    @NSManaged var tweeter: TwitterUserModal?

}
