//
//  NewUserDashboardViewModel+Sections.swift
//  BiWF
//
//  Created by pooja.q.gupta on 22/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
/*
 NewUserDashboardViewModel to handle new user dashboard
 */
extension CommonDashboardViewModel {
    
    /// Sets the section at table
    func setSections() {
        sections.onNext(getSections())
    }
    
    /// Gets all created section on table
    func getSections() -> [TableDataSource] {
        
        var items = [Item]()
        
        if let serviceAppointment = self.currentAppointment {
            items = [createInstallationStateCell(for: serviceAppointment)]
            let appointmentState = serviceAppointment.getState()
            
            if serviceAppointment.shouldShowNotificationForState() && appointmentState != .complete && appointmentState != .cancelled {
                items.append(createWelcomeCell(for: serviceAppointment))
            }
            if serviceAppointment.getState() != .complete {
                serviceAppointment.set(isCloseServiceCompleteCard: false)
            }
        }
        return [TableDataSource.init(header: nil, items: items)]
    }
    
    /// creates installation status
    /// - Parameter appointment : contains all serviceAppointment values
    func createInstallationStateCell(for appointment: ServiceAppointment) -> Item {
        switch appointment.getState() {
        case .scheduled:
            return createInstallationScheduledCell(for: appointment)
            
        case .enRoute:
            return createInRouteCell(for: appointment)
            
        case .inProgress:
            return createInProgressCell(for: appointment)
            
        case .cancelled:
            return createInstallationCancelledCell(for: appointment)
            
        default:
            return createInstallationCompletedCell(for: appointment)
        }
    }
    
    /// Creates welcome cell while installing
    /// - Parameter appointment : contains all serviceAppointment values
    func createWelcomeCell(for appointment: ServiceAppointment) -> Item {
        
        let viewModel = WelcomeCellViewModel.init(state: appointment.getState(), appointmentType: appointment.getAppointmentType())
        viewModel.dismissWelcomeSubject.subscribe(onNext: {[weak self] _ in
            guard let self = self else {return}
            self.currentAppointment?.set(isCloseAppointmentNotification: true)
            self.currentAppointment?.setCloseNotificationState()
            DispatchQueue.main.async {
                self.setSections()
            }
        }).disposed(by: disposeBag)
        
        return Item(identifier: WelcomeTableViewCell.identifier,
                         viewModel: viewModel)
    }
    
    /// Creates installation with cancel or change in appointment
    /// - Parameter appointment : contains all serviceAppointment values
    func createInstallationScheduledCell(for appointment: ServiceAppointment) -> Item {
        let viewModel = InstallationScheduledCellViewModel.init(appointment: appointment)
        
        viewModel.output.cancelAppointmentObservable.subscribe(onNext: {[weak self] _ in
            self?.showCancelAppointmentAlertSubject.onNext(())
        }).disposed(by: disposeBag)
        
        viewModel.output.changeAppointmentObservable.subscribe(onNext: {[weak self] _ in
            if let serviceAppointment = self?.currentAppointment {
               self?.changeAppointmentSubject.onNext((serviceAppointment))
            }
        }).disposed(by: disposeBag)
        
        return Item(identifier: InstallationScheduledCell.identifier,
                         viewModel: viewModel)
    }
    
    /// Creates in route cells for the user  view status
    /// - Parameter appointment : contains all serviceAppointment values
    func createInRouteCell(for appointment: ServiceAppointment) -> Item {
        return Item(identifier: InRouteTableViewCell.identifier,
                         viewModel: InRouteCellViewModel.init(
                            appointment: appointment))
    }
    
    /// Creates in progress cells for the user  view status
    /// - Parameter appointment : contains all serviceAppointment values
    func createInProgressCell(for appointment: ServiceAppointment) -> Item {
        return Item(identifier: InRouteTableViewCell.identifier,
                         viewModel: InRouteCellViewModel.init(
                            appointment: appointment))
    }
    
    /// Creates installation completed cells for the user  view status
    /// - Parameter appointment : contains all serviceAppointment values
    func createInstallationCompletedCell(for appointment: ServiceAppointment) -> Item {
        let viewModel = InstallationCompletedCellViewModel(appointmentType: appointment.getAppointmentType())
        
        viewModel.output.getStartedObservable.subscribe(onNext: {[weak self] _ in
            self?.currentAppointment?.set(isCloseServiceCompleteCard: true)
            if self?.currentAppointment?.getAppointmentType() == .installation {
                self?.getStartedTapSubject.onNext(())
            }
            self?.serviceAppointmentCompleted.onNext(true)
        }).disposed(by: disposeBag)
        
        return Item(identifier: InstallationCompletedTableViewCell.identifier,
                         viewModel: viewModel)
    }
    
    /// Creates installation cancel cells for the user  view status
    /// - Parameter appointment : contains all serviceAppointment values
    func createInstallationCancelledCell(for appointment: ServiceAppointment) -> Item {
        return Item.init(identifier: AppointmentCancelledTableViewCell.identifier,
                         viewModel: AppointmentCancelledCellViewModel(appointment: appointment))
    }
}
