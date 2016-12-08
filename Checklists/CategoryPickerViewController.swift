//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by Qiao Zhang on 12/7/16.
//  Copyright © 2016 Qiao Zhang. All rights reserved.
//

import UIKit
import FontAwesome_swift

protocol CategoryPickerViewControllerDelegate: class {
  func CategoryPicker(_ picker: CategoryPickerViewController,
                  didPick iconName: String)
}

class CategoryCell: UITableViewCell {
  static let identifier = "Category Cell"
  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
}

class CategoryPickerViewController: UITableViewController {
  weak var delegate: CategoryPickerViewControllerDelegate?
  
  let tableData: [(FontAwesome?, String)] = [
    (nil, "No Category"),
    (.clockO, "Appointments"),
    (.birthdayCake, "Birthdays"),
    (.cubes, "Chores"),
    (.beer, "Drinks"),
    (.folderOpen, "Folders"),
    (.shoppingBasket, "Groceries"),
    (.inbox, "Inbox"),
    (.photo, "Photos"),
    (.plane, "Trips")
  ]
}

// MARK: - UITableViewDataSource
extension CategoryPickerViewController {
  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    return tableData.count
  }
  
  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell =
      tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier,
                                    for: indexPath) as! CategoryCell
    let (iconName, category) = tableData[indexPath.row]
    cell.titleLabel.text = category
    if let iconName = iconName {
      cell.iconImageView.image =
        UIImage.fontAwesomeIcon(name: iconName,
                                textColor: .black,
                                size: cell.iconImageView.bounds.size)
    }
    return cell
  }
}
