//
//  NewUserDahboardViewController+TableView.swift
//  BiWF
//
//  Created by pooja.q.gupta on 21/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
import RxDataSources
/*
NewUserDashboardViewController extension confirming to UITableViewDelegate protocol
*/
extension NewUserDashboardViewController: UITableViewDelegate {
    
     /// datasource to configure both  TableViewCell and return single tableview cell
    func dataSource() -> RxTableViewSectionedReloadDataSource<TableDataSource> {
        return RxTableViewSectionedReloadDataSource<TableDataSource>(
            configureCell: { dataSource, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: item.identifier) else { return UITableViewCell() }
                cell.selectionStyle = .none
                
                if var cell = cell as? InstallationScheduledCell, let viewModel = item.viewModel as? InstallationScheduledCellViewModel {
                    cell.setViewModel(to: viewModel)
                }
                    
                else if var cell = cell as? WelcomeTableViewCell, let viewModel = item.viewModel as? WelcomeCellViewModel {
                    cell.setViewModel(to: viewModel)
                }
                    
                else if var cell = cell as? InRouteTableViewCell, let viewModel = item.viewModel as? InRouteCellViewModel {
                    cell.setViewModel(to: viewModel)
                }
                    
                else if var cell = cell as? InstallationCompletedTableViewCell, let viewModel = item.viewModel as? InstallationCompletedCellViewModel {
                    cell.setViewModel(to: viewModel)
                }
                    
                else if var cell = cell as? AppointmentCancelledTableViewCell, let viewModel = item.viewModel as? AppointmentCancelledCellViewModel {
                    cell.setViewModel(to: viewModel)
                }
                
                return cell
        })
    }
}
