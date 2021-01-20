//
//  ModifyAppointmentViewModel+API.swift
//  BiWF
//
//  Created by pooja.q.gupta on 09/07/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation

/// ModifyAppointmentViewModel extension
extension ModifyAppointmentViewModel {
    
    /// Create subscription for selected date
    func createSubscription() {
        repository.errorMessage
            .subscribe(onNext: {[weak self] error in
                let error = ViewStatus.error(errorMsg: "\(error.count == 0 ? Constants.Common.errorLoadingInformation : error)\n \(Constants.Common.tapToRetry)") {
                    self?.checkForAvailableSlots(shouldClearData: true)
                }
                self?.viewStatusSubject.onNext(error)
            }).disposed(by: self.disposeBag)
        
        repository.rescheduleAppointmentErrorMsg
            .subscribe(onNext: {[weak self] error in
                guard let self = self else {return}
                self.viewStatusSubject.onNext(ViewStatus.loaded)
                self.isRescheduleAppointementError = true
                self.showAlertSubject.onNext((error))
            }).disposed(by: self.disposeBag)
        
        repository.appointmentSlots
            .subscribe(onNext: {[weak self] (availableSlotResponse) in
                guard let self = self else {return}
                let slots = self.mergeSlots(oldSlots: self.availableSlots?.slotsValue, newSlots: availableSlotResponse.slotsValue)
                self.availableSlots = AvailableSlotsResponse(slotsValue: slots, appointmentId: availableSlotResponse.appointmentId)
                self.checkForAvailableSlots(shouldClearData: false)
            }).disposed(by: self.disposeBag)
    }
    
    /// Get the available date and time slot
    /// - Parameter earliestPermittedDate : earliestPermittedDate ,to book an appointment at the earliest
    func getAvailableSlots(for earliestPermittedDate: Date) {
        self.earliestPermittedDate = earliestPermittedDate
        repository.getAppointmentSlots(for: serviceAppointment.appointmentId, earliestPermittedDate: earliestPermittedDate.toString(withFormat: Constants.DateFormat.YYYY_MM_dd))
    }
    
    /// Re schedule the Appointment
    /// - Parameter arrivalTime: arrivaltime of rescheduledAppointment
    /// endTime : endTime of rescheduledAppointment
    func rescheduleAppointment(with arrivalTime: Date, endTime: Date) {
        
        let loading = ViewStatus.loading(loadingText: Constants.Common.updating)
        viewStatusSubject.onNext(loading)
        
        repository.rescheduleAppointmentStatus
            .subscribe(onNext: {[weak self] (rescheduleAppointmentResponse) in
                guard let self = self else {return}
                
                self.viewStatusSubject.onNext(ViewStatus.loaded)
                
                if rescheduleAppointmentResponse.status == "OK" {
                    // move to confirmation view
                    self.appointmentConfirmationSubject.onNext((ArrivalTime(startTime: arrivalTime, endTime: endTime), self.serviceAppointment.getAppointmentType()))
                } else {
                    DispatchQueue.main.async {
                        self.showAlertSubject.onNext((Constants.ModifyAppointment.appointmentAlreadyScheduled))
                        self.earliestPermittedDate = nil
                        self.checkForAvailableSlots(shouldClearData: false)
                    }
                }
            }).disposed(by: self.disposeBag)
        
        let parameter = RescheduleAppointment.init(serviceAppointmentID: serviceAppointment.appointmentId,
                                                   arrivalWindowStartTime: arrivalTime.toString(withFormat: Constants.DateFormat.yyyyMMddHHmmss),
                                                   ArrivalWindowEndTime: endTime.toString(withFormat: Constants.DateFormat.yyyyMMddHHmmss))
        repository.rescheduleAppointment(with: parameter)
    }
    
    /// Search for available slots
    /// - Parameter shouldClearData: Bool value to check whether all the needs to be cleared or not
    func checkForAvailableSlots(shouldClearData: Bool) {
        if shouldClearData {
            self.availableSlots = nil
            self.slots = [Slot]()
            self.selectedDateSubject.onNext(nil)
            self.selectedSlotSubject.onNext(nil)
            self.earliestPermittedDate = nil
        }
        
        guard let earliestPermittedDate = self.earliestPermittedDate else {
            let loading = ViewStatus.loading(loadingText: Constants.Common.loading)
            viewStatusSubject.onNext(loading)
            
            getAvailableSlots(for: Date())
            return
        }
        if (earliestPermittedDate.dateAfterMonth(1)?.startOfMonth() ?? Date()) <= (Date().dateAfterMonth(2)?.startOfMonth() ?? Date()) {
            getAvailableSlots(for: earliestPermittedDate.dateAfterMonth(1)?.startOfMonth() ?? Date())
        } else {
            self.viewStatusSubject.onNext(ViewStatus.loaded)
            setSections()
        }
    }
    
    ///Merge the new and old slots
    /// - Parameter oldSlots : dict with list of old time slots on which the appointment was booked, with key as date and time as slots in array
    /// newSlots : dict with list of available time slots to book an appointment, with key as date and time as slots in array
    /// returns a new value by merging a new value with old value
    func mergeSlots(oldSlots: Dictionary<String, [String]>?, newSlots: Dictionary<String, [String]>?) -> Dictionary<String, [String]> {
        let oldValue = oldSlots ?? Dictionary<String, [String]>()
        let newValue = newSlots ?? Dictionary<String, [String]>()
        
        return oldValue.merging(newValue) { (_, new) in new }
    }
}
