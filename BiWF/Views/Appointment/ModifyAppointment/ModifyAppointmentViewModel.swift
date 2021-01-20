//
//  ModifyAppointmentViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 04/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
/*
   ModifyAppointmentViewModel to modify the user Appointment
 */

class ModifyAppointmentViewModel {
    
    /// Sectiontype to select the approriate section
    enum SectionType: Int {
        case availbaleDate = 0
        case availableSlot
    }
    
    /// Input structure
    struct Input {
        let nextTapObserver: AnyObserver<Void>
        let appointmentConfirmationObserver: AnyObserver<(ArrivalTime, AppointmentType)>
        let backTapObserver: AnyObserver<Void>
    }
    
    /// Output structure
    struct Output {
        let viewStatusObservable: Observable<ViewStatus>
        let showAlertObservable: Observable<String>
        let viewComplete: Observable<DashboardCoordinator.Event>
    }
    
    /// Subject to view the status of the Appointment
    let viewStatusSubject = PublishSubject<ViewStatus>()
    
    /// Subject to select the next option
    private let nextTapSubject = PublishSubject<Void>()
    
    /// Subject to check about confirmation of user's appointment
    let appointmentConfirmationSubject = PublishSubject<(ArrivalTime, AppointmentType)>()
    
    /// Subjects to come back from the present screen
    private let backTapSubject = PublishSubject<Void>()
    
    /// Subject to show the alert pop-up
    let showAlertSubject = PublishSubject<String>()
    
    /// BehaviorSubject to select and hild the values
    let selectedDateSubject = BehaviorSubject<Date?>(value: nil)
    let selectedSlotSubject = BehaviorSubject<String?>(value: nil)
    let selectedSlotErrorSubject = BehaviorSubject<Bool>(value: false)

    /// Input & Output structure variable
    let input: Input
    let output: Output
    
    /// Variable to get  ServiceAppointment model class values
    let serviceAppointment: ServiceAppointment
    
    /// AppointmentRepository for calling appointment related APIs
    let repository: AppointmentRepository
    
    ///Variable to get  AvailableSlotsResponse model class values
    var availableSlots: AvailableSlotsResponse?
    
    /// For creating data source for section
    let sections = BehaviorSubject(value: [TableDataSource]())
    
    ///slots variable to get the slot view model values
    var slots = [Slot]()
    
    var earliestPermittedDate: Date?
    
    /// Bool variable to check the reshcedule appointment error
    var isRescheduleAppointementError: Bool = false
    
    ///Bool variable to check the slot is selected or not
    var isSelectedSlotError: Bool = false
    
    let disposeBag = DisposeBag()
    
    /// Initialize a new instance of ServiceAppointment and AppointmentRepository
    /// - Parameter ServiceAppointment : to take thedetails about user appointment
    /// AppointmentRepository : Give the API value for Appointment
    init(with serviceAppointment: ServiceAppointment, and appointmentRepository: AppointmentRepository) {
        self.serviceAppointment = serviceAppointment
        self.repository = appointmentRepository
        
        input = Input(
            nextTapObserver: nextTapSubject.asObserver(),
            appointmentConfirmationObserver: appointmentConfirmationSubject.asObserver(),
            backTapObserver: backTapSubject.asObserver()
        )
        
        let appointmentConfirmationObservable = appointmentConfirmationSubject.asObservable().map { arrivalTime, appointmentType in
            return DashboardCoordinator.Event.goToAppointmentBookingConfirmation(arrivalTime, appointmentType)
        }
        
        let backEventObservable = backTapSubject.asObservable().map { _ in
            return DashboardCoordinator.Event.goBackToDashboard
        }
        
        let viewCompleteObservable = Observable.merge(appointmentConfirmationObservable,
                                                      backEventObservable)
        
        
        output = Output(viewStatusObservable: viewStatusSubject.asObservable(),
                        showAlertObservable: showAlertSubject.asObservable(),
                        viewComplete: viewCompleteObservable)
        
        nextTapSubject.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            do {
                let selectedDate = try self.selectedDateSubject.value()
                let selectedSlot = try self.selectedSlotSubject.value()
                
                if let selectedDate = selectedDate, let selectedSlot = selectedSlot {
                    let arrivalTime = self.getArrivalStartAndEndTime(by: selectedDate, slot: selectedSlot)
                    self.rescheduleAppointment(with: arrivalTime.startTime, endTime: arrivalTime.endTime)
                }
            } catch {}
        }).disposed(by: disposeBag)
        
        createSubscription()
        checkForAvailableSlots(shouldClearData: false)
        selectedSlotErrorSubject.subscribe(onNext: { (isError) in
            self.isSelectedSlotError = isError
            self.selectedSlotSubject.onNext(nil)
            self.setSections()
        }).disposed(by: disposeBag)
    }
    
    
    /// Function to get the start and end time of apponitment
    func getArrivalStartAndEndTime(by date: Date, slot: String) -> ArrivalTime {
        let timeSlot: String = slot
        let timeArray = timeSlot.split(separator: "-")
        let startDate = String(timeArray[0]).combinedDate(date: date)
        let endDate = String(timeArray[1]).combinedDate(date: date)
        return ArrivalTime(startTime: startDate, endTime: endDate)
    }
}

