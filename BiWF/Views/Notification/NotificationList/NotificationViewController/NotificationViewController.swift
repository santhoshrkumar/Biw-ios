//  NotificationViewController.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 26/03/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
import RxDataSources
/*
NotificationViewController to show notifications
*/
class NotificationViewController: UIViewController, Storyboardable {
    
    /// Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleText: UILabel!
    
    /// Holds NotificationViewModel with strong reference
    var viewModel: NotificationViewModel!
    
    /// Variables/Constants
    let disposeBag = DisposeBag()
    
    let sectionHeight: CGFloat = 70
    let dataSource = NotificationViewController.dataSource()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindInitials()
    }
    
    override func viewDidLayoutSubviews() {
        bindDataSource()
    }
    
    /// Initial table view UI set up
    private func bindInitials() {
        tableView.delegate = nil
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        registerNibs()
    }
    
    /// Registers the xib files into tableview
    private func registerNibs() {
        let headerNib = UINib.init(
            nibName: NotificationTableViewSection.identifier,
            bundle: nil)
        tableView.register(
            headerNib,
            forHeaderFooterViewReuseIdentifier: NotificationTableViewSection.identifier)
    }
}

/// NotificationViewController extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension NotificationViewController: Bindable {
    
    func bindViewModel() {
        bindActions()
    }
    
    /// Binds all the table data sources
    func bindDataSource() {
        tableView.dataSource = nil
        viewModel.sections.asObserver()
            .bind(to: tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
    }
    
    /// Binds all the dleted row at indexpath
    private func bindDeleteItems() {
        tableView.rx.itemDeleted.asObservable()
            .subscribe({ (event) in
                if let indexpath = event.element {
                    self.viewModel.removeItem(at: (indexpath ))}
            })
            .disposed(by: disposeBag)
    }
    
    /// Binding all the input observers from viewmodel to get the events
    private func bindActions() {
        
        bindDeleteItems()
        
        guard let openDetailsObserver = self.viewModel?.input.openDetailsObserver,
            let closeObserver = self.viewModel?.input.closeObserver else {
                return
        }
        
        /// Binding all the output observers from viewmodel to get the values
        viewModel.output.titleTextDriver
            .drive(titleText.rx.text)
            .disposed(by: disposeBag)
        
        /// Close button binding with closeObserver
        closeButton.rx.tap
            .bind(to: (closeObserver))
            .disposed(by: disposeBag)
        
        /// Tableview item selected binding with openDetailsObserver
        tableView.rx.itemSelected
            .map { indexPath in
                return (self.viewModel.updateNotification(indexPath: indexPath) ?? "")
        }
        .subscribe(openDetailsObserver).disposed(by: disposeBag)
    }
}
