//
//  Mentions.swift
//  Smashtag
//
//  Created by 杨威 on 16/6/6.
//  Copyright © 2016年 demo. All rights reserved.
//

import UIKit
class Mentions{
  //关于Mention的枚举 关联值为 类型 和 rows（行数）
  enum Mention{
    case Images([MediaItem])
    case Urls([Tweet.IndexedKeyword])
    case Hashtags([Tweet.IndexedKeyword])
    case UsersMention([Tweet.IndexedKeyword])
    
    var titleAndRows: (String, Int){
      switch self {
      case .Hashtags(let items):
        return ("Hashtags",items.count)
      case .Images(let items):
        return ("Images", items.count)
      case .Urls(let items):
        return ("Urls",items.count)
      case .UsersMention(let items):
        return ("UserMention",items.count)
      }
    }
    
    
  }
  //保存mention的数组
  var msg = [Mention]()
  var images: [MediaItem]?
  var urls: [Tweet.IndexedKeyword]?
  var hashtags: [Tweet.IndexedKeyword]?
  var usersMentions: [Tweet.IndexedKeyword]?
  
  //利用一个tweet 来完成初始化
  init(tweet: Tweet){
    if tweet.media.count>0{
      msg.append(.Images(tweet.media))
      self.images = tweet.media
    }
    if tweet.hashtags.count>0{
      msg.append(.Hashtags(tweet.hashtags))
      self.hashtags = tweet.hashtags
    }
    if tweet.urls.count>0{
      msg.append(.Urls(tweet.urls))
      self.urls = tweet.urls
    }
    if tweet.userMentions.count>0{
      msg.append(.UsersMention(tweet.userMentions))
      self.usersMentions = tweet.userMentions
    }
  }
}
