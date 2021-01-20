//
//  CancelSubscriptionViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 22/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
/*
 CancelSubscriptionViewModel handles the CancelSubscription
 */
class CancelSubscriptionViewModel {
    
    /// Input Structure
    struct Input {
        let cancelTapObserver: AnyObserver<Void>
        let backTapObserver: AnyObserver<Void>
        let keepServiceTapObserver: AnyObserver<Void>
        let cancelServiceTapObserver: AnyObserver<Void>
        let cancellationDateObserver: AnyObserver<Date?>
        let commentsObserver: AnyObserver<String?>
    }
    
    /// Output Structure
    struct Output {
        let viewStatusObservable: Observable<ViewStatus>
        let cancellationReasonSelectedObservable: Observable<String>
        let ratingUpdatedObservable: Observable<Int>
        let headerTextDriver: Driver<String>
        let specifyReasonTextDriver: Driver<NSAttributedString>
        let rateExperienceTextDriver: Driver<NSAttributedString>
        let commentsTextDriver: Driver<NSAttributedString>
        let submitBtnTextDriver: Driver<String>
        let pickerViewModelObservable: Observable<PickerViewModel>
        let ratingViewModelObservable: Observable<RatingViewModel>
        let viewComplete: Observable<SubscriptionCoordinator.Event>
        let cancellationDateObservable: Observable<Date?>
    }
    
    /// Subject to handle error on saving changes
    var errorSavingChangesSubject = PublishSubject<Void>()
    
    /// Subject to viewstatus
    private let viewStatusSubject = PublishSubject<ViewStatus>()
    
    let keepServiceTapSubject = PublishSubject<Void>()
    let cancelServiceTapSubject = PublishSubject<Void>()
    
    /// Subject to handle cancel button tap
    private let cancelTapSubject = PublishSubject<Void>()
    
    /// Subject to handle back button tap
    private let backTapSubject = PublishSubject<Void>()
    
    ///BehaviourSubject to hold the value
    private let cancellationReasonSelectedSubject = BehaviorSubject<String>(value: "")
    private let ratingUpdateSubject = BehaviorSubject<Int>(value: 0)
    let cancellationSuccessSubject = PublishSubject<Void>()
    private let cancellationDateSubject =  BehaviorSubject<Date?>(value: nil)
    private let commentsSubject =  BehaviorSubject<String?>(value: nil)
    
    /// Holds subscriptionRepository with strong reference
    private var subscriptionRepository: SubscriptionRepository
    
    /// Holds account with strong reference
    private var account: Account
    
    /// Input & Output structure variable
    let input: Input
    let output: Output
    
    private let disposeBag = DisposeBag()
    private let cancellationReasons = [Constants.CancelSubscription.CancellationReason.reliabilityOrSpeed,
                                       Constants.CancelSubscription.CancellationReason.priceOrBilling,
                                       Constants.CancelSubscription.CancellationReason.installation,
                                       Constants.CancelSubscription.CancellationReason.customerSupport,
                                       Constants.CancelSubscription.CancellationReason.moving,
                                       Constants.CancelSubscription.CancellationReason.other]
    var rating: Int = 0
    var subscriptionEndDate: String
    
