//
//  AppointmentRepository.swift
//  BiWF
//
//  Created by pooja.q.gupta on 02/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import DPProtocols
import RxSwift
import Foundation
/**
 Assists in the implemetation of the AppointmentRepository, enabling an abstraction of data
 */
struct AppointmentRepository: Repository {
    
    /// PublishSubject notification is broadcasted to all subscribed observers when responses come as Bool/Objects/ error
    var serviceAppointment = PublishSubject<ServiceAppointmentList>()
    let appointmentSlots = PublishSubject<AvailableSlotsResponse>()
    let rescheduleAppointmentStatus = PublishSubject<RescheduleAppointmentResponse>()
    let errorMessage = PublishSubject<String>()
    let rescheduleAppointmentErrorMsg = PublishSubject<String>()
    /// Contained disposables disposal
    let disposeBag = DisposeBag()
    /// Holds the accountServiceManager with a strong reference
    let appointmentServiceManager: AppointmentServiceManager
    
    static var isInsatllationAppointment: Bool? = nil
    
    /// Initialise the AppointmentServiceManager
    /// - Parameters:
    ///   - appointmentServiceManager: shared object of appointmentServiceManager
    init(appointmentServiceManager: AppointmentServiceManager = NetworkAppointmentServiceManager.shared) {
        self.appointmentServiceManager = appointmentServiceManager
    }
    
    /// Call method of network manager which get service appointment
    /// - Parameters:
    ///   - accountID: accountID come from Account API
    func getServiceAppointment(for accountID: String) {
        self.appointmentServiceManager.getServiceAppointment(for: accountID)
            .subscribe(onNext: { [unowned serviceAppointment, unowned errorMessage] result in
                switch result {
                case .success(let response):
                    do {
                        let appointment = try JSONDecoder().decode(ServiceAppointmentList.self, from: response)
                        _ = appointment.records.map { (serviceAppointment) in
                            if serviceAppointment.appointmentId == serviceAppointment.cancelAppointmentId && serviceAppointment.status == "Canceled" {
                                serviceAppointment.removeCancelAppointmentId()
                            }
                            AppointmentRepository.isInsatllationAppointment = serviceAppointment.getAppointmentType() == .installation && serviceAppointment.getState() != .complete
                        }
                        serviceAppointment.onNext(appointment)
                    }
                    catch {
                        errorMessage.onNext(ServiceManager.getErrorMessage(forError: error))
                    }
                case .failure(let error):
                    errorMessage.onNext(ServiceManager.getErrorMessage(forError: error))
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// Call method of network manager which get appointment slots
    /// - Parameters:
    ///   - serviceAppointmentId: serviceAppointmentId come from ServiceAppointment API
    ///   - earliestPermittedDate: One month date after selected month
    func getAppointmentSlots(for serviceAppointmentId: String, earliestPermittedDate: String) {
        self.appointmentServiceManager.getAppointmentSlots(for: serviceAppointmentId, earlistPermittedDate: earliestPermittedDate)
            .subscribe(onNext: {[unowned appointmentSlots, unowned errorMessage] result in
                switch result {
                case .success(let response):
                    do {
                        let appointment = try JSONDecoder().decode(AvailableSlotsResponse.self, from: response)
                        appointmentSlots.onNext(appointment)
                        
                    }
                    catch {
                        errorMessage.onNext(ServiceManager.getErrorMessage(forError: error))
                    }
                case .failure(let error):
                    errorMessage.onNext(ServiceManager.getErrorMessage(forError: error))
                }
            })
            .disposed(by: disposeBag)
    }

    /// Call method of network manager which reschedule appointment
    /// - Parameters:
    ///   - parameters: RescheduleAppointment object
    func rescheduleAppointment(with parameters: RescheduleAppointment) {
        self.appointmentServiceManager.rescheduleAppointment(with: parameters)
            .subscribe(onNext: { [unowned rescheduleAppointmentStatus, unowned rescheduleAppointmentErrorMsg] result in
                switch result {
                case .success(let response):
                    do {
                        let rescheduleStatus = try JSONDecoder().decode(RescheduleAppointmentResponse.self, from: response)
                        rescheduleAppointmentStatus.onNext(rescheduleStatus)
                    } catch {
                        rescheduleAppointmentErrorMsg.onNext(ServiceManager.getErrorMessage(forError: error))
                    }
                case .failure(let error):
                    rescheduleAppointmentErrorMsg.onNext(ServiceManager.getErrorMessage(forError: error))
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// Call method of network manager which cancelAppointment
    /// - Parameters:
    ///   - parameters: use ServiceAppointment object
    /// - returns:
    ///   - status: success or failure
    ///   - error: if any error come in API response
    func cancelAppointment(_ appointment: ServiceAppointment) -> Observable<(status: Bool?, error: String?)> {
        let cancelAppointmentResult = PublishSubject<(status: Bool?, error: String?)>()
        
        self.appointmentServiceManager.cancelAppointment(appointment)
        .subscribe(onNext: { result in
            switch result {
            case .success(let response):
                do {
                    let cancelAppointment = try JSONDecoder().decode(CancelAppointmentResponse.self, from: response)
                    ///Here actual service get cancel after some time after getting respnse.
                    ///So we stored CancelAppointmentId when get status "Ok" in success
                    ///and remove CancelAppointmentId when get status as "Canceled"
                    cancelAppointment.status == "Canceled" ?  appointment.removeCancelAppointmentId() : appointment.setCancelAppointmentId()
                    cancelAppointmentResult.onNext((true, nil))
                    cancelAppointmentResult.onCompleted()
                } catch {
                    cancelAppointmentResult.onNext((nil, ServiceManager.getErrorMessage(forError: error)))
                    cancelAppointmentResult.onCompleted()
                }
            case .failure(let error):
                cancelAppointmentResult.onNext((nil, ServiceManager.getErrorMessage(forError: error)))
                cancelAppointmentResult.onCompleted()
            }
        })
        .disposed(by: disposeBag)
        
        return cancelAppointmentResult.asObservable()
    }
}
