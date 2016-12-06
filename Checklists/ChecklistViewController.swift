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
    items = [ChecklistItem]()
    super.init(coder: aDecoder)
    loadChecklistItems()
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
      controller.itemToEdit = items[indexPath.row]
    }
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
    saveChecklistItems()
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
    saveChecklistItems()
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
    let newRowIndex = items.count
    items.append(item)
    
    let indexPath = IndexPath(row: newRowIndex, section: 0)
    tableView.insertRows(at: [indexPath], with: .automatic)
    
    dismiss(animated: true, completion: nil)
    saveChecklistItems()
  }
  
  func itemDetailViewController(_ controller: ItemDetailViewController,
                                didFinishEditing item: ChecklistItem) {
    dismiss(animated: true, completion: nil)
//    guard let index = items.index(of: item) else { return }
    guard let index = items.index(where: { $0 === item }) else { return }
    let indexPath = IndexPath(row: index, section: 0)
    if let cell = tableView.cellForRow(at: indexPath) as? ChecklistItemCell {
      cell.configureTitle(with: item.name)
    }
    saveChecklistItems()
  }
}


// MARK: - Persistence
extension ChecklistViewController {
  fileprivate var documentsDirectory: URL {
    return FileManager.default.urls(for: .documentDirectory,
                                    in: .userDomainMask).first!
  }
  
  fileprivate var dataFilePath: URL {
    return documentsDirectory.appendingPathComponent("Checklists.plist")
  }
  
  fileprivate func saveChecklistItems() {
    let data = NSMutableData()
    let archiver = NSKeyedArchiver(forWritingWith: data)
    archiver.encode(items, forKey: "ChecklistItems")
    archiver.finishEncoding()
    data.write(to: dataFilePath, atomically: true)
  }
  
  fileprivate func loadChecklistItems() {
    guard let data = try? Data(contentsOf: dataFilePath) else { return }
    let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
    items =
      unarchiver.decodeObject(forKey: "ChecklistItems") as! [ChecklistItem]
    unarchiver.finishDecoding()
  }
}
