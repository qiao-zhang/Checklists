//
//  DataModel.swift
//  Checklists
//
//  Created by Qiao Zhang on 12/6/16.
//  Copyright © 2016 Qiao Zhang. All rights reserved.
//

import Foundation

class DataManager {
  
  var lists = [Checklist]()
  static let sharedInstance = DataManager()
  
  var indexOfSelectedChecklist: Int {
    get {
      return UserDefaults.standard.integer(forKey: "ChecklistIndex")
    }
    set {
      UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
      UserDefaults.standard.synchronize()
    }
  }
  
  private init() {
    loadChecklists()
    registerDefaults()
    handleFirstTime()
  }
  
  private func registerDefaults() {
    let dictionary: [String: Any] = [
      "ChecklistIndex": -1,
      "FirstTime": true
    ]
    UserDefaults.standard.register(defaults: dictionary)
  }
  
  private func handleFirstTime() {
    let userDefaults = UserDefaults.standard
    let firstTime = userDefaults.bool(forKey: "FirstTime")
    
    if firstTime {
      let checklist = Checklist(name: "List")
      lists.append(checklist)
      
      indexOfSelectedChecklist = 0
      userDefaults.set(false, forKey: "FirstTime")
      userDefaults.synchronize()
    }
  }
}

// MARK: - Persistence
extension DataManager {
  
  static private let listsKey = "Checklists"
  
  var documentsDirectory: URL {
    return FileManager.default.urls(for: .documentDirectory,
                                    in: .userDomainMask).first!
  }
  
  var dataFilePath: URL {
    return documentsDirectory.appendingPathComponent("Checklists.plist")
  }
  
  func saveChecklists() {
    let data = NSMutableData()
    let archiver = NSKeyedArchiver(forWritingWith: data)
    archiver.encode(lists, forKey: DataManager.listsKey)
    archiver.finishEncoding()
    data.write(to: dataFilePath, atomically: true)
  }
  
  func loadChecklists() {
    guard let data = try? Data(contentsOf: dataFilePath) else { return }
    let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
    lists =
      unarchiver.decodeObject(forKey: DataManager.listsKey)
      as! [Checklist]
    unarchiver.finishDecoding()
  }
}
