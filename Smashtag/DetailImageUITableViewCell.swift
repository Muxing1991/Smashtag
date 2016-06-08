//
//  DatailImageUITableViewCell.swift
//  Smashtag
//
//  Created by 杨威 on 16/6/8.
//  Copyright © 2016年 demo. All rights reserved.
//

import UIKit

class DetailImageUITableViewCell: UITableViewCell {
  
  
  @IBOutlet weak var detailImage: UIImageView!
  
  var imageUrl: NSURL?{
    //开启线程 下载图片
    didSet{
      let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
      let queue = dispatch_get_global_queue(qos, 0)
      dispatch_async(queue){
        let imagedata = NSData(contentsOfURL: self.imageUrl!)
        if let data = imagedata{
          dispatch_async(dispatch_get_main_queue()){
            self.detailImage.image = UIImage(data: data )
          }
        }
      }
      UpdateUI()  
    }
  }
  func UpdateUI(){
    setNeedsDisplay()
  }
}