    /// Initializes a new instance of Account and SubscriptionRepository
    /// - Parameter Account : Contains all account values
    /// SubscriptionRepository : Gives all the api values to the Subscription model
    init(withAccount account: Account, subscriptionRepository: SubscriptionRepository) {
        
        let pickerViewModel = PickerViewModel(with: cancellationReasons)
        let ratingViewModel = RatingViewModel.init(with: rating)
        
        self.subscriptionEndDate = account.subscriptionEndDate ?? ""
        self.subscriptionRepository = subscriptionRepository
        self.account = account
        input = Input(
            cancelTapObserver: cancelTapSubject.asObserver(),
            backTapObserver: backTapSubject.asObserver(),
            keepServiceTapObserver: keepServiceTapSubject.asObserver(),
            cancelServiceTapObserver: cancelServiceTapSubject.asObserver(),
            cancellationDateObserver: cancellationDateSubject.asObserver(),
            commentsObserver: commentsSubject.asObserver()
        )
        
        let cancelEventObservable = cancelTapSubject.asObservable().map { _ in
            return SubscriptionCoordinator.Event.goBackToAccount
        }
        
        let backEventObservable = backTapSubject.asObservable().map { _ in
            return SubscriptionCoordinator.Event.goBack
        }
        
        let keepServiceEventObservable = keepServiceTapSubject.asObservable().map { _ in
            return SubscriptionCoordinator.Event.goBackToAccount
        }
        
        let cancelServiceEventObservable = cancellationSuccessSubject.asObservable().map { _ in
            return SubscriptionCoordinator.Event.goBackToAccount
        }
        
        let errorSavingChangesObservable = errorSavingChangesSubject.asObservable().map { _ in
            return SubscriptionCoordinator.Event.errorSavingChangesAlert
        }
        
        let viewCompleteObservable = Observable.merge(cancelEventObservable,
                                                      backEventObservable,
                                                      keepServiceEventObservable,
                                                      cancelServiceEventObservable,
                                                      errorSavingChangesObservable)
        
        
        let optionalText = NSMutableAttributedString.init(string: " (\(Constants.CancelSubscription.optional))", attributes: [.foregroundColor: UIColor.BiWFColors.light_grey])
        
        let specifyReason = NSMutableAttributedString.init(string: Constants.CancelSubscription.specifyCancellationReason, attributes: [.foregroundColor: UIColor.BiWFColors.med_grey])
        specifyReason.append(optionalText)
        
        let rateExperience = NSMutableAttributedString.init(string: Constants.CancelSubscription.rateExperience, attributes: [.foregroundColor: UIColor.BiWFColors.med_grey])
        rateExperience.append(optionalText)
        
        let comments = NSMutableAttributedString.init(string: Constants.CancelSubscription.comments, attributes: [.foregroundColor: UIColor.BiWFColors.med_grey])
        comments.append(optionalText)
        
        output = Output(viewStatusObservable: viewStatusSubject.asObservable(),
                        cancellationReasonSelectedObservable: cancellationReasonSelectedSubject.asObservable(), ratingUpdatedObservable: ratingUpdateSubject.asObservable(),
                        headerTextDriver: .just(Constants.CancelSubscription.sorryToSeeYouGo),
                        specifyReasonTextDriver: .just(specifyReason),
                        rateExperienceTextDriver: .just(rateExperience),
                        commentsTextDriver: .just(comments),
                        submitBtnTextDriver: .just(Constants.CancelSubscription.submit),
                        pickerViewModelObservable: Observable.just(pickerViewModel),
                        ratingViewModelObservable: Observable.just(ratingViewModel),
                        viewComplete: viewCompleteObservable,
                        cancellationDateObservable: cancellationDateSubject.asObservable())
        
        pickerViewModel.itemSelectedSubject.subscribe(onNext: {[weak self] element in
            guard let self = self else {return}
            self.cancellationReasonSelectedSubject.onNext(element)
        }).disposed(by: disposeBag)
        
        ratingViewModel.updateRatingSubject.subscribe(onNext: {[weak self] rating in
            guard let self = self else {return}
            self.rating = rating
            self.ratingUpdateSubject.onNext(rating)
        }).disposed(by: disposeBag)
        
        cancelServiceTapSubject.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.cancelServices)
            self.cancelMySubscription()
        }).disposed(by: disposeBag)
        
        cancellationDateSubject.subscribe(onNext: { [weak self] selectedDate in
            guard let self = self else { return }
            if let dateSelected = selectedDate {
                self.subscriptionEndDate = dateSelected.toString(withFormat: Constants.DateFormat.MMMMddyyyy)
            }
        }).disposed(by: disposeBag)
    }
}

/// CancelSubscriptionViewModel extension
extension CancelSubscriptionViewModel {
    
    /// Method to handle cancel subscription 
    func cancelMySubscription() {
        do {
            let loading = ViewStatus.loading(loadingText: nil)
            self.viewStatusSubject.onNext(loading)
            
            self.subscriptionRepository.recordIDResult
                .subscribe({ id in
                    do {
                        let contactID = self.account.contactId
                        let cancelReason = try self.cancellationReasonSelectedSubject.value()
                        let cancelComment = try self.commentsSubject.value()
                        let rating = try self.ratingUpdateSubject.value()
                        let date = try self.cancellationDateSubject.value()
                        self.subscriptionRepository.cancellationStatusResult
                            .subscribe({ success in
                                
                                self.viewStatusSubject.onNext(ViewStatus.loaded)
                                
                                self.cancellationSuccessSubject.onNext(())
                                AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.cancelSubscriptionSuccess)
                            }).disposed(by: self.disposeBag)
                        
                        let cancelSubscription = CancelSubscription(contactID: contactID,
                                                                    cancellationReason: cancelReason,
                                                                    cancellationComment: cancelComment,
                                                                    rating: String(rating),
                                                                    recordTypeID: id.element,
                                                                    cancellationDate: date?.toString(withFormat: Constants.DateFormat.YYYY_MM_dd),
                                                                    caseID: "",
                                                                    status: false)
                        self.subscriptionRepository.cancelMySubscription(forCancelSubscription: cancelSubscription)
                    } catch {}
                }).disposed(by: self.disposeBag)
            self.subscriptionRepository.getRecordID()
            
            //Subscribe the error
            subscriptionRepository.errorMessage
                .subscribe(onNext: {[weak self] error in
                    self?.errorSavingChangesSubject.onNext(())
                    AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.cancelSubscriptionFailure)
                }).disposed(by: self.disposeBag)
        }
    }
}
