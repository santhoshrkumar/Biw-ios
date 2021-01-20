//
//  NotificationTableViewCell.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 27/03/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
/**
 A TableView cell representing the notifications cell
 */
class NotificationTableViewCell: UITableViewCell {

    /// reuse identifier
    static let identifier = "NotificationTableViewCell"

    /// Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var notificationImageView: UIImageView!
    @IBOutlet weak var cellBackgroundView: UIView!
    private let disposeBag = DisposeBag()

    /// Holds NotificationTableCellViewModel with strong reference
    var viewModel: NotificationTableCellViewModel!

    private func initialSetup() {

        /// Setting tableview selection background to clear color
        let selectionBackgroundView = UIView()
        selectionBackgroundView.backgroundColor = .clear
        UITableViewCell.appearance().selectedBackgroundView = selectionBackgroundView

        /// TODO: To be removed once image will be added
        notificationImageView.layer.masksToBounds = true
        notificationImageView.layer.cornerRadius = notificationImageView.frame.height/2
    }
}

/// NotificationTableViewCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension NotificationTableViewCell: Bindable {
    
    /// Binding all the observers from viewmodel to get the values
    func bindViewModel() {
        initialSetup()
        viewModel.name
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.description
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isUnread
            .map { isUnread -> UIColor in
                return isUnread ? UIColor.BiWFColors.med_grey : UIColor.BiWFColors.white
        }.drive(cellBackgroundView.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel.isUnread
            .map { isUnread -> Bool in
                return isUnread ? false : true
        }.drive(notificationImageView.rx.isHidden)
            .disposed(by: disposeBag)
        
        /// Setting text color of labels as per details available
        nameLabel.textColor = notificationImageView.isHidden ? UIColor.BiWFColors.med_grey : UIColor.BiWFColors.white
        descriptionLabel.textColor = notificationImageView.isHidden ? UIColor.BiWFColors.med_grey : UIColor.BiWFColors.white
    }
}
