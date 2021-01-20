//
//  PickerView.swift
//  BiWF
//
//  Created by pooja.q.gupta on 23/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
/*
   PickerView to show custom list.
**/
class PickerView: UIPickerView {
    
    private let disposeBag = DisposeBag()
    var viewModel: PickerViewModel!
    
    //MARK:- init methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}

/// PickerView Extension confirm Bindable protocol.
/// This is provide a standard interface to all it's internal elements to be bound to a view model
extension PickerView: Bindable {
    func bindViewModel() {
        ///Title
        viewModel.items.asObserver()
        .bind(to: self.rx.itemTitles) { (row, element) in
            return element
        }.disposed(by: disposeBag)
        
        /// Selected item
        self.rx.itemSelected
            .subscribe(onNext: { ( selected) in
                do {
                    let items = try self.viewModel.items.value()
                    self.viewModel.itemSelectedSubject.onNext(items[selected.row])
                }
                catch {}
            })
        .disposed(by: disposeBag)
    }
}
