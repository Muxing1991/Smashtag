//
//  TwittersTableViewController.swift
//  Smashtag
//
//  Created by 杨威 on 16/8/21.
//  Copyright © 2016年 demo. All rights reserved.
//

import UIKit
import CoreData

class TwittersTableViewController: CoreDataTableViewController {
  
//  //MARK: - Modal
//  var mention: String?{
//    didSet{
//      updateUI()
//    }
//  }
//  
//  var context: NSManagedObjectContext?{
//    didSet{
//      updateUI()
//    }
//  }
//  
//  
//  //MARK: - Method
//  //当context 与 mention 有了值 构造NSFetchedResultsController 给 fetchedResultsController 
//  //fetchedResultsController自动抓取数据
//  private func updateUI(){
//    if let context = context where mention?.characters.count > 0{
//      let request = NSFetchRequest(entityName: "TwitterUserModal")
//      request.predicate = NSPredicate(format: "any tweets.text contains [c] %@", mention!)
//      //增加不分辨大小写 增加一个参数 seletor
//      request.sortDescriptors = [NSSortDescriptor(key: "num", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
//      fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//    } else {
//      fetchedResultsController = nil
//    }
//  }
//  private func tweetsCountByTweeter(user: TwitterUserModal) -> Int?{
//    var count: Int?
//    user.managedObjectContext?.performBlockAndWait({
//      let request = NSFetchRequest(entityName: "TweetModal")
//      request.predicate = NSPredicate(format: "text contains [c] %@ and tweeter = %@", self.mention!, user)
//      count = user.managedObjectContext?.countForFetchRequest(request, error: nil)
//    })
//    
//    return count
//  }
//  
//  
//  //MARK: - TableViewController Data Source
//  //CoreDataTableViewController 实现了 numberofsection numberofrowinsection  cell要自己实现
//  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCellWithIdentifier("TwitterCell", forIndexPath: indexPath)
//    
//    // 用fetchedResultsController来获取特定indexpath的对象
//    if let twitter = fetchedResultsController?.objectAtIndexPath(indexPath) as? TwitterUserModal{
//      //这里access 访问了database 所以 performBlock
//      var sName: String?
//      twitter.managedObjectContext?.performBlockAndWait({
//        sName = twitter.screenName
//      })
//      if let name = sName{
//        cell.textLabel?.text = "@\(name)"
//      }
//      //根据特定的用户去搜索 本次推文中 该用户有多少条记录
//      if let count = tweetsCountByTweeter(twitter){
//        cell.detailTextLabel?.text = "posted \(count) tweets"
//      }
//    }
//    
//    return cell
//  }

}
