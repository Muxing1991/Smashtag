//
//  DetailLabelUITableViewCell.swift
//  Smashtag
//
//  Created by 杨威 on 16/6/8.
//  Copyright © 2016年 demo. All rights reserved.
//

import UIKit

class DetailLabelUITableViewCell: UITableViewCell {
  @IBOutlet weak var mentionLabel: UILabel!
  
  var mentiontext: String?{
    didSet{
      mentionLabel.text = mentiontext
      UpdateUI()
    }
  }
  func UpdateUI(){
    setNeedsDisplay()
  }
}
