//
//  NetworkViewModel.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 6/25/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import UIKit
/*
   NetworkInfoViewModel to show network information of my network and guest network
**/
class NetworkInfoViewModel {
    
    /// Input structure
    struct Input {
        let doneObserver: AnyObserver<Void>
        let saveChangesTapObserver: AnyObserver<Void>
    }
    
    /// Output structure
    struct Output {
        let viewStatusObservable: Observable<ViewStatus>
        let setInsetObservable: Observable<UIEdgeInsets>
        let viewComplete: Observable<DashboardCoordinator.Event>
        let indicatorViewObservable: Observable<Bool>
    }

    /// Input & Output structure variable
    let input: Input
    let output: Output
    
    var isEnableWifiNetwork = false
    
    /// For create data source for section
    let sections = BehaviorSubject(value: [TableDataSource]())
    
    /// networkRepository for calling network related APIs
    let networkRepository: NetworkRepository
    
    // MARK: - Subject
    /// Subject to show hide loading indicator
    let viewStatusSubject = PublishSubject<ViewStatus>()
    
    /// Subject to show hide indicator view
    let indicatorViewStatusSubject = PublishSubject<Bool>()
    
    /// Subject to show error
    let errorSavingChangesSubject = PublishSubject<Void>()
    
    /// Subject to show error alert 
    let showErrorAlertSubject = PublishSubject<(isForEnable: Bool, interface: String)>()

    ///Enable disable MyNetwork and Guest network tap
    private let myNetworkEnableDisableTapSubject = PublishSubject<Bool>()
    private let guestNetworkEnableDisableTapSubject = PublishSubject<Bool>()
    
    ///To handle done and save changes action
    private let doneSubject = PublishSubject<Void>()
    private let saveChangesTapSubject = PublishSubject<Void>()
    
    private let setInsetSubject = PublishSubject<UIEdgeInsets>()
    
    ///BehaviourSubject to hold the value shown in the textfield
    let myNetworkNameSubject = BehaviorSubject<String>(value: "")
    let myNetworkPasswordSubject = BehaviorSubject<String>(value: "")
    let guestNetworkNameSubject = BehaviorSubject<String>(value: "")
    let guestNetworkPasswordSubject = BehaviorSubject<String>(value: "")
    let myNetworkEnableDisableSubject = BehaviorSubject<Bool>(value: false)
    let guestNetworkEnableDisableSubject = BehaviorSubject<Bool>(value: false)
    
    let disposeBag = DisposeBag()
    
    ///Holds network information
    var myNetwork: WiFiNetwork
    var guestNetwork: WiFiNetwork
    
    ///Holds lists of network bands
    var bssidInfo: [String: String]
    
    var networkAPICallsCount = 0
    
    /// Initializes a new instance of network info viewmodel with
    /// - Parameter myNetwork: my network information
    ///             guestNetwork: guest network information
    ///             networkRepository: network repository to call API
    ///             bssidInfo: gnetwork data
    init(with myNetwork: WiFiNetwork, guestNetwork: WiFiNetwork, networkRepository: NetworkRepository, and bssidInfo: [String: String]) {
        self.myNetwork = myNetwork
        self.guestNetwork = guestNetwork
        self.networkRepository = networkRepository
        self.bssidInfo = bssidInfo
        
        input = Input(doneObserver: doneSubject.asObserver(),
                      saveChangesTapObserver: saveChangesTapSubject.asObserver())
        
        let dismissEventObservable = doneSubject.asObservable().map { _ -> DashboardCoordinator.Event in
            return DashboardCoordinator.Event.dismissNetwork
        }
        
        let errorSavingChangesObservable = errorSavingChangesSubject.asObservable().map { _ in
            return DashboardCoordinator.Event.errorSavingChangesAlert
        }
        
        let viewCompleteEventObservable = Observable.merge(dismissEventObservable,
                                                           errorSavingChangesObservable)
        
        output = Output(viewStatusObservable: viewStatusSubject.asObservable(),
            setInsetObservable: setInsetSubject.asObservable(),
            viewComplete: viewCompleteEventObservable,
            indicatorViewObservable: indicatorViewStatusSubject.asObservable())
        
        saveChangesTapSubject.subscribe(onNext: {[weak self] _ in
            self?.compareValuesAndCallAPI()
        }).disposed(by: disposeBag)
        
        myNetworkEnableDisableTapSubject.subscribe(onNext: {[weak self] isEnabled in
            guard let self = self else {return}
            if isEnabled {
                self.isEnableWifiNetwork = true
                self.enableNetwork(forInterface: NetworkRepository.Bands.Band5G.rawValue)
            } else {
                self.isEnableWifiNetwork = false
                self.disableNetwork(forInterface: NetworkRepository.Bands.Band5G.rawValue)
            }
            
        }).disposed(by: disposeBag)
        
        guestNetworkEnableDisableTapSubject.subscribe(onNext: {[weak self] isEnabled in
            guard let self = self else {return}
            if isEnabled {
                self.isEnableWifiNetwork = true
                self.enableNetwork(forInterface: NetworkRepository.Bands.Band5G_Guest.rawValue)
            } else {
                self.isEnableWifiNetwork = false
                self.disableNetwork(forInterface: NetworkRepository.Bands.Band5G_Guest.rawValue)
            }
            
        }).disposed(by: disposeBag)
        
        myNetworkNameSubject.onNext(myNetwork.name)
        myNetworkPasswordSubject.onNext(myNetwork.password)
        guestNetworkNameSubject.onNext(guestNetwork.name)
        guestNetworkPasswordSubject.onNext(guestNetwork.password)
        myNetworkEnableDisableSubject.onNext(myNetwork.isEnabled)
        guestNetworkEnableDisableSubject.onNext(guestNetwork.isEnabled)
        
        setSections()
    }
}

