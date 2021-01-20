//
//  NetworkViewController+TableView.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 6/25/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
import RxDataSources

/// Network Info ViewController Extension confirm UITableViewDelegate for setup tableview.
extension NetworkInfoViewController: UITableViewDelegate {

    enum SectionType: Int {
        case onlineStatus
        case networkInfo
    }
    
    /// binding viewmodel to the tableview cell
    func dataSource() -> RxTableViewSectionedReloadDataSource<TableDataSource> {
        return RxTableViewSectionedReloadDataSource<TableDataSource>(
            configureCell: { dataSource, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: item.identifier) else { return UITableViewCell() }
                cell.selectionStyle = .none

                if var cell = cell as? OnlineStatusCell, let viewModel = item.viewModel as? OnlineStatusCellViewModel {
                    cell.setViewModel(to: viewModel)
                }
                
                if var cell = cell as? NetworkDetailTableViewCell, let viewModel = item.viewModel as? NetworkDetailCellViewModel {
                                   cell.setViewModel(to: viewModel)
                               }

                return cell
        })
    }

    /// This will set height to scetion header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case SectionType.onlineStatus.rawValue:
            return Constants.NetworkInfo.onlineStatusHeaderHeight
        case SectionType.networkInfo.rawValue:
            return Constants.NetworkInfo.networkInfoHeaderHeight
        default:
            return 0
        }
    }

    /// This will set view to scetion header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
}
