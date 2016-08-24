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
    if let text = searchText {
      if let request = nextRequestToAttempt{
        request.fetchTweets{
          [weak self]
          (newTweets) -> Void in
          if newTweets.count > 0 {
            dispatch_async(dispatch_get_main_queue()){
              self?.tweets.insert(newTweets, atIndex: 0)
              self?.lastSuccessRequest = request
              self?.tableView.reloadData()
              sender?.endRefreshing()
              self?.updateMentionDatabase(newTweets,tag: text)
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
    
    
  }
  
  struct MyContant{
    static private let cellIdentifier = "tweetCell"
    static private let showMentions = "showMentions"
    static private let twittersCellIdentifier = "DisplayTwitters"
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
    } else if segue.identifier == MyContant.twittersCellIdentifier{
      //对Twitter按钮的segue进行prepare
      //      if let TTVC = segue.destinationViewController as? TwittersTableViewController{
      //        TTVC.context = self.managedObjectContext
      //        TTVC.mention = SearchTextField.text
      //      }
    }
  }
  
  //MARK: - Core Data

  //利用获取的tweet数组 和 请求的字符串 构造一些 mention
  private func updateMentionDatabase(tweets: [Tweet], tag: String){
    managedObjectContext?.performBlock{
      [weak weakself = self] in
      for item in tweets{
        //判断是否已经存在 创建一组 TweetModal UserModal 与 Mention
        let (tweet, isNew) = TweetModal.tweetModalWithTweetInfo(item, inManagedObjectContext: weakself!.managedObjectContext!)
        //当新建成功时 进行mention的初始化
        //如果tweet已经存在了 没必要再初始化其mention 并添加进去
        guard tweet != nil && isNew == true else { return }
        let mentionOfTweet = tweet!.mutableSetValueForKey("mentions")
        let allMentions = item.hashtags.map{ return $0.keyword } + item.userMentions.map{ return $0.keyword }
        for mention in allMentions{
          if let newMention = Mention.mentionWithTextInfo(mention, tag: tag, inManagedObjectContext: weakself!.managedObjectContext!){
            //为tweet的mentions属性 集合 添加 mention成员 执行绑定
            //其实没必要绑定 只需要在新的tweet的condition中执行上一步的mentionWithTextInfo  
            //建立这些Entities 只是为了扩展性
            mentionOfTweet.addObject(newMention)
          }
        }
        self.printCountOfMentionInTweet(tweet!)
      }
      //记得手动保存
      do{
        try weakself?.managedObjectContext?.save()
      } catch let error{
        print("autoSave failure error: \(error)")
      }
      print("autoSave done")
    }
  }
  
  private func printCountOfMentionInTweet(tweetModal: TweetModal){
    let request = NSFetchRequest(entityName: "Mention")
    request.predicate = NSPredicate(format: "from contains %@", tweetModal)
    let num = self.managedObjectContext?.countForFetchRequest(request, error: nil)
    print("there has \((num ?? 0)) mentions in this New TweetModal ID:\((tweetModal.id ?? "errorID"))")
  }
  
}
