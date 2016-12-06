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
  
  init(name: String) {
    self.name = name
    super.init()
  }
}

// MARK: - DEV
extension Checklist {
  class func samples() -> [Checklist] {
    let lists =
      ["Birthdays", "Groceries", "Coll Apps", "To Do"]
        .map { Checklist(name: $0) }
    return lists
  }
}
