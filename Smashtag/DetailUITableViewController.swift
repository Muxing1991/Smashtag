//
//  DetailUITableViewController.swift
//  Smashtag
//
//  Created by 杨威 on 16/6/6.
//  Copyright © 2016年 demo. All rights reserved.
//

import UIKit

class DetailUITableViewController: UITableViewController {
  var mentions: Mentions?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  //MARK: tableview.datasource
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return mentions!.msg.count
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let (_, rows) = mentions?.msg[section].titleAndRows{
      return rows
    }
    return 0
  }
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if let (title, _) = mentions?.msg[section].titleAndRows{
      return title
    }
    return nil
  }
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //取出section的成员 进行switch匹配 重复代码！
    switch mentions!.msg[indexPath.section]{
    case .Images(let mediaItems):
      let cell = tableView.dequeueReusableCellWithIdentifier("detailImage", forIndexPath: indexPath) as! DetailImageUITableViewCell
      cell.imageUrl = mediaItems[indexPath.row].url
      return cell
    case .Hashtags(let items):
    let cell = tableView.dequeueReusableCellWithIdentifier("detailLabel", forIndexPath: indexPath) as! DetailLabelUITableViewCell
      cell.mentionLabel.text = items[indexPath.row].keyword
      return cell
    case .Urls(let items):
      let cell = tableView.dequeueReusableCellWithIdentifier("detailLabel", forIndexPath: indexPath) as! DetailLabelUITableViewCell
      cell.mentionLabel.text = items[indexPath.row].keyword
      return cell
    case .UsersMention(let items):
      let cell = tableView.dequeueReusableCellWithIdentifier("detailLabel", forIndexPath: indexPath) as! DetailLabelUITableViewCell
      cell.mentionLabel.text = items[indexPath.row].keyword
      return cell
    }
  }
  //设定行高   根据不同的section
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch mentions!.msg[indexPath.section]{
    case .Images(_):
      //以设备的宽为rect的长 长为宽的1.5倍 好像比较好
      let rowHeight = view.bounds.width / 1.5
      return rowHeight
      
    default:
      return UITableViewAutomaticDimension
    }
  }
  
}