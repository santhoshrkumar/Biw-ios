//
//  ModifyAppointmentViewController+Tableview.swift
//  BiWF
//
//  Created by pooja.q.gupta on 01/07/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
import RxDataSources

/// ModifyAppointmentViewController extension confirming to UITableViewDelegate
extension ModifyAppointmentViewController: UITableViewDelegate {
    
    /// datasource to configure both AvailableDates and AvailableTimeSlots TableViewCell and return single tableview cell
    func dataSource() -> RxTableViewSectionedReloadDataSource<TableDataSource> {
        return RxTableViewSectionedReloadDataSource<TableDataSource>(
            configureCell: { dataSource, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: item.identifier) else { return UITableViewCell() }
                cell.selectionStyle = .none
                
                if var cell = cell as? AvailableDatesTableViewCell, let viewModel = item.viewModel as? AvailableDatesCellViewModel {
                    cell.setViewModel(to: viewModel)
                }
                
                if var cell = cell as? AvailableTimeSlotTableViewCell, let viewModel = item.viewModel as? AvailableTimeSlotCellViewModel {
                    cell.setViewModel(to: viewModel)
                }
                
                return cell
        })
    }
    
    /// Used to give the custom height for the view inside the table which returns a UIView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard var headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: AvailableSlotHeaderView.identifier)
            as? AvailableSlotHeaderView
            else { return UITableViewHeaderFooterView() }
        
        var value = ""
        do {
            let selectedDate =  try viewModel.selectedDateSubject.value()
            value = "\(Constants.AvailableDatesTableViewCell.availableAppointmentsOn) \(selectedDate?.toString(withFormat: Constants.DateFormat.MMddyy) ?? ""):"
        } catch {}
        
        let viewModel = AvailableSlotHeaderViewModel.init(title: value, showErrorMessage: self.viewModel.isSelectedSlotError)
        headerView.setViewModel(to: viewModel)
        return headerView
    }
    
    /// used to set the custom height for header in table, which returns a floating value
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case ModifyAppointmentViewModel.SectionType.availableSlot.rawValue:
            return UITableView.automaticDimension
            
        default:
            return 0
        }
    }
    
    /// A table view sends this message to its delegate just before it uses cell to draw a row
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let borderColor = viewModel.isSelectedSlotError ? UIColor.BiWFColors.strawberry : UIColor.white
        
        if indexPath.section == ModifyAppointmentViewModel.SectionType.availableSlot.rawValue {
            var edges = [UIRectEdge]()
            if indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
                edges = [.top, .left, .right, .bottom]
            } else if indexPath.row == 0 {
                edges = [.top, .left, .right]
            } else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
                edges = [.left, .right, .bottom]
            } else {
                edges = [.left, .right]
            }
            cell.layer.addBorder(edges: edges, color: borderColor, thickness: 1)
        }
    }
}
