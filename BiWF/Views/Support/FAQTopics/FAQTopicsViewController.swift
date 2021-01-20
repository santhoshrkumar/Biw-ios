//
//  FAQTopicsViewController.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 16/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
import RxDataSources
/*
 FAQTopicsViewController for the user to view FAQ's
 */
class FAQTopicsViewController: UIViewController, Storyboardable {
    
    ///Outlets
    @IBOutlet weak var tableView: UITableView!
    
    /// Bar buttons
    var doneButton: UIBarButtonItem!
    var backButton: UIBarButtonItem!
    
    /// Holds the FAQTopicsViewModel with strong reference
    var viewModel: FAQTopicsViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        AnalyticsEvents.trackScreenVisitEvent(with: AnalyticsConstants.EventScreenName.FAQ)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialSetup()
    }

    /// Binding all the tableview value
    private func initialSetup() {
        tableView.delegate = nil
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constants.FAQTopics.cellEstimatedHeight
        tableView.separatorColor = UIColor.BiWFColors.light_grey
        tableView.tableFooterView = UIView()
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        registerNib()
    }
    
    /// Navigationbar  and Barbutton setup
    private func setNavigationBar() {
        self.title = viewModel.titleText
        backButton = UIBarButtonItem.init(image: UIImage.init(named: Constants.Common.backButtonImageName),
                                          style: .plain,
                                          target: nil,
                                          action: nil)
        backButton.defaultSetup()
        self.navigationItem.leftBarButtonItem = backButton
        doneButton = UIBarButtonItem.init(title: Constants.Common.done,
                                          style: .plain,
                                          target: nil,
                                          action: nil)
        doneButton.defaultSetup()
        self.navigationItem.rightBarButtonItem = doneButton
    }

    /// Registers the xib files into tableview
    private func registerNib() {
        tableView.register(UINib(nibName: FAQQuestionsCell.identifier,
                                 bundle: nil),
                           forCellReuseIdentifier: FAQQuestionsCell.identifier)
        tableView.register(UINib(nibName: TitleHeaderview.identifier,
                                 bundle: nil),
                           forHeaderFooterViewReuseIdentifier: TitleHeaderview.identifier)
        tableView.register(UINib(nibName: ContactUsTableViewCell.identifier,
                                 bundle: nil),
                           forCellReuseIdentifier: ContactUsTableViewCell.identifier)
    }
}

/// FAQTopicsViewController extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension FAQTopicsViewController: Bindable {
    func bindViewModel() {
        bindInputs()
    }
    
    /// Binding all the input observers from viewmodel to get the events
    func bindInputs() {
        
        /// Tableview item selected binding with contact us
        tableView.rx.itemSelected
            .subscribe(viewModel.input.cellSelectionObserver)
            .disposed(by: disposeBag)
        
        self.backButton.rx.tap
            .subscribe(viewModel.input.backObserver)
            .disposed(by: disposeBag)
        
        self.doneButton.rx.tap
             .subscribe(onNext: {[weak self] in
                AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.FAQDetailsDone)
                self?.viewModel.input.doneObserver.onNext(())
            })
            .disposed(by: disposeBag)
        
        viewModel.reloadDataSubject.subscribe(onNext: {_ in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
}
