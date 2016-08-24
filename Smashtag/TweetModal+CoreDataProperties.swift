//
//  TweetModal+CoreDataProperties.swift
//  Smashtag
//
//  Created by 杨威 on 16/8/24.
//  Copyright © 2016年 demo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TweetModal {

    @NSManaged var id: String?
    @NSManaged var text: String?
    @NSManaged var created: NSDate?
    @NSManaged var mentions: NSSet?
    @NSManaged var user: UserModal?

}
