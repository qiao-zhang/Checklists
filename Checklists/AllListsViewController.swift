//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Qiao Zhang on 12/5/16.
//  Copyright © 2016 Qiao Zhang. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController {
  
  var lists: [Checklist]
  
  required init?(coder aDecoder: NSCoder) {
    lists = Checklist.samples()
    super.init(coder: aDecoder)
    
  }
}

// MARK: - Navigation
extension AllListsViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowChecklist" {
      guard
        let controller = segue.destination as? ChecklistViewController
      else { return }
      controller.checklist = sender as! Checklist
    }
  }
}

// MARK: - Table view data source
extension AllListsViewController {

  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    return lists.count
  }

  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = makeCell(for: tableView)
    cell.textLabel?.text = lists[indexPath.row].name
    cell.accessoryType = .detailDisclosureButton
    return cell
  }
  
  private func makeCell(for tableView: UITableView) -> UITableViewCell {
    let cellIdentifier = "Checklist Cell"
    let cell =
      tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ??
      UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
    return cell
  }
}


// MARK: - UITableViewDelegate
extension AllListsViewController {
  override func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
    let checklist = lists[indexPath.row]
    performSegue(withIdentifier: "ShowChecklist", sender: checklist)
  }
}
