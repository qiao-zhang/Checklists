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
  
  override func tableView(_ tableView: UITableView,
                          commit editingStyle: UITableViewCellEditingStyle,
                          forRowAt indexPath: IndexPath) {
    guard lists.count > indexPath.row else { return }
    
    if editingStyle == .delete {
      lists.remove(at: indexPath.row)
      
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
}


// MARK: - UITableViewDelegate
extension AllListsViewController {
  override func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
    let checklist = lists[indexPath.row]
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
    controller.checklistToEdit = lists[indexPath.row]
    
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
    let index = lists.count
    lists.append(checklist)
    
    let indexPath = IndexPath(row: index, section: 0)
    tableView.insertRows(at: [indexPath], with: .automatic)
  }
  
  func listDetailViewController(_ controller: ListDetailViewController,
                                didFinishEditing checklist: Checklist) {
    dismiss(animated: true, completion: nil)
    guard let index = lists.index(of: checklist) else { return }
    let indexPath = IndexPath(row: index, section: 0)
    tableView.cellForRow(at: indexPath)?.textLabel?.text = checklist.name
  }
}
