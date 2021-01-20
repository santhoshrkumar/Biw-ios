//
//  StatementDetailViewController+Tableview.swift
//  BiWF
//
//  Created by pooja.q.gupta on 11/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
import RxDataSources
/*
 StatementDetailViewController extension contains table datasource functions
 */
extension StatementDetailViewController {
    
    /// datasource to configure both the TableViewCell and return single tableview cell
    static func dataSource() -> RxTableViewSectionedReloadDataSource<TableDataSource> {
        return RxTableViewSectionedReloadDataSource<TableDataSource>(
            configureCell: { dataSource, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: item.identifier) else { return UITableViewCell() }
                cell.selectionStyle = .none
                
                if var cell = cell as? PaymentDetailTableViewCell, let viewModel = item.viewModel as? PaymentDetailCellViewModel {
                    cell.setViewModel(to: viewModel)
                }
                
                if var cell = cell as? PaymentBreakdownTableViewCell, let viewModel = item.viewModel as? PaymentBreakdownCellViewModel {
                    cell.setViewModel(to: viewModel)
                }
                
                return cell
        })
    }
}
