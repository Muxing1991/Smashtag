//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by 杨威 on 16/5/24.
//  Copyright © 2016年 demo. All rights reserved.
//

import UIKit
import CoreData

class TweetTableViewController: UITableViewController,UITextFieldDelegate {
  
  //Core Data 上下文
  var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
  
  //model 
  var tweets = [[Tweet]]()
  //设为最后一次查询的结果
  var searchText: String? = UserData.sharedInstantce.lastRecentSearchQuery {
    didSet{
      lastSuccessRequest = nil
      //清空model
      SearchTextField.text = searchText
      UserData.sharedInstantce.newSearchQueryInsert(searchText!)
      tweets.removeAll()
      self.tableView.reloadData()
      
      refresh()     
    }
  }
  var lastSuccessRequest: TwitterRequest?
  var nextRequestToAttempt: TwitterRequest?{
    if lastSuccessRequest == nil {
      if let text = searchText{
        return TwitterRequest(search: text, count: 100)
      }
      else {
        return nil
      }
    }
    else {
      return lastSuccessRequest!.requestForNewer
    }
  }
  
  
  @IBAction func refresh(sender: UIRefreshControl?) {
    if searchText != nil {
      if let request = nextRequestToAttempt{
        request.fetchTweets{
          (newTweets) -> Void in
          if newTweets.count > 0 {
            dispatch_async(dispatch_get_main_queue()){
              self.tweets.insert(newTweets, atIndex: 0)
              self.lastSuccessRequest = request
              self.tableView.reloadData()
              sender?.endRefreshing()
              self.updateDatabase(newTweets)
            }
          }
          else{
            //没有结果 也要停止
            sender?.endRefreshing()
          }
        }
      }
    }
    else {
      sender?.endRefreshing()
    }

  }
  
  func refresh(){
    if refreshControl != nil{
      refreshControl!.beginRefreshing()
    }
    refresh(refreshControl)
  }

  @IBOutlet weak var SearchTextField: UITextField!{
    didSet{
      SearchTextField.delegate = self
      SearchTextField.text = searchText
      
    }
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    //如果参数就是outlet
    if textField == SearchTextField{
      //隐藏键盘
      textField.resignFirstResponder()
      searchText = textField.text
      //插入查询的字符
      
    }
    return true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //估计的高度为storyboard的高度
    tableView.estimatedRowHeight = tableView.rowHeight
    //根据autolayout自动
    tableView.rowHeight = UITableViewAutomaticDimension
    refresh()
    
    //MARK: attributedText 测试
//    SearchTextField.attributedText = NSAttributedString(string: "#trump", attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.blueColor()])
  }
  
  struct MyContant{
    static private let cellIdentifier = "tweetCell"
    static private let showMentions = "showMentions"
  }
  //MARK: Unwind segue goback
  @IBAction func goBack(segue: UIStoryboardSegue){
    print("when unwind segue back to presenter you will see this")
  }
  
  //MARK: tableView dataSource
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return tweets.count
  }
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets[section].count
  }
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(MyContant.cellIdentifier, forIndexPath: indexPath) as! TweetTableViewCell
    cell.tweet = tweets[indexPath.section][indexPath.row]
    return cell
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == MyContant.showMentions{
      if let detail = segue.destinationViewController as? DetailUITableViewController {
        if let cell = sender as? TweetTableViewCell{
          detail.mentions = Mentions(tweet: cell.tweet!)
          if let indexPathSelect = tableView.indexPathForSelectedRow{
            detail.userName = tweets[indexPathSelect.section][indexPathSelect.row].user.name
          }
        }
      }
    }
  }
  
  //MARK: - Core Data
  private func updateDatabase(tweets: [Tweet]){
    managedObjectContext?.performBlock({ 
      for tweetInfo in tweets {
       _ = TweetModal.tweetModalWithTweetInfo(tweetInfo, inmanagedObjectContext: self.managedObjectContext!)
      }
      do {
        try self.managedObjectContext?.save()
      } catch let error{
        print("Core Data has error: \(error)")
      }
    })
  }
}
