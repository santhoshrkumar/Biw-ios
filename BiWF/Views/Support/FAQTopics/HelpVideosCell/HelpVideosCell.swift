//
//  HelpVideosCell.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 19/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

///TODO: To be updated as per requirement
//import UIKit
//import RxCocoa
//import RxSwift
//import DPProtocols
//
//class HelpVideosCell: UITableViewCell {
//
//    /// Reuse identifier
//    static let identifier = "HelpVideosCell"
//        
//    @IBOutlet weak var videoView: UIView! {
//        didSet {
//            videoView.backgroundColor = UIColor.BiWFColors.light_greyBackground
//        }
//    }
//    @IBOutlet weak var detailLabel: UILabel! {
//        didSet {
//            detailLabel.textColor = .black
//            detailLabel.font = .regular(ofSize: UIFont.font12)
//        }
//    }
//    @IBOutlet weak var durationLabel: UILabel! {
//        didSet {
//             durationLabel.textColor = UIColor.BiWFColors.light_greyBackground
//             durationLabel.font = .regular(ofSize: UIFont.font12)
//        }
//    }
//
//    private let disposeBag = DisposeBag()
//    var viewModel: HelpVideosCellViewModel!
//}
//
//extension HelpVideosCell: Bindable {
//    
//    func bindViewModel() {
//        viewModel.name
//            .drive(detailLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        viewModel.duration
//            .drive(durationLabel.rx.text)
//            .disposed(by: disposeBag)
//    }
//}
//
