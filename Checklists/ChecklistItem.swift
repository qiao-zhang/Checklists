//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Qiao Zhang on 12/4/16.
//  Copyright © 2016 Qiao Zhang. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding {

  var name = ""
  var completed = false
  
  required init?(coder aDecoder: NSCoder) {
    name = aDecoder.decodeObject(forKey: "Name") as! String
    completed = aDecoder.decodeBool(forKey: "Completed")
    super.init()
  }
  
  init(name: String, completed: Bool = false) {
    self.name = name
    self.completed = completed
  }
  
  func toggleCompleted() {
    completed = !completed
  }
}

// MARK: - Persistence
extension ChecklistItem {
  func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: "Name")
    aCoder.encode(completed, forKey: "Completed")
  }
}

// MARK: - DEV
extension ChecklistItem {
  class func samples() -> [ChecklistItem] {
    return [
            ("Walk the dog", false),
            ("Brush my teeth", true),
            ("Learn iOS development", true),
            ("Soccer practice", false),
            ("Eat ice cream", true),
           ]
           .map { (name, completed) in
             ChecklistItem(name: name, completed: completed)
           }
  }
}