/// Network ViewModel Extension
extension NetworkInfoViewModel {
    /// Setting section for table view
    func setSections() {
        sections.onNext(getSections())
    }
    
    /// Get section
    ///- returns: Array of data source of section
    private func getSections() -> [TableDataSource] {
        return [
            createOnlineStatusSection(),
            createNetworkDetailSection()
        ]
    }
    
    /// Create section for showing online status view
    ///- returns: Data Source for online status section which contains section header and number items for section cell
    private func createOnlineStatusSection() -> TableDataSource {
        return TableDataSource(
            header: OnlineStatusCell.identifier,
            items: [
                Item(identifier: OnlineStatusCell.identifier, viewModel: OnlineStatusCellViewModel(networkRepository: networkRepository, type: .internet)),
                Item(identifier: OnlineStatusCell.identifier, viewModel: OnlineStatusCellViewModel(networkRepository: networkRepository, type: .modem))
            ]
        )
    }
    
    /// Create section for showing network details view
    ///- returns: Data Source for network detail section which no section header and number items for section cell
    private func createNetworkDetailSection() -> TableDataSource {
        
        do {
            let myNetworkName = try myNetworkNameSubject.value()
            let myNetworkPassword = try myNetworkPasswordSubject.value()
            let isMyNetworkEnabled = try myNetworkEnableDisableSubject.value()
            let guestNetworkName = try guestNetworkNameSubject.value()
            let guestNetworkPassword = try guestNetworkPasswordSubject.value()
            let isGuestNetworkEnabled = try guestNetworkEnableDisableSubject.value()
            
            let myWifiViewModel = NetworkDetailCellViewModel(with: WiFiNetwork(name: myNetworkName,
                                                                               password: myNetworkPassword,
                                                                               isGuestNetwork: false,
                                                                               isEnabled: isMyNetworkEnabled,
                                                                               nameState: myNetwork.nameState,
                                                                               passwordState: myNetwork.passwordState))
            
            
            myWifiViewModel.output.networkNameObservable
                .subscribe(onNext: {[weak self] networkName in
                    self?.myNetworkNameSubject.onNext(networkName)
                }).disposed(by: disposeBag)
            
            myWifiViewModel.output.networkPasswordObservable
                .subscribe(onNext: {[weak self] password in
                    self?.myNetworkPasswordSubject.onNext(password)
                }).disposed(by: disposeBag)
            
            myWifiViewModel.output.textFieldDidBeginEditingObservable
                .subscribe(onNext: {[weak self] password in
                    self?.setInsetSubject.onNext(Constants.NetworkInfo.edgeInsetWhenKeyboardAppear)
                }).disposed(by: disposeBag)
            
            myWifiViewModel.output.textFieldDidEndEditingObservable
                .subscribe(onNext: {[weak self] password in
                    self?.setInsetSubject.onNext(Constants.NetworkInfo.edgeInsetWhenKeyboardDisappear)
                }).disposed(by: disposeBag)
            
            myWifiViewModel.output.enableDisableTapObservable
                .subscribe(onNext: {[weak self] () in
                    guard let self = self else {return}
                    do {
                        let value = try self.myNetworkEnableDisableSubject.value()
                        self.myNetworkEnableDisableTapSubject.onNext(!value)
                    } catch {}
                }).disposed(by: disposeBag)
            
            let guestWifiViewModel = NetworkDetailCellViewModel(with: WiFiNetwork(name: guestNetworkName,
                                                                                  password: guestNetworkPassword,
                                                                                  isGuestNetwork: true,
                                                                                  isEnabled: isGuestNetworkEnabled,
                                                                                  nameState: guestNetwork.nameState,
                                                                                  passwordState: guestNetwork.passwordState))
            
            guestWifiViewModel.output.networkNameObservable
                .subscribe(onNext: { networkName in
                    self.guestNetworkNameSubject.onNext(networkName)
                }).disposed(by: disposeBag)
            
            guestWifiViewModel.output.networkPasswordObservable
                .subscribe(onNext: { password in
                    self.guestNetworkPasswordSubject.onNext(password)
                }).disposed(by: disposeBag)
            
            guestWifiViewModel.output.textFieldDidBeginEditingObservable
                .subscribe(onNext: {[weak self] password in
                    self?.setInsetSubject.onNext(Constants.NetworkInfo.edgeInsetWhenKeyboardAppear)
                }).disposed(by: disposeBag)
            
            guestWifiViewModel.output.textFieldDidEndEditingObservable
                .subscribe(onNext: {[weak self] password in
                    self?.setInsetSubject.onNext(Constants.NetworkInfo.edgeInsetWhenKeyboardDisappear)
                }).disposed(by: disposeBag)
            
            guestWifiViewModel.output.enableDisableTapObservable
                .subscribe(onNext: {[weak self] () in
                    guard let self = self else {return}
                    do {
                        let value = try self.guestNetworkEnableDisableSubject.value()
                        self.guestNetworkEnableDisableTapSubject.onNext(!value)
                    } catch {}
                }).disposed(by: disposeBag)
            
            return TableDataSource(
                header: nil,
                items: [
                    Item(identifier: NetworkDetailTableViewCell.identifier, viewModel: myWifiViewModel),
                    Item(identifier: NetworkDetailTableViewCell.identifier, viewModel: guestWifiViewModel)
                ]
            )
        } catch {}
        
        return TableDataSource.init(header: nil, items: [Item(identifier: "", viewModel: "")])
    }
}

