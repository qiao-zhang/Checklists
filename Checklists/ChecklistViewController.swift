//
//  ViewController.swift
//  Checklists
//
//  Created by Qiao Zhang on 12/4/16.
//  Copyright © 2016 Qiao Zhang. All rights reserved.
//

import UIKit
import RxSwift

class ChecklistViewController: UITableViewController {
  
  var checklist: Checklist!

}

// MARK: - View Life Cycle
extension ChecklistViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    title = checklist.name
  }
}

// MARK: - Navigation
extension ChecklistViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddItem" {
      
      guard
        let navController = segue.destination as? UINavigationController,
        let controller =
        navController.topViewController as? ItemDetailViewController
        else { return }
      
      controller.delegate = self
      
    } else if segue.identifier == "EditItem" {
      
      guard
        let navController = segue.destination as? UINavigationController,
        let controller =
        navController.topViewController as? ItemDetailViewController,
        let cell = sender as? UITableViewCell,
        let indexPath = tableView.indexPath(for: cell)
        else { return }
      
      controller.delegate = self
      controller.itemToEdit = checklist.items[indexPath.row]
    }
  }
}

// MARK: - UITableViewDataSource
extension ChecklistViewController {
  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    if checklist.items.isEmpty { return 1 }
    return checklist.items.count
  }
  
  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if checklist.items.isEmpty {
      return tableView.dequeueReusableCell(withIdentifier: "Nothing Here Cell",
                                           for: indexPath)
    }
    
    let cell =
      tableView.dequeueReusableCell(withIdentifier: "Checklist Item Cell",
                                    for: indexPath) as! ChecklistItemCell
    cell.configureWith(checklistItem: checklist.items[indexPath.row])
    return cell
  }
  
  override func tableView(_ tableView: UITableView,
                          canEditRowAt indexPath: IndexPath) -> Bool {
    return !checklist.items.isEmpty
  }
  
  override func tableView(_ tableView: UITableView,
                          commit editingStyle: UITableViewCellEditingStyle,
                          forRowAt indexPath: IndexPath) {
    guard checklist.items.count > indexPath.row else { return }
    
    if editingStyle == .delete {
      checklist.items.remove(at: indexPath.row)
      
      if checklist.items.isEmpty {
        tableView.reloadData()
      } else {
        tableView.deleteRows(at: [indexPath], with: .automatic)
      }
    }

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
    
    let checklistItem = checklist.items[indexPath.row]
    checklistItem.toggleCompleted()
    cell.configureCheckmark(with: checklistItem.completed)
  }
}

// MARK: - ItemDetailViewControllerDelegate
extension ChecklistViewController: ItemDetailViewControllerDelegate {
  func itemDetailViewControllerDidCancel(
    _ controller: ItemDetailViewController) {
    
    dismiss(animated: true, completion: nil)
  }
  
  func itemDetailViewController(_ controller: ItemDetailViewController,
                                didFinishAdding item: ChecklistItem) {
    let newRowIndex = checklist.items.count
    checklist.items.append(item)
    
    if checklist.items.count == 1 {
      tableView.reloadData()
    } else {
      let indexPath = IndexPath(row: newRowIndex, section: 0)
      tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    dismiss(animated: true, completion: nil)
  }
  
  func itemDetailViewController(_ controller: ItemDetailViewController,
                                didFinishEditing item: ChecklistItem) {
    dismiss(animated: true, completion: nil)
//    guard let index = items.index(of: item) else { return }
    guard let index = checklist.items.index(where: { $0 === item }) else { return }
    let indexPath = IndexPath(row: index, section: 0)
    if let cell = tableView.cellForRow(at: indexPath) as? ChecklistItemCell {
      cell.configureTitle(with: item.name)
    }
  }
}


// MARK: - Persistence
extension ChecklistViewController {
  
}
