//
//  MockAppointmentServiceManager.swift
//  BiWF
//
//  Created by pooja.q.gupta on 29/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
@testable import BiWF

class MockAppointmentServiceManager: AppointmentServiceManager {
    
    func getAppointmentSlots(for serviceAppointmentID: String, earlistPermittedDate: String) -> Observable<Result<Data, Error>> {
        let serviceAppointmentResult = PublishSubject<Result<Data, Error>>()
        serviceAppointmentResult.onNext(getDataFromJSON(resource: "appointmentSlotResponse"))
        return serviceAppointmentResult
    }
    
    func rescheduleAppointment(with parameters: RescheduleAppointment) -> Observable<Result<Data, Error>> {
        let serviceAppointmentResult = PublishSubject<Result<Data, Error>>()
        serviceAppointmentResult.onNext(getDataFromJSON(resource: "rescheduleAppointmentResponse"))
        return serviceAppointmentResult
    }
    
    func getServiceAppointment(for accountID: String) -> Observable<Result<Data, Error>> {
        let serviceAppointmentResult = PublishSubject<Result<Data, Error>>()
        serviceAppointmentResult.onNext(getDataFromJSON(resource: "serviceAppointmentResponse"))
        return serviceAppointmentResult
    }
    
    func cancelAppointment(_ appointment: ServiceAppointment) -> Observable<Result<Data, Error>> {
        let cancelAppointmentResult = PublishSubject<Result<Data, Error>>()
        cancelAppointmentResult.onNext(getDataFromJSON(resource: "cancelAppointmentResponse"))
        return cancelAppointmentResult
    }
    
    
    func getAppointmentSlots() -> Dictionary<String, [String]> {
        guard let path = Bundle.main.path(forResource: "appointmentSlotResponse",
                                          ofType: "json") else {
                                            return Dictionary<String, [String]> ()
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path),
                                options: .mappedIfSafe)
            let accountInfo = try JSONDecoder().decode( (Dictionary<String, [String]>).self, from: data)
            return accountInfo
        } catch {
            print(error)
            return Dictionary<String, [String]> ()
        }    }
    
    private func getDataFromJSON(resource: String) -> Result<Data, Error> {
        guard let path = Bundle.main.path(forResource: resource, ofType: "json") else {
            return .failure(HTTPError.noResponse)
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
}

