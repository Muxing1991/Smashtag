//
//  PopularityTableViewController.swift
//  Smashtag
//
//  Created by 杨威 on 16/8/23.
//  Copyright © 2016年 demo. All rights reserved.
//

import UIKit
import CoreData

class PopularityTableViewController: CoreDataTableViewController{
  
  
  //Modal
  var query: String?{
    didSet{
      updateUI()
    }
  }
  
  var context: NSManagedObjectContext?{
    didSet{
      updateUI()
    }
  }
  
  //MARK: - Constant
  private struct Constant{
    static let cellIdentifier = "popularCell"
  }
  
  
  private func updateUI(){
    //构造NSFetchRequest 赋值给 fetchedResultsController
    if let context = context where query?.characters.count > 0{
      let request = NSFetchRequest(entityName: "Mention")
      request.predicate = NSPredicate(format: "tag = %@ and times > 1", query!)
      //先按照次数排序 再按照无大小写区别的 内容排序
      request.sortDescriptors = [
      NSSortDescriptor(key: "times", ascending: false),
      NSSortDescriptor(key: "text", ascending: true ,selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
      ]
      //为重要属性fetchedResultsController赋值
      fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    } else {
      fetchedResultsController = nil 
    }
  }
  
  
  //MARK: - TableView Data Source
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier(Constant.cellIdentifier, forIndexPath: indexPath)
    if let mention = fetchedResultsController?.objectAtIndexPath(indexPath) as? Mention{
      //访问mention的属性 就是访问数据库 
      var text: String?
      var times: Int?
      context?.performBlockAndWait{
        text = mention.text
        times = mention.times?.integerValue
      }
      if let text = text , let times = times{
        cell.textLabel?.text = text
        cell.detailTextLabel?.text = "posted \(times) times"
      }
    }
    
    
    return cell 
  }
}
