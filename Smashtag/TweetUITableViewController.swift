//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by 杨威 on 16/5/24.
//  Copyright © 2016年 demo. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController,UITextFieldDelegate {
  
  //model 
  var tweets = [[Tweet]]()
  var searchText: String? = "#stanford" {
    didSet{
      lastSuccessRequest = nil
      //清空model
      SearchTextField.text = searchText
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
            }
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
    if textField == SearchTextField{
      //隐藏键盘
      textField.resignFirstResponder()
      searchText = textField.text
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
  
}
