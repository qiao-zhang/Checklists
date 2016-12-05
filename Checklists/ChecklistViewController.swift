//
//  ViewController.swift
//  Checklists
//
//  Created by Qiao Zhang on 12/4/16.
//  Copyright © 2016 Qiao Zhang. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
  
  var items: [ChecklistItem]

  required init?(coder aDecoder: NSCoder) {
    items = ChecklistItem.samples()
    super.init(coder: aDecoder)
  }
  
  // MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

// MARK: - UITableViewDataSource
extension ChecklistViewController {
  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    if items.isEmpty { return 1 }
    return items.count
  }
  
  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if items.isEmpty {
      return tableView.dequeueReusableCell(withIdentifier: "Nothing Here Cell",
                                           for: indexPath)
    }
    
    let cell =
      tableView.dequeueReusableCell(withIdentifier: "Checklist Item Cell",
                                    for: indexPath) as! ChecklistItemCell
    cell.configureWith(checklistItem: items[indexPath.row])
    return cell
  }
  
  override func tableView(_ tableView: UITableView,
                          commit editingStyle: UITableViewCellEditingStyle,
                          forRowAt indexPath: IndexPath) {
    items.remove(at: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .automatic)
  }
}

// MARK: - UITableViewDelegate
extension ChecklistViewController {
  override func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    guard
      let cell = tableView.cellForRow(at: indexPath) as? ChecklistItemCell
    else { return }
    
    let checklistItem = items[indexPath.row]
    checklistItem.toggleCompleted()
    cell.configureCheckmark(with: checklistItem.completed)
  }
}
