//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Qiao Zhang on 12/4/16.
//  Copyright © 2016 Qiao Zhang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ItemDetailViewControllerDelegate: class {
  func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
  func itemDetailViewController(_ controller: ItemDetailViewController,
                                didFinishAdding item: ChecklistItem)
  func itemDetailViewController(_ controller: ItemDetailViewController,
                                didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController {
  
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  
  @IBAction func cancel() {
    delegate?.itemDetailViewControllerDidCancel(self)
  }
  
  @IBAction func done() {
    guard let name = textField.text else { return }
    if let item = itemToEdit {
      item.name = name
      delegate?.itemDetailViewController(self, didFinishEditing: item)
      return
    }
    let item = ChecklistItem(name: name)
    delegate?.itemDetailViewController(self, didFinishAdding: item)
  }
  
  var itemToEdit: ChecklistItem?
  weak var delegate: ItemDetailViewControllerDelegate?
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    bindTextFieldToDoneButton()
    textField.becomeFirstResponder()
    
    if let item = itemToEdit {
      title = "Edit Item"
      textField.text = item.name
    }
  }

}

// MARK: - Rx Methods
private extension ItemDetailViewController {
  func bindTextFieldToDoneButton() {
    textField.rx.text.asObservable()
      .throttle(0.3, scheduler: MainScheduler.instance)
      .map {
        if let content = $0, !content.isEmpty { return true }
        return false
      }
      .distinctUntilChanged()
      .bindTo(doneBarButton.rx.isEnabled)
      .addDisposableTo(disposeBag)
  }
}

// MARK: - UITableViewDelegate
extension ItemDetailViewController {
  override func tableView(_ tableView: UITableView,
                          willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
}
