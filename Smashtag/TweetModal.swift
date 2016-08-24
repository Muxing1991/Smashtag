//
//  TweetModal.swift
//  Smashtag
//
//  Created by 杨威 on 16/8/24.
//  Copyright © 2016年 demo. All rights reserved.
//

import Foundation
import CoreData


class TweetModal: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
  
  class func tweetModalWithTweetInfo(tweetInfo: Tweet, inManagedObjectContext context: NSManagedObjectContext) -> (TweetModal?, Bool?){
    let request = NSFetchRequest(entityName: "TweetModal")
    request.predicate = NSPredicate(format: "id = %@", tweetInfo.id!)
    if let result = (try? context.executeFetchRequest(request))?.first as? TweetModal{
      return (result, false)
    } else if let newTweet = NSEntityDescription.insertNewObjectForEntityForName("TweetModal", inManagedObjectContext: context) as? TweetModal{
      newTweet.id = tweetInfo.id
      newTweet.text = tweetInfo.text
      newTweet.created = tweetInfo.created
      newTweet.user = UserModal.userModalWithUserInfo(tweetInfo.user, inManagedObjectContext: context)
      return (newTweet, true)
      //mentions属性先放空 mention的初始化需要搜索标签
    }
    return (nil, nil)
  }
}
