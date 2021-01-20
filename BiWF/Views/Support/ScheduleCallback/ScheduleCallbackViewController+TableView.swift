//
//  ScheduleCallbackViewController+Tableview.swift
//  BiWF
//
//  Created by pooja.q.gupta on 30/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
import RxDataSources
/*
 ScheduleCallbackViewController confirming to UITableViewDelegate
 */
extension ScheduleCallbackViewController: UITableViewDelegate {
    
    /// datasource to configure  tableViewCell and return single tableview cell
    static func dataSource() -> RxTableViewSectionedReloadDataSource<TableDataSource> {
        return RxTableViewSectionedReloadDataSource<TableDataSource>(
            configureCell: { dataSource, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: item.identifier) else { return UITableViewCell() }
                cell.selectionStyle = .none
                
                if var cell = cell as? TitleTableViewCell, let viewModel = item.viewModel as? TitleTableViewCellViewModel {
                    cell.setViewModel(to: viewModel)
                }
                
                return cell
        })
    }
    
    /// Used to give the custom height for the view inside the table which returns a UIView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard var headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: TitleHeaderview.identifier)
            as? TitleHeaderview
            else { return UITableViewHeaderFooterView() }
        
        let hideTopBottomSeperaor = (false, false)
        let viewModel = TitleHeaderViewModel(title: self.dataSource[section].header ?? "",
                                             hideTopSeperator: hideTopBottomSeperaor.0,
                                             hideBottomSeperator: hideTopBottomSeperaor.1)
        headerView.setViewModel(to: viewModel)
        return headerView
    }
    
    /// Used to give custom height for header section in a tableview which returns a float
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case ScheduleCallbackViewModel.SectionType.selectReason.rawValue:
            return UITableView.automaticDimension
            
        case ScheduleCallbackViewModel.SectionType.callUsNow.rawValue:
            return Constants.ScheduleCallback.callUsNowHeaderHeight
        default:
            return 0
        }
    }
}