/// ModifyAppointmentViewModel extension which contains all the table datasource functions
extension ModifyAppointmentViewModel {
    func setSections() {
        sections.onNext(getSections())
    }
    
    /// used to get the date and time sections from table datasource
    private func getSections() -> [TableDataSource] {
        var dataSource = [createAvailableDatesSection()]
        do {
            let selectedDate = try self.selectedDateSubject.value()
            if let date = selectedDate {
                dataSource.append(createAvailableSlotsSection(for: date))
            }
        } catch {}
        return dataSource
    }
    
    /// Section used to select the date for appointment and returns a array of itams
    private func createAvailableDatesSection() -> TableDataSource {
        
        var items = [Item]()
        
        if let slots = self.availableSlots {
            let viewModel = AvailableDatesCellViewModel.init(with: slots.slotsValue ?? Dictionary<String,[String]>(), appointmentType: serviceAppointment.getAppointmentType())
            viewModel.output.selectedDateObservable
                .subscribe(onNext: {[weak self] (date) in
                    guard let self = self else { return }
                    self.selectedDateSubject.onNext(date)
                    self.selectedSlotSubject.onNext(nil)
                    self.slots = [Slot]()
                    self.setSections()
                }).disposed(by: disposeBag)
            
            items = [Item.init(identifier: AvailableDatesTableViewCell.identifier, viewModel: viewModel)]
        }
        return TableDataSource(header:nil,
                               items: items)
    }
    
    /// Section used to create the available timeslot for selected date
    /// - Parameter selectedDate:appointment booked date and returns a tabledatasource with array of items
    private func createAvailableSlotsSection(for selectedDate: Date) -> TableDataSource {
        
        var items = [Item]()
        
        if let slotDict = self.availableSlots?.slotsValue {
            
            if self.slots.count == 0 {
                self.slots = createSlotArray(from: slotDict[selectedDate.toString(withFormat: Constants.DateFormat.YYYY_M_d)] ?? [String]())
            }
            
            items = slots.compactMap { slot -> Item in
                let viewModel = AvailableTimeSlotCellViewModel(with: slot, isErrorState: self.isSelectedSlotError)
                
                viewModel.output.isSelectedObservable
                    .subscribe(onNext: {[weak self] _ in
                        guard let self = self else { return }
                        self.isSelectedSlotError = false
                        self.selectedSlotSubject.onNext(slot.value)
                        self.select(slot: slot)
                        self.setSections()
                    }).disposed(by: disposeBag)
                
                return Item.init(identifier: AvailableTimeSlotTableViewCell.identifier,
                                 viewModel: viewModel)
            }
        }
        return TableDataSource(header:nil,
                               items: items)
    }
    
    /// creating a array of slots with value,index and selected var
    /// - Parameter : Array of Strings and returns a array of slots value
    private func createSlotArray(from array: [String]) -> [Slot] {
        var slotsArray = [Slot]()
        for (index, item) in array.enumerated() {
            let slot = Slot(value: item, index: index)
            slotsArray.append(slot)
        }
        return slotsArray
    }
    
    /// Function to select the Slot
    /// - Parameter Slot: Struct containing value,index and IsSelected the slot
    private func select(slot: Slot) {
        var array = [Slot]()
        slots.forEach {
            var item = $0
            item.isSelected = (slot.value == item.value) ? true : false
            array.append(item)
        }
        
        slots = array
    }
}
