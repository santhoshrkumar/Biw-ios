//
//  NotificationViewController+TableView.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 01/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
import RxDataSources

extension NotificationViewController: UITableViewDelegate {
    
    /// datasource to configure both  TableViewCell and return single tableview cell
    static func dataSource() -> RxTableViewSectionedAnimatedDataSource<NotificationTableDataSource> {
        return RxTableViewSectionedAnimatedDataSource(
            animationConfiguration: AnimationConfiguration(insertAnimation: .fade,
                                                           reloadAnimation: .fade,
                                                           deleteAnimation: .fade),
            configureCell: { (dataSource, table, idxPath, item) in
                var cell = table.dequeueReusableCell(withIdentifier: NotificationTableViewCell.identifier) as? NotificationTableViewCell
                let cellViewModel = NotificationTableCellViewModel(withNotification: item)
                cell?.setViewModel(to: cellViewModel)
                return cell ?? UITableViewCell()
        }, canEditRowAtIndexPath: { _, _ in return true })
    }
    
    /// Used to give the custom height for view header and returns a UIView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard var headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: NotificationTableViewSection.identifier)
            as? NotificationTableViewSection
            else { return UITableViewHeaderFooterView() }
        guard let sections = try? self.viewModel.sections.value() else { return UIView() }
        let headerViewModel = sections[section].notificationSectionViewModel
        headerView.setViewModel(to: headerViewModel)
        headerView.dividerLine.isHidden = section == 0 ? true : false
        headerView.section = section
        
        let headerButtonText: String = headerView.sectionButton.titleLabel?.text ?? ""

        if (section == 0 && headerButtonText == ButtonType.markAllAsRead.rawValue) {
            viewModel.sectionHeader.asObserver()
                .bind(to: headerView.header.rx.text)
            .disposed(by: disposeBag)
        }
        
        /// Section button binding with closeObserver
        headerView.sectionButtonTappedClosure = { [weak self] (section, buttonType) in
            if buttonType == ButtonType.clearAll {
                self?.showClearAllConfirmationAlert(section: section,
                                                    buttonType: buttonType)
            } else {
                self?.viewModel.editAction(section: section,
                                 buttonType: buttonType)
            }
        }
        return headerView
    }
        
    /// Shows clear all notificaton confirmation
    /// - Parameter section : at the section u want to clear
    /// buttonType : asks user to clear or mark all notifications as read
    func showClearAllConfirmationAlert(section: Int, buttonType: ButtonType) {
        
        let alert = UIAlertController(title: "Clear All",
                                      message: "Are you sure, you want to clear all Notification History?",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: { action in
            switch action.style{
            case .default:
                self.viewModel.editAction(section: section,
                                buttonType: buttonType)
            case .cancel: break
            case .destructive: break
            default:break
            }}))
        let cancel = UIAlertAction(title: "Cancel",
                                   style: .default,
                                   handler: { action in
        })
        alert.addAction(cancel)
        self.present(alert,
                     animated: true,
                     completion: nil)
    }
    
    /// To give the custom height for header  section in table which returns a float
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
}
