//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Qiao Zhang on 12/4/16.
//  Copyright © 2016 Qiao Zhang. All rights reserved.
//

import Foundation

class ChecklistItem {
  var name = ""
  var completed = false
  
  init(name: String, completed: Bool = false) {
    self.name = name
    self.completed = completed
  }
  
  func toggleCompleted() {
    completed = !completed
  }
}

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
