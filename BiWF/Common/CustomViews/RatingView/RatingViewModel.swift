//
//  RatingViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 24/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa
/*
   RatingViewModel handles to user ratings.
**/
class RatingViewModel {
    
    ///Subject to setting user rating
    let setRatingSubject = PublishSubject<Int>()
    
    ///Subject to update user rating view
    let updateRatingSubject = PublishSubject<Int>()
    
    /// Initializes a new instance of RatingViewModel
    /// - Parameter
    ///     - items : user rating
    init(with rating: Int) {
        setRatingSubject.onNext(rating)
    }
}

