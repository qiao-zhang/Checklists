//
//  ChecklistItemCell.swift
//  Checklists
//
//  Created by Qiao Zhang on 12/4/16.
//  Copyright © 2016 Qiao Zhang. All rights reserved.
//

import UIKit

class ChecklistItemCell: UITableViewCell {
  @IBOutlet weak var checkmarkLabel: UILabel!
  @IBOutlet weak var itemTitleLabel: UILabel!
  
  func configureWith(checklistItem: ChecklistItem) {
    configureTitle(with: checklistItem.name)
    configureCheckmark(with: checklistItem.completed)
  }
  
  func configureTitle(with text: String) {
    itemTitleLabel.text = text
  }
  
  func configureCheckmark(with checked: Bool) {
    checkmarkLabel.text = checked ? "✓" : " "
  }
}
