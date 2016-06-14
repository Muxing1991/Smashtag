//
//  HistoryUITableViewController.swift
//  Smashtag
//
//  Created by 杨威 on 16/6/14.
//  Copyright © 2016年 demo. All rights reserved.
//

import UIKit

class HistoryUITableViewController: UITableViewController {
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "SearchQueryHistory"
    tableView.estimatedRowHeight = tableView.rowHeight
    tableView.rowHeight = UITableViewAutomaticDimension
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    //每次出现前更新数据
    tableView.reloadData()
  }
 
  
 override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return UserData.sharedInstantce.searchHistory.count
  }
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = UserData.sharedInstantce.searchHistory[indexPath.row]
    return cell
  }
  
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    //可以修改
    return true
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete{
      UserData.sharedInstantce.searchHistoryRemoveAt(indexPath.row)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
  }
  
}
