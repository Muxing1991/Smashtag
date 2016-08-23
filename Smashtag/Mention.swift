//
//  Mention.swift
//  Smashtag
//
//  Created by 杨威 on 16/8/23.
//  Copyright © 2016年 demo. All rights reserved.
//

import Foundation
import CoreData


class Mention: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
  

  //利用内容text 搜索标签tag 来查找 或者创建 mention
  class func mentionWithTextInfo(text: String, tag: String, inManagedObjectContext context: NSManagedObjectContext) -> Mention?{
    let request = NSFetchRequest(entityName: "Mention")
    request.predicate = NSPredicate(format: "text = %@ and tag = %@", text, tag)
    if let result = (try? context.executeFetchRequest(request))?.first as? Mention{
      result.timesPlusOne()
      return result
    } else if let newOne = NSEntityDescription.insertNewObjectForEntityForName("Mention", inManagedObjectContext: context) as? Mention{
      //插入一个成功的话 初始化相关值
      newOne.text = text
      newOne.tag = tag
      newOne.times = 1
      return newOne
    }
    return nil
  }
  
  
  func timesPlusOne(){
    guard  times != nil else { return }
    var n = times!.intValue
    n += 1
    times = NSNumber(int: n)
  }
  
}
