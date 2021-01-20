//
//  Rating.swift
//  BiWF
//
//  Created by pooja.q.gupta on 23/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import DPProtocols
/*
   Rating custom view to show and calculating user rating.
**/
class Rating: UIView {
    
    var viewModel: RatingViewModel!
    private let disposeBag = DisposeBag()
    
    //MARK:- init methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    /// Initializes and returns a newly allocated Rating view object.
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    func initialSetup() {
        loadFromNib()
        self.layoutIfNeeded()
    }
    
    /// Change or Update the cosmos view rating
    /// - Parameter
    ///     - rating : User rating Int value
    func updateRating(to rating: Int) {
        guard rating <= Constants.Rating.maxRating else {
            return
        }
        
        var tag = rating
        
        //Set filled star
        while tag >= 1 {
            if let button = self.viewWithTag(tag) as? UIButton {
                button.setImage(UIImage.init(named: Constants.Rating.filledStarImageName) , for: .normal)
            }
            tag -= 1
        }
        
        //Set empty star
        tag = rating + 1
        while tag <= Constants.Rating.maxRating {
            if let button = self.viewWithTag(tag) as? UIButton {
                button.setImage(UIImage.init(named: Constants.Rating.emptyStarImageName) , for: .normal)
            }
            tag += 1
        }
        
    }
}

/// Rating Extension confirm Bindable protocol.
/// This is provide a standard interface to all it's internal elements to be bound to a view model
extension Rating: Bindable {
    func bindViewModel() {
        
        viewModel.setRatingSubject.bind {[weak self] (rating) in
            guard let self = self else {return}
            self.updateRating(to: rating)
        }.disposed(by: disposeBag)
        
        for tag in 1...Constants.Rating.maxRating {
            if let button = self.viewWithTag(tag) as? UIButton{
                button.rx.tap.bind(onNext: {[weak self] _ in
                     guard let self = self else {return}
                    self.viewModel.setRatingSubject.onNext(tag)
                    self.viewModel.updateRatingSubject.onNext(tag)
                }).disposed(by: disposeBag)
            }
        }
    }
}
