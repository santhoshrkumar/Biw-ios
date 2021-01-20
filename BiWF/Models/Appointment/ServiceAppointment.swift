
//
//  Appointment.swift
//  BiWF
//
//  Created by pooja.q.gupta on 02/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation

struct ServiceAppointmentList: Codable {
    let records: [ServiceAppointment]
    
    enum CodingKeys: String, CodingKey {
        case records = "records"
    }
}

struct ServiceTerritory: Codable {
    let operatingHours: OperatingHours
    
    enum CodingKeys: String, CodingKey {
        case operatingHours = "OperatingHours"
    }
}

struct OperatingHours: Codable {
    let timeZone: String?
    
    enum CodingKeys: String, CodingKey {
        case timeZone = "TimeZone"
    }
}

struct ServiceAppointment: Codable {
    let arrivalStartTime: String?
    let arrivalEndTime: String?
    let status: String
    let workTypeId: String?
    let jobType: String?
    let appointmentId: String
    let latitude: Double?
    let longitude: Double?
    let appointmentNumber: String
    let serviceTerritory: ServiceTerritory?
    let serviceResources: ServiceResourceList?
    
    enum CodingKeys: String, CodingKey {
        case arrivalStartTime = "ArrivalWindowStartTime"
        case arrivalEndTime = "ArrivalWindowEndTime"
        case status = "Status"
        case workTypeId = "WorkTypeId"
        case jobType = "Job_Type__c"
        case appointmentId = "Id"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case appointmentNumber = "Appointment_Number_Text__c"
        case serviceTerritory = "ServiceTerritory"
        case serviceResources = "ServiceResources"
    }
    
    var isCloseServiceCompleteCard: Bool {
        return UserDefaults.standard.value(forKey: Constants.Common.isCloseServiceCompleteCard) as? Bool ?? false
    }
    
    func set(isCloseServiceCompleteCard: Bool) {
        UserDefaults.standard.set(isCloseServiceCompleteCard, forKey: Constants.Common.isCloseServiceCompleteCard)
    }
    
    var isCloseAppointmentNotification: Bool {
        return UserDefaults.standard.value(forKey: Constants.Common.isCloseAppointmentNotification) as? Bool ?? false
    }
    
    func set(isCloseAppointmentNotification: Bool) {
        UserDefaults.standard.set(isCloseAppointmentNotification, forKey: Constants.Common.isCloseAppointmentNotification)
    }
    
    var closeNotificationState: String {
        return UserDefaults.standard.value(forKey: Constants.Common.closeNotificationState) as? String ?? ""
    }
    
    func setCloseNotificationState() {
        UserDefaults.standard.set(status, forKey: Constants.Common.closeNotificationState)
    }
    
    var cancelAppointmentId: String {
        return UserDefaults.standard.value(forKey: Constants.Common.cancelAppointmentId) as? String ?? ""
    }
    
    func setCancelAppointmentId() {
        UserDefaults.standard.set(appointmentId, forKey: Constants.Common.cancelAppointmentId)
    }
    
    func removeCancelAppointmentId() {
        UserDefaults.standard.removeObject(forKey: Constants.Common.cancelAppointmentId)
    }
    
    func shouldShowNotificationForState() -> Bool {
        return !(self.isCloseAppointmentNotification && self.closeNotificationState == status) && !(self.getAppointmentType() == .service && self.getState() == .scheduled)
    }
    
    func getInstallationDate() -> String {
        let formattedDate = arrivalStartTime?.formattedDateFromString(dateString: arrivalStartTime ?? "", withFormat: Constants.DateFormat.MMMdyyyy, and: TimeZone(identifier: serviceTerritory?.operatingHours.timeZone ?? "") ?? .current)
        return formattedDate ?? ""
    }
    
    func getAppointmentTime() -> String? {
        
        if let arrivalStartTime = self.arrivalStartTime, let arrivalEndTime = self.arrivalEndTime {
            let startTime = arrivalStartTime.formattedDateFromString(dateString: arrivalStartTime, withFormat: Constants.DateFormat.hmma, and: TimeZone(identifier: serviceTerritory?.operatingHours.timeZone ?? "") ?? .current)
            let endTime = arrivalEndTime.formattedDateFromString(dateString: arrivalEndTime, withFormat: Constants.DateFormat.hmma, and: TimeZone(identifier: serviceTerritory?.operatingHours.timeZone ?? "") ?? .current)
            return "\(startTime ?? "") and \(endTime ?? "")"
        } else {
            return nil
        }
    }
    
    
    func getState() -> InstallationState {
        ///This condition added due to delay in cancel appointment API
        ///When we cancel appointment its status get updated after sometime.
        if cancelAppointmentId == appointmentId {
            return .cancelled
        } else if status == "Scheduled" || status == "Dispatched" || status == "None" {
            return .scheduled
        } else if status == "Enroute" {
            return .enRoute
        } else if status == "Work Begun" {
            return .inProgress
        } else if status == "Canceled" {
            return .cancelled
        } else {
            return .complete
        }
    }
    
    func getAppointmentType() -> AppointmentType {
        return (jobType == "Fiber Install - For Installations") ? .installation : .service
    }
    
    func getTechnicianName() -> String? {
        guard let records = serviceResources?.records else { return nil }
        if records.count == 0 {
            return nil
        } else {
            return records[0].serviceResource.name
        }
    }
    
    func getEstimatedArrivalTime() -> String {
        
        let startTimeFormat = arrivalStartTime?.formattedDateFromString(dateString: arrivalStartTime ?? "", withFormat: Constants.DateFormat.a, and: TimeZone(identifier: serviceTerritory?.operatingHours.timeZone ?? "") ?? .current)
        let endTimeFormat = arrivalEndTime?.formattedDateFromString(dateString: arrivalEndTime ?? "", withFormat: Constants.DateFormat.a, and: TimeZone(identifier: serviceTerritory?.operatingHours.timeZone ?? "") ?? .current)
        
        if startTimeFormat == endTimeFormat {
            let startTime = arrivalStartTime?.formattedDateFromString(dateString: arrivalStartTime ?? "", withFormat: Constants.DateFormat.hmm, and: TimeZone(identifier: serviceTerritory?.operatingHours.timeZone ?? "") ?? .current)
            let endTime = arrivalEndTime?.formattedDateFromString(dateString: arrivalEndTime ?? "", withFormat: Constants.DateFormat.hmm, and: TimeZone(identifier: serviceTerritory?.operatingHours.timeZone ?? "") ?? .current)
            return "\(startTime ?? "")-\(endTime ?? "")\(startTimeFormat ?? "")"
        } else {
            let startTime = arrivalStartTime?.formattedDateFromString(dateString: arrivalStartTime ?? "", withFormat: Constants.DateFormat.hmma, and: TimeZone(identifier: serviceTerritory?.operatingHours.timeZone ?? "") ?? .current)
            let endTime = arrivalEndTime?.formattedDateFromString(dateString: arrivalEndTime ?? "", withFormat: Constants.DateFormat.hmma, and: TimeZone(identifier: serviceTerritory?.operatingHours.timeZone ?? "") ?? .current)
            return "\(startTime ?? "")-\(endTime ?? "")"
        }
    }
    
    func isCurrentTimeGreaterThanStartTime() -> Bool {
        return (arrivalStartTime?.toDate(with: Constants.DateFormat.YYYYMMddT) ?? Date() < Date())
    }
}
