//
//  NetworkAppointmentServiceManager.swift
//  BiWF
//
//  Created by pooja.q.gupta on 26/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import LocalAuthentication
import RxSwift

class NetworkAppointmentServiceManager: AppointmentServiceManager {
    
    private let disposeBag = DisposeBag()
    var serviceManager = ServiceManager.shared
    
    static let shared: NetworkAppointmentServiceManager = {
        let instance = NetworkAppointmentServiceManager()
        return instance
    }()
    
    func getServiceAppointment(for accountID: String) -> Observable<Result<Data, Error>> {
        let serviceAppointmentResult = PublishSubject<Result<Data, Error>>()
        
        let endpoint = serviceManager.buildPath(withEnvironmentPath: EnvironmentPath.serviceAppointment,
                                                endPoint: accountID,
                                                sobjects: false)
        let path = EnvironmentPath.salesforceServiceBase + endpoint
        if let requestUrl = URL(string: path) {
            var request = URLRequest(url: requestUrl)
            request.httpMethod = HTTPMethod.get.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders(nil)
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                serviceAppointmentResult.onNext(ServiceManager.shared.handleResponseForSFApi(with: data, response: response, error: error))
                serviceAppointmentResult.onCompleted()
            }
            dataTask.resume()
        }
        return serviceAppointmentResult.asObservable()
    }
    
    func getAppointmentSlots(for serviceAppointmentID: String, earlistPermittedDate: String) -> Observable<Result<Data, Error>> {

        let appointmentSlotsResult = PublishSubject<Result<Data, Error>>()
        let endpoint = serviceManager.buildServicePath(with: EnvironmentPath.appointmentSlot,
                                                       firstEndPoint: serviceAppointmentID,
                                                       secondEndPoint: earlistPermittedDate)
        let path = EnvironmentPath.salesforceApexBase + endpoint

        if let requestUrl = URL(string: path) {
            var request = URLRequest(url: requestUrl)
            request.httpMethod = HTTPMethod.get.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders(nil)
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                appointmentSlotsResult.onNext(ServiceManager.shared.handleResponseForSFApi(with: data, response: response, error: error))
                appointmentSlotsResult.onCompleted()
            }
            dataTask.resume()
        }
        return appointmentSlotsResult.asObservable()
    }

    func rescheduleAppointment(with parameters: RescheduleAppointment) -> Observable<Result<Data, Error>> {

        let rescheduleAppointmentResult = PublishSubject<Result<Data, Error>>()
        let path = EnvironmentPath.salesforceApexBase + EnvironmentPath.rescheduleAppointment.rawValue
        
        if let requestUrl = URL(string: path) {
            var request = URLRequest(url: requestUrl)
            request.httpMethod = HTTPMethod.post.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders(nil)
            let params: [String: Any]  = [
                Constants.Networking.serviceAppointmentID: parameters.serviceAppointmentID ?? "",
                Constants.Networking.arrivalWindowStartTime: parameters.arrivalWindowStartTime ?? "",
                Constants.Networking.arrivalWindowEndTime: parameters.ArrivalWindowEndTime ?? "",
            ]
            request.httpBody = serviceManager.generateHTTPBody(from: params)
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                rescheduleAppointmentResult.onNext(ServiceManager.shared.handleResponseForSFApi(with: data, response: response, error: error))
                rescheduleAppointmentResult.onCompleted()
            }
            dataTask.resume()
        }
        return rescheduleAppointmentResult.asObservable()
    }
    
    func cancelAppointment(_ appointment: ServiceAppointment) -> Observable<Result<Data, Error>> {
        let cancelAppointmentResult = PublishSubject<Result<Data, Error>>()
        let path = EnvironmentPath.salesforceApexBase + EnvironmentPath.cancelAppointment

        if let requestUrl = URL(string: path) {
            var request = URLRequest(url: requestUrl)
            request.httpMethod = HTTPMethod.post.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders(nil)
            let params: [String: Any]  = [
                Constants.Networking.appointmentNumber: appointment.appointmentNumber,
                Constants.Networking.appointmentStatus: appointment.status
            ]
            request.httpBody = ServiceManager.shared.generateHTTPBody(from: params)
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                cancelAppointmentResult.onNext(ServiceManager.shared.handleResponseForSFApi(with: data, response: response, error: error))
                cancelAppointmentResult.onCompleted()
            }
            dataTask.resume()
        }
        return cancelAppointmentResult.asObservable()
    }
}
