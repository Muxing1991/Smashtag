//
//  HistoryUITableViewController.swift
//  Smashtag
//
//  Created by 杨威 on 16/6/14.
//  Copyright © 2016年 demo. All rights reserved.
//

import UIKit
import CoreData

class HistoryUITableViewController: UITableViewController {
  

  
  //Context
  var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
  
  
  
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
  
  private class Constant{
    static let cellIdentifier = "searchHistoryCell"
    static let segue2TweetsIdentifier = "history2Search"
    static let segue2Popularity = "popularityDisplay"
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return UserData.sharedInstantce.searchHistory.count
  }
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(Constant.cellIdentifier, forIndexPath: indexPath)
    cell.textLabel?.text = UserData.sharedInstantce.searchHistory[indexPath.row]
    return cell
  }
  
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    //可以修改
    return true
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete{
      let tag = UserData.sharedInstantce.searchHistory[indexPath.row]
      UserData.sharedInstantce.searchHistoryRemoveAt(indexPath.row)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
      deleteManagedObjectFromDatabase(tag)
    }
  }
  
  //MARK: - CoreData
  //删除指定tag的mention
  private func deleteManagedObjectFromDatabase(tag: String){
    managedObjectContext?.performBlock{
      let request = NSFetchRequest(entityName: "Mention")
      request.predicate = NSPredicate(format: "tag = %@", tag)
      if let result = try? self.managedObjectContext?.executeFetchRequest(request){
        for item in result! {
          self.managedObjectContext?.deleteObject(item as! Mention)
        }
      }
    }
  }
  
  //点击执行segue
  override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier(Constant.segue2Popularity, sender: indexPath)
  }
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let id = segue.identifier{
      switch id {
      case Constant.segue2TweetsIdentifier:
        if let tvc = segue.destinationViewController as? TweetTableViewController{
          tvc.searchText = (sender as! UITableViewCell).textLabel?.text
        }
      case Constant.segue2Popularity:
        //TODO:
        if let popularityTVC = segue.destinationViewController as? PopularityTableViewController, let indexPath = sender as? NSIndexPath{
          //把点击那一行的搜索标签赋值给controller
          popularityTVC.query = UserData.sharedInstantce.searchHistory[indexPath.row]
          popularityTVC.context = managedObjectContext
        }
        break
      default:
        break
      }
    }
  }
  
}
