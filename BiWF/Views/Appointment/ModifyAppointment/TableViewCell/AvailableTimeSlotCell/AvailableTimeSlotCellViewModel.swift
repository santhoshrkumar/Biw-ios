
//
//  AvailableTimeSlotCellViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 04/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
/*
 AvailableTimeSlotCellViewModel to check the Available time slot for the user to book appointment
 */
class AvailableTimeSlotCellViewModel {
    
    /// Output Structure
    struct Output {
        let titleDriver: Driver<String>
        let isSelectedDriver: Driver<Bool>
        let isSelectedObservable: Observable<Void>
        let showErrorState: Driver<Bool>
    }
    
    /// Input Structure
    struct Input {
        let isSelectedObserver: AnyObserver<Void>
    }
    
    /// Input & Output structure variable
    let output: Output
    let input: Input
    
    /// Subject to check whether slot is selected or not
    private let isSelectedSubject = PublishSubject<Void>()
    
    /// Initialize a new instance of available slots with error state
    /// - Parameter slot: to check the available slot to book
    /// ErrorState : return bool value indicating error occurred or not, to display the error on UI
        init(with slot: Slot, isErrorState: Bool) {
        output = Output(titleDriver: .just(slot.value ?? ""),
                        isSelectedDriver: .just(slot.isSelected),
                        isSelectedObservable: isSelectedSubject.asObservable(),
                        showErrorState: .just(isErrorState)
        )
        
        input = Input(isSelectedObserver: isSelectedSubject.asObserver())
    }
}
