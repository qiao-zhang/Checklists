//
//  Checklist.swift
//  Checklists
//
//  Created by Qiao Zhang on 12/5/16.
//  Copyright © 2016 Qiao Zhang. All rights reserved.
//

import UIKit

class Checklist: NSObject {
  var name: String
  var items: [ChecklistItem]
  var uncompletedItems: Int {
    return items.reduce(0) { $0 + ($1.completed ? 0 : 1) }
  }
  
  init(name: String) {
    self.name = name
    items = []
    super.init()
  }

  required init?(coder aDecoder: NSCoder) {
    name = aDecoder.decodeObject(forKey: "Name") as! String
    items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
    super.init()
  }
}

// MARK: - Persistence
extension Checklist: NSCoding {
  public func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: "Name")
    aCoder.encode(items, forKey: "Items")
  }
}

// MARK: - DEV
extension Checklist {
  class func samples() -> [Checklist] {
    let lists =
      ["Birthdays", "Groceries", "Coll Apps", "To Do"]
        .map { Checklist(name: $0) }
    lists.forEach {
      $0.items.append(ChecklistItem(name: "Item for \($0.name)"))
    }
    return lists
  }
}
