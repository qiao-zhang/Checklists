//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Qiao Zhang on 12/5/16.
//  Copyright © 2016 Qiao Zhang. All rights reserved.
//

import UIKit
import FontAwesome_swift

class AllListsViewController: UITableViewController {

  // MARK: View Life Cycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    navigationController?.delegate = self
    
    let index = DataManager.sharedInstance.indexOfSelectedChecklist
    if 0 <= index && index < DataManager.sharedInstance.lists.count {
      let checklist = DataManager.sharedInstance.lists[index]
      performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
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
    } else if segue.identifier == "AddChecklist" {
      guard
        let navigationController = segue.destination as? UINavigationController,
        let controller =
          navigationController.topViewController as? ListDetailViewController
      else { return }
      controller.delegate = self
      controller.checklistToEdit = nil
    }
  }
}

// MARK: - Table view data source
extension AllListsViewController {

  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    return DataManager.sharedInstance.lists.count
  }

  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cellIdentifier = "Checklist Cell"
    let cell =
      tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                    for: indexPath)
        as! ChecklistCell
    let checklist = DataManager.sharedInstance.lists[indexPath.row]
    cell.titleLabel.text = checklist.name
    
    let iconName: FontAwesome?
    switch checklist.category {
    case .appointment:
      iconName = FontAwesome.clockO
    default:
      iconName = nil
    }
    
    if let iconName = iconName {
      cell.imageView?.image =
        UIImage.fontAwesomeIcon(name: iconName,
                                textColor: UIColor.black,
                                size: cell.iconImageView.bounds.size)
    }
    let count = checklist.uncompletedItems
    if checklist.items.count == 0 {
      cell.subtitleLabel.text = "(No Items)"
    } else if count == 0 {
      cell.subtitleLabel.text = "All Done!"
    } else {
      cell.subtitleLabel.text = "\(checklist.uncompletedItems) Remaining"
    }

    return cell
  }
  
  override func tableView(_ tableView: UITableView,
                          commit editingStyle: UITableViewCellEditingStyle,
                          forRowAt indexPath: IndexPath) {
    guard DataManager.sharedInstance.lists.count > indexPath.row else { return }
    
    if editingStyle == .delete {
      DataManager.sharedInstance.lists.remove(at: indexPath.row)
      
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
}


// MARK: - UITableViewDelegate
extension AllListsViewController {
  override func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
    DataManager.sharedInstance.indexOfSelectedChecklist = indexPath.row
    let checklist = DataManager.sharedInstance.lists[indexPath.row]
    performSegue(withIdentifier: "ShowChecklist", sender: checklist)
  }
  
  override func tableView(
    _ tableView: UITableView,
    accessoryButtonTappedForRowWith indexPath: IndexPath) {

    guard
      let navigationController =
        storyboard?.instantiateViewController(
          withIdentifier: "ListDetailNavigationController")
            as? UINavigationController,
      let controller =
        navigationController.topViewController as? ListDetailViewController
    else { return }
    
    controller.delegate = self
    controller.checklistToEdit = DataManager.sharedInstance.lists[indexPath.row]
    
    present(navigationController, animated: true, completion: nil)
  }
}

// MARK: - ListDetailViewControllerDelegate
extension AllListsViewController: ListDetailViewControllerDelegate {
  func listDetailViewControllerDidCancel(
    _ controller: ListDetailViewController) {
    
    dismiss(animated: true, completion: nil)
  }
  
  func listDetailViewController(_ controller: ListDetailViewController,
                                didFinishAdding checklist: Checklist) {
    dismiss(animated: true, completion: nil)
    let index = DataManager.sharedInstance.lists.count
    DataManager.sharedInstance.lists.append(checklist)
    DataManager.sharedInstance.sortChecklists()
    tableView.reloadData()
  }
  
  func listDetailViewController(_ controller: ListDetailViewController,
                                didFinishEditing checklist: Checklist) {
    dismiss(animated: true, completion: nil)
    DataManager.sharedInstance.sortChecklists()
    tableView.reloadData()
  }
}

// MARK: - UINavigationControllerDelegate
extension AllListsViewController: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController,
                            willShow viewController: UIViewController,
                            animated: Bool) {
    if viewController === self {
      DataManager.sharedInstance.indexOfSelectedChecklist = -1
    }
  }
}
