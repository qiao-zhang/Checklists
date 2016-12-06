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
  static let sharedInstance: DataManager = {
    return DataManager()
  } ()
  
  private init() {
    loadChecklists()
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
