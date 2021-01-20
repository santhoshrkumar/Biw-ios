//
//  AccountViewController+TableView.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 10/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//


import UIKit
import DPProtocols
import RxSwift
import RxCocoa
import RxDataSources
/*
 AccountViewController extension confirming to UITableViewDelegate
 */
extension AccountViewController: UITableViewDelegate {
    
    /// CellType to select the approriate cell on the tableview
    enum CellType: Int {
        case accountInfoCell
        case paymentInfoCell
        case personalInfoCell
        case preferenceAndSettingsCell
        case logoutCell
    }
    
    /// datasource to configure both AvailableDates and AvailableTimeSlots TableViewCell and return single tableview cell
    func dataSource() -> RxTableViewSectionedReloadDataSource<TableDataSource> {
        return RxTableViewSectionedReloadDataSource<TableDataSource>(
            configureCell: { dataSource, tableView, indexPath, item in
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: item.identifier) else { return UITableViewCell()}
                
                //Check for the cell type & viewmodel, then set the viewModel of cell
                if var cell = cell as? AccountOwnerDetailsCell, let viewModel = item.viewModel as? AccountOwnerDetailsCellViewModel {
                    cell.setViewModel(to: viewModel)
                }
                
                if var cell = cell as? PaymentInfoCell, let viewModel = item.viewModel as? PaymentInfoCellViewModel {
                    cell.setViewModel(to: viewModel)
                }
                
                if var cell = cell as? PersonalInfoCell, let viewModel = item.viewModel as? PersonalInfoCellViewModel {
                    cell.setViewModel(to: viewModel)
                }
                
                if var cell = cell as? PreferenceAndSettingsCell, let viewModel = item.viewModel as? PreferenceAndSettingsCellViewModel {
                    cell.setViewModel(to: viewModel)
                    if cell.viewModel.isInitiallyLoading {
                        self.bindCellInputs(cell)
                        cell.viewModel.isInitiallyLoading = false
                    }
                }

                if var cell = cell as? LogoutCell, let viewModel = item.viewModel as? LogoutCellViewModel {
                    cell.setViewModel(to: viewModel)
                }

                return cell
        })
    }
    
    /// Used to set the custom height for eah cell in the tableview
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case CellType.accountInfoCell.rawValue:
            return Constants.Account.accountInfoCellHeight
        case CellType.paymentInfoCell.rawValue:
            return Constants.Account.paymentInfoCellHeight
        case CellType.personalInfoCell.rawValue:
            return Constants.Account.personalInfoCellHeight
        case CellType.preferenceAndSettingsCell.rawValue:
            return Constants.Account.preferenceAndSettingsCellHeight
        case CellType.logoutCell.rawValue:
            return Constants.Account.logoutCellHeight
        default:
            return Constants.Account.accountInfoCellHeight
        }
    }
    
    /// Binding all the input cells from viewmodel 
    private func bindCellInputs(_ cell: PreferenceAndSettingsCell) {
        cell.changeFaceIdObservableValue?
            .bind(to: self.viewModel.input.changeFaceIDPreferenceObserver)
            .disposed(by: self.disposeBag)
        cell.changeServiceCallObservableValue?
            .bind(to: self.viewModel.input.changeServiceCallPreferenceObserver)
        .disposed(by: self.disposeBag)
        cell.changeMarketingEmailObservableValue?
            .bind(to: self.viewModel.input.changeMarketingEmailPreferenceObserver)
        .disposed(by: self.disposeBag)
        cell.changeMarketingCallObservableValue?
            .bind(to: self.viewModel.input.changeMarketingCallPreferenceObserver)
        .disposed(by: self.disposeBag)
    }
}
