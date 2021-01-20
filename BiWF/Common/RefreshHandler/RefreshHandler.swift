//
//  RefreshHandler.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 16/07/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import DPProtocols
/*
 Handles network refresh
 */
class RefreshHandler: NSObject {

    let refresh = PublishSubject<Void>()
    let refreshControl = UIRefreshControl()

    init(view: UIScrollView) {
        super.init()
        view.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshControlDidRefresh(_: )), for: .valueChanged)
    }

    // MARK: - Action
    @objc func refreshControlDidRefresh(_ control: UIRefreshControl) {
        refresh.onNext(())
    }

    func end() {
        refreshControl.endRefreshing()
    }
}
