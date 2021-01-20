
//
//  PickerViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 23/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

/*
   PickerViewModel handles to custom list.
**/
class PickerViewModel {
    ///DataSource list for pickerview
    var items = BehaviorSubject(value: [String]())
    ///Handles selection on picker list
    let itemSelectedSubject = PublishSubject<String>()
    
    /// Initializes a new instance of PickerViewModel
    /// - Parameter
    ///     - items : String array is data source for pickerview for showing list
    init(with items: [String]) {
        self.items.onNext(items)
    }
}
