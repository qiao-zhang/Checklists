//
//  Checklist.swift
//  Checklists
//
//  Created by Qiao Zhang on 12/5/16.
//  Copyright © 2016 Qiao Zhang. All rights reserved.
//

import UIKit
import FontAwesome_swift

enum ChecklistCategory: String {
  case unknown = "Unknown"
  case appointment = "Appointment"
  case birthdays = "Birthdays"
  case chores = "Chores"
  case drinks = "Drinks"
  case folder = "Folder"
  case groceries = "Groceries"
  case inbox = "Inbox"
  case photos = "Photos"
  case trips = "Trips"
}

class Checklist: NSObject {
  var name: String
  var items: [ChecklistItem]
  var category: ChecklistCategory
  
  var uncompletedItems: Int {
    return items.reduce(0) { $0 + ($1.completed ? 0 : 1) }
  }
  
  init(name: String) {
    self.name = name
    items = []
    category = .appointment
    super.init()
  }

  required init?(coder aDecoder: NSCoder) {
    name = aDecoder.decodeObject(forKey: "Name") as! String
    items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
    if let categoryValue =
      aDecoder.decodeObject(forKey: "Category") as? String {
      category = ChecklistCategory(rawValue: categoryValue) ?? .unknown
    } else {
      category = .unknown
    }
    super.init()
  }
}

// MARK: - Persistence
extension Checklist: NSCoding {
  public func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: "Name")
    aCoder.encode(items, forKey: "Items")
    aCoder.encode(category.rawValue, forKey: "Category")
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