//MARK: Validations
extension NetworkInfoViewModel {

    /// Validating network name and password fields
    ///- returns: A Boolean value indicates whether all entered fields are valid or not
    func validateFields() -> Bool {
        var isValidFields = false
        
        do {
            let myNetworkName = try myNetworkNameSubject.value()
            let myNetworkPassword = try myNetworkPasswordSubject.value()
            let guestNetworkName = try guestNetworkNameSubject.value()
            let guestNetworkPassword = try guestNetworkPasswordSubject.value()
            
            let passwordDescription = Constants.NetworkInfo.networkPasswordDescription
            myNetwork.nameState = (myNetworkName.count == 0) ? .error("") : .normal("")
            myNetwork.passwordState = (myNetworkPassword.count < Constants.NetworkInfo.passwordMinLength || myNetworkPassword.count > Constants.NetworkInfo.passwordMaxLength) ?
                .error(passwordDescription) : .normal(passwordDescription)
            guestNetwork.nameState = (guestNetworkName.count == 0) ? .error("") : .normal("")
            guestNetwork.passwordState = (guestNetworkPassword.count < Constants.NetworkInfo.passwordMinLength || guestNetworkPassword.count > Constants.NetworkInfo.passwordMaxLength) ?
                .error(passwordDescription) : .normal(passwordDescription)
            
            isValidFields = (myNetworkName.count != 0) && (guestNetworkName.count != 0)
                && ((myNetworkPassword.count >= Constants.NetworkInfo.passwordMinLength) && (myNetworkPassword.count <= Constants.NetworkInfo.passwordMaxLength))
                && ((guestNetworkPassword.count >= Constants.NetworkInfo.passwordMinLength) && (guestNetworkPassword.count <= Constants.NetworkInfo.passwordMaxLength))
        } catch {}
        self.setSections()
        
        return isValidFields
    }
    
    /// To show alert depending on change in name and password
    ///- returns: A Boolean value indicating whether to show alert or not
    func shouldShowSaveChangesAlert() -> Bool {
        var shouldShowAlert = false
        do {
            let myNetworkName = try myNetworkNameSubject.value()
            let myNetworkPassword = try myNetworkPasswordSubject.value()
            let guestNetworkName = try guestNetworkNameSubject.value()
            let guestNetworkPassword = try guestNetworkPasswordSubject.value()
            
            shouldShowAlert = (myNetworkName != myNetwork.name) || (myNetworkPassword != myNetwork.password)
                || (guestNetworkName != guestNetwork.name) || (guestNetworkPassword != guestNetwork.password)
        } catch {}
        
        return shouldShowAlert
    }
}
