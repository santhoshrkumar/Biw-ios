//
//  DashboardViewController+TableView.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 4/16/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
import RxDataSources
/*
 DashboardViewController extension confirming to UITableViewDelegate protocol
 */
extension DashboardViewController: UITableViewDelegate {

    /// Sectiontype to select appropriate section
    enum SectionType: Int {
        case speedTest
        //TODO: For now hidding notification functionality as will be implementated in future.
        //case notifications
        case connectedDevices
        case network
        case wifiInfo
        case networkInfo
    }

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
                
                else if var cell = cell as? DashboardSpeedTestCell, let viewModel = item.viewModel as? DashboardSpeedTestCellViewModel {
                    cell.setViewModel(to: viewModel)
                }
                
                else if var cell = cell as? FeedbackCell, let viewModel = item.viewModel as? FeedBackCellViewModel {
                    cell.setViewModel(to: viewModel)
                }

                if var cell = cell as? DashboardNotificationsCell, let viewModel = item.viewModel as? DashboardNotificationsCellViewModel {
                    cell.initialSetup()
                    cell.setViewModel(to: viewModel)
                }

                if var cell = cell as? ConnectedDevicesCell, let viewModel = item.viewModel as? ConnectedDevicesViewModel {
                    cell.tag = SectionType.connectedDevices.rawValue
                    cell.setViewModel(to: viewModel)
                }

                if var cell = cell as? DashboardNetworkCell, let viewModel = item.viewModel as? DashboardNetworkCellViewModel {
                    cell.setViewModel(to: viewModel)
                }
                
                if var cell = cell as? WiFiNetworkCell, let viewModel = item.viewModel as? WiFiNetworkCellViewModel {
                    cell.tag = SectionType.wifiInfo.rawValue
                    cell.setViewModel(to: viewModel)
                }
                
                if var cell = cell as? NetworkInfoCardCell, let viewModel = item.viewModel as? NetworkInfoCardCellViewModel {
                    cell.tag = SectionType.wifiInfo.rawValue
                    cell.setViewModel(to: viewModel)
                }

                return cell
        })
    }

    /// To give the custom height for header  section in table which returns a float
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section =  viewModel.shouldAddAppointmentCard() ? indexPath.section : indexPath.section+1
        
        switch section {
        case SectionType.speedTest.rawValue:
            return viewModel.shouldAddAppointmentCard() ? UITableView.automaticDimension : Constants.DashboardTableView.speedTestCellHeight
            
        //TODO: For now hidding notification functionality as will be implementated in future.
        /*case SectionType.notifications.rawValue:
            return Constants.DashboardTableView.notifcationsCellHeight
        */
        case SectionType.connectedDevices.rawValue:
            return Constants.DashboardTableView.connectedDevicesCellHeight
        case SectionType.network.rawValue:
            return viewModel.isSpeedTestAvailable() ? Constants.DashboardTableView.networkCellHeight : Constants.DashboardTableView.networkInfoCardCellHeight
        default:
            return UITableView.automaticDimension
        }
    }

    // Section Headers used for spacing above sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionIndex = viewModel.shouldAddAppointmentCard() ? section : section+1

        switch sectionIndex {
        case SectionType.speedTest.rawValue:
            return self.viewModel.currentAppointment != nil ? Constants.DashboardTableView.serviceAppointmentHeaderHeight : 0
        //TODO: For now hidding notification functionality as will be implementated in future.
        /* case SectionType.notifications.rawValue:
            return Constants.DashboardTableView.notificationsHeaderHeight */
        case SectionType.connectedDevices.rawValue:
            return Constants.DashboardTableView.connectedDevicesHeaderHeight
        case SectionType.network.rawValue:
            return Constants.DashboardTableView.networkHeaderHeight
        case SectionType.wifiInfo.rawValue:
            return 0

        default:
            return 0
        }
    }

    /// Used to give the custom height for view header and returns a UIView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
}
