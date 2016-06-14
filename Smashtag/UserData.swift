//
//  UserData.swift
//  Smashtag
//
//  Created by 杨威 on 16/6/14.
//  Copyright © 2016年 demo. All rights reserved.
//

import Foundation

class UserData{
  static let sharedInstantce = UserData()
  
  
  private class Constant{
    static let searchKey = "searchHistory"
    static let maxSaveCount = 100
    static let defaultSearchQuery = "#stanford"
  }
  private let userDefault = NSUserDefaults.standardUserDefaults()
  
  private var history: [String]{
    get{
      //如果能转换就返回
      return userDefault.objectForKey(Constant.searchKey) as? [String] ?? [String]()
    }
    set{
      userDefault.setObject(newValue, forKey: Constant.searchKey)
      //记得强制保存
      userDefault.synchronize()
    }
  }
  
  var searchHistory: [String] {
    return history
  }
  
  var lastRecentSearchQuery: String{
    if let lastQuery = history.first{
      return lastQuery
    }
    else{
      return Constant.defaultSearchQuery
    }
  }
  
  func searchHistoryRemoveAt(index: Int){
    history.removeAtIndex(index)
  }
  
  func newSearchQueryInsert(query: String){
    //先检查是否已经有
    let match = history.filter{ $0 == query }
    if match.count != 0 {
      //移除
      history.removeAtIndex(history.indexOf(query)!)
    }
    //之前不存在
    if history.count > Constant.maxSaveCount{
      history.removeLast()
    }
    //插入开头
    history.insert(query, atIndex: 0)
  }
}