//
//  UserModal+CoreDataProperties.swift
//  Smashtag
//
//  Created by 杨威 on 16/8/25.
//  Copyright © 2016年 demo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension UserModal {

    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var profileImageURL: String?
    @NSManaged var screenName: String?
    @NSManaged var tweets: NSSet?

}
