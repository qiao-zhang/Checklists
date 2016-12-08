//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Qiao Zhang on 12/6/16.
//  Copyright © 2016 Qiao Zhang. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol ListDetailViewControllerDelegate: class {
  func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
  func listDetailViewController(_ controller: ListDetailViewController,
                                didFinishAdding checklist: Checklist)
  func listDetailViewController(_ controller: ListDetailViewController,
                                didFinishEditing checklist: Checklist)
}

// MARK: -
// MARK: -
class ListDetailViewController: UITableViewController {
  
  // MARK: Outlets
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  
  // MARK: Actions
  @IBAction func cancel() {
    delegate?.listDetailViewControllerDidCancel(self)
  }
  
  @IBAction func done() {
    guard let name = textField.text, !name.isEmpty else { return }
    if let checklist = checklistToEdit {
      checklist.name = name
      delegate?.listDetailViewController(self, didFinishEditing: checklist)
    } else {
      let checklist = Checklist(name: name)
      delegate?.listDetailViewController(self, didFinishAdding: checklist)
    }
  }
  
  // MARK: Properties
  weak var delegate: ListDetailViewControllerDelegate?
  var checklistToEdit: Checklist?
  let disposeBag = DisposeBag()
}

// MARK: - View Life Cycle
extension ListDetailViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    bindTextFieldToDoneButton()
    
    if let checklist = checklistToEdit {
      title = "Edit Checklist"
      textField.text = checklist.name
    } else {
      title = "Add Checklist"
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    textField.becomeFirstResponder()
  }
}

// MARK: - Rx Methods
private extension ListDetailViewController {
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
extension ListDetailViewController {
  override func tableView(_ tableView: UITableView,
                          willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if indexPath.section == 1 {
      return indexPath
    }
    return nil
  }
}
