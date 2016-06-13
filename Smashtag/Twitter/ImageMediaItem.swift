//
//  ImageMediaItem.swift
//  Smashtag
//
//  Created by 杨威 on 16/6/11.
//  Copyright © 2016年 demo. All rights reserved.
//

import UIKit
 public class ImageMediaItem{
  public var image: UIImage
  public var aspectRatio: Double
  
  public init(image: UIImage, aspectRatio: Double){
    self.aspectRatio = aspectRatio
    self.image = image
  }
}