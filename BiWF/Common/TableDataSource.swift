//
//  SupportOptionsTableDataSource.swift
//  BiWF
//
//  Created by pooja.q.gupta on 09/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import DPProtocols
/*
 TableDataSource holds Header,subHeader and items
 */
struct TableDataSource {
    var header: String?
    var subHeader: NSAttributedString?
    var items: [Item]
}

extension TableDataSource: SectionModelType {
    
    /// Initializes a new instance of TableDataSource and Item
    /// - Parameter original : TableDataSource
    /// items : array of items to table view
    init(original: TableDataSource, items: [Item]) {
        self = original
        self.items = items
        self.header = original.header
        self.subHeader = original.subHeader
    }
}

/// Items for the table
struct Item {
    var identifier: String
    var viewModel: Any
    var object: Any?
}
