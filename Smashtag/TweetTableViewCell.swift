//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by 杨威 on 16/5/25.
//  Copyright © 2016年 demo. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
  
  @IBOutlet weak var tweetTest: UILabel!
  @IBOutlet weak var tweetName: UILabel!
  @IBOutlet weak var tweetAvatar: UIImageView!
  
  var tweet: Tweet?{
    didSet{
      updateUI()
    }
  }
  
  func updateUI(){
    //reset any existing tweet information 重置任何已经存在的信息
    tweetTest?.attributedText = nil
    tweetName?.text = nil
    tweetAvatar?.image = nil
    
    if let tweet = self.tweet{
      tweetTest?.attributedText = highLight(tweet)
      tweetName?.text = "\(tweet.user)"
      if let profileImageURL = tweet.user.profileImageURL{
        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
        let queue = dispatch_get_global_queue(qos, 0)
        dispatch_async(queue){
          let imageData = NSData(contentsOfURL: profileImageURL)
          dispatch_async(dispatch_get_main_queue()){
            self.tweetAvatar?.image = UIImage(data: imageData!)
            
          }
        }
        
        
      }
    }
  }
  func highLight(tweet: Tweet) -> NSAttributedString{
    var input = tweet.text!
    for _ in tweet.media{
      //在结尾加上字符 不会影响下面的NSRange
      input += " 📷"
    }
    let source = NSMutableAttributedString(string: input)
    //参照Twitter客户端 所有的mentions都是近似蓝色的 所以只用一种Attribute
    let attr = [NSForegroundColorAttributeName: UIColor.init(red: 27/255, green: 128/255, blue: 217/255, alpha: 1.0)]
    source.addAttributes(attr, indexKeywords: tweet.urls + tweet.hashtags + tweet.userMentions)
    return source
  }
  
}
//扩展NSMutableAttributedString
private extension NSMutableAttributedString{
  func addAttributes(attrs:[String: AnyObject], indexKeywords: [Tweet.IndexedKeyword]){
    for keyword in indexKeywords{
      self.addAttributes(attrs, range: keyword.nsrange)
    }
  }
}
