//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Qiao Zhang on 12/4/16.
//  Copyright © 2016 Qiao Zhang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol AddItemViewControllerDelegate: class {
  func addItemViewControllerDidCancel(_ controller: AddItemViewController)
  func addItemViewController(_ controller: AddItemViewController,
                             didFinishAdding item: ChecklistItem)
}

class AddItemViewController: UITableViewController {
  
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneButton: UIBarButtonItem!
  
  @IBAction func cancel() {
    delegate?.addItemViewControllerDidCancel(self)
  }
  
  @IBAction func done() {
    guard let name = textField.text else { return }
    let item = ChecklistItem(name: name)
    delegate?.addItemViewController(self, didFinishAdding: item)
  }
  
  weak var delegate: AddItemViewControllerDelegate?
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    bindTextFieldToDoneButton()
    textField.becomeFirstResponder()
  }

}


// MARK: - Rx Methods
private extension AddItemViewController {
  func bindTextFieldToDoneButton() {
    textField.rx.text.asObservable()
      .throttle(0.3, scheduler: MainScheduler.instance)
      .map {
        if let content = $0, !content.isEmpty { return true }
        return false
      }
      .distinctUntilChanged()
      .bindTo(doneButton.rx.isEnabled)
      .addDisposableTo(disposeBag)
  }
}

// MARK: - UITableViewDelegate
extension AddItemViewController {
  override func tableView(_ tableView: UITableView,
                          willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
}
