//
//  CalendarCell.swift
//  BiWF
//
//  Created by Pooja Gupta on 03/07/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import JTAppleCalendar
/*
 CalendarCell of type JTACDayCell
 */
class CalendarCell: JTACDayCell {
    /// Identifier
    static let identifier = "CalendarCell"
    
    ///Outlets
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            dateLabel.font = .regular(ofSize: UIFont.font18)
        }
    }
    @IBOutlet weak var selectedView: UIView!{
        didSet {
            selectedView.cornerRadius = 18
            selectedView.backgroundColor = UIColor.BiWFColors.purple
        }
    }
}
