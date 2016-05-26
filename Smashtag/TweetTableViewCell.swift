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
      tweetTest?.text = tweet.text
      if tweetTest?.text != nil{
        for _ in tweet.media{
          tweetTest.text! += " 📷"
        }
      }
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
}
