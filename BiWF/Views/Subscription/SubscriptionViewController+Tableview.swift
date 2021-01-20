//
//  SubscriptionViewController+Tableview.swift
//  BiWF
//
//  Created by pooja.q.gupta on 07/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
import RxDataSources
/*
 SubscriptionViewController confirming to UITableViewDelegate
 */
extension SubscriptionViewController: UITableViewDelegate {
    
    /// datasource to configure both  TableViewCell and return single tableview cell
    static func dataSource() -> RxTableViewSectionedReloadDataSource<TableDataSource> {
        return RxTableViewSectionedReloadDataSource<TableDataSource>(
            configureCell: { dataSource, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: item.identifier) else { return UITableViewCell() }
                cell.selectionStyle = .none
                
                if var cell = cell as? FiberPlanDetailTableViewCell, let viewModel = item.viewModel as? FiberPlanDetailCellViewModel {
                    cell.setViewModel(to: viewModel)
                }
                
                if var cell = cell as? TitleTableViewCell, let viewModel = item.viewModel as? TitleTableViewCellViewModel {
                    cell.setViewModel(to: viewModel)
                }
                
                return cell
        })
    }
    
    /// Used to give the custom height for view header and returns a UIView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard var headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: TitleHeaderview.identifier)
            as? TitleHeaderview
            else { return UITableViewHeaderFooterView() }
        
        let hideTopBottomSeperator = (true, false)
        let viewModel = TitleHeaderViewModel(title: self.dataSource[section].header ?? "",
                                             hideTopSeperator: hideTopBottomSeperator.0,
                                             hideBottomSeperator: hideTopBottomSeperator.1)
        headerView.setViewModel(to: viewModel)
        return headerView
    }
    
    /// To give the custom height for header  section in table which returns a float
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case SubscriptionViewModel.SectionType.mySubscription.rawValue,
             SubscriptionViewModel.SectionType.previousStatements.rawValue,
             SubscriptionViewModel.SectionType.editPaymentDetails.rawValue:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
}
