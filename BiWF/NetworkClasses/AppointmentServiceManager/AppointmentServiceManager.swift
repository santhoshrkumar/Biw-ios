//
//  AppointmentServiceManager.swift
//  BiWF
//
//  Created by pooja.q.gupta on 26/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift

protocol AppointmentServiceManager{    
    func getServiceAppointment(for accountID: String) -> Observable<Result<Data, Error>>
    func getAppointmentSlots(for serviceAppointmentID: String, earlistPermittedDate: String) -> Observable<Result<Data, Error>>
    func rescheduleAppointment(with parameters: RescheduleAppointment) -> Observable<Result<Data, Error>>
    func cancelAppointment(_ appointment: ServiceAppointment) -> Observable<Result<Data, Error>>
}
