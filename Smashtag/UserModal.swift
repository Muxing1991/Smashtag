//
//  UserModal.swift
//  Smashtag
//
//  Created by 杨威 on 16/8/24.
//  Copyright © 2016年 demo. All rights reserved.
//

import Foundation
import CoreData


class UserModal: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

  //利用一个User来从数据库中初始化或者检索出一个 UserModal
  class func userModalWithUserInfo(user: User, inManagedObjectContext context: NSManagedObjectContext) -> UserModal?{
    
    let request = NSFetchRequest(entityName: "UserModal")
    request.predicate = NSPredicate(format: "screenName = %@", user.screenName)
    if let result = (try? context.executeFetchRequest(request))?.first as? UserModal{
      return result
    } else if let newUser = NSEntityDescription.insertNewObjectForEntityForName("UserModal", inManagedObjectContext: context) as? UserModal{
      newUser.id = user.id
      newUser.screenName = user.screenName
      newUser.name = user.name
      newUser.profileImageURL = user.profileImageURL?.absoluteString
      //tweets 属性先空着 待初始化TweetModal时 绑定
      return newUser
    }
    return nil
  }
}
