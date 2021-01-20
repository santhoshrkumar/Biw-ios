//
//  AdditionalInfoViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 04/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import DPProtocols
import UIKit
/*
 AdditionalInfoViewModel for user to add the additional info
 */

class AdditionalInfoViewModel {
    /// Input structure
    struct Input {
        let cancelTapObserver: AnyObserver<Void>
        let backTapObserver: AnyObserver<Void>
        let moreInfoObserver: AnyObserver<ScheduleCallback>
    }
    
    /// Output structure
    struct Output {
        let viewComplete: Observable<SupportCoordinator.Event>
        let moreInfoTextDriver: Driver<NSAttributedString>
        let nextButtonTextDriver: Driver<String>
    }
    
    /// Handles the cancel button tap
    private let cancelTapSubject = PublishSubject<Void>()
    
    /// Handles the back button tap
    private let backTapSubject = PublishSubject<Void>()
    private let moreInfoSubject =  PublishSubject<ScheduleCallback>()
    
    /// Input & Output structure variable
    let input: Input
    let output: Output
    var scheduleCallBack: ScheduleCallback

    init(scheduleCallBack: ScheduleCallback) {
        self.scheduleCallBack = scheduleCallBack
        input = Input(
            cancelTapObserver: cancelTapSubject.asObserver(),
            backTapObserver: backTapSubject.asObserver(),
            moreInfoObserver: moreInfoSubject.asObserver()
        )
        
        let cancelEventObservable = cancelTapSubject.asObservable().map { _ in
            return SupportCoordinator.Event.goBackToTabView
        }
        
        let backEventObservable = backTapSubject.asObservable().map { _ in
            return SupportCoordinator.Event.goBack
        }
        
        let nextMoreInfoEventObservable = moreInfoSubject.asObservable().map { scheduleCallBackDetails in
            return SupportCoordinator.Event.goToContactInformation(scheduleCallBackDetails)
        }
        
        let viewCompleteObservable = Observable.merge(cancelEventObservable,
                                                      backEventObservable,
                                                      nextMoreInfoEventObservable)
        
        let optionalText = " (\(Constants.CancelSubscription.optional)) ".attributedString(with: .regular(ofSize: UIFont.font12), textColor: UIColor.BiWFColors.med_grey)
            
        let moreInfo = NSMutableAttributedString.init(string: Constants.AdditionalInfo.moreInfo, attributes: [.foregroundColor: UIColor.BiWFColors.purple])
        moreInfo.append(optionalText)
        
        output = Output(viewComplete: viewCompleteObservable,
                        moreInfoTextDriver: .just(moreInfo),
                        nextButtonTextDriver: .just(Constants.AdditionalInfo.moreInfoNextButton))
    }
}
