//
//  CalendarView.swift
//  BiWF
//
//  Created by pooja.q.gupta on 01/07/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import JTAppleCalendar
import RxSwift
import RxCocoa
import DPProtocols
/*
CalendarView to show calendar information
*/
class CalendarView: UIView {
    
    /// Outlets
    @IBOutlet weak var monthLabel: UILabel! {
        didSet {
            monthLabel.font = .bold(ofSize: UIFont.font18)
            monthLabel.textColor = UIColor.BiWFColors.purple
        }
    }
    @IBOutlet weak var calendarView: JTACMonthView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var previousButton: UIButton! {
        didSet {
            previousButton.setImage(UIImage.init(named: Constants.CalendarView.back), for: .normal)
            previousButton.isEnabled = false
        }
    }
    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.setImage(UIImage.init(named: Constants.CalendarView.next), for: .normal)
        }
    }
    @IBOutlet weak var sundayLabel: UILabel! {
        didSet {
            sundayLabel.font = .bold(ofSize: UIFont.font18)
            sundayLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    @IBOutlet weak var mondayLabel: UILabel! {
        didSet {
            mondayLabel.font = .bold(ofSize: UIFont.font18)
            mondayLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    @IBOutlet weak var tuesdayLabel: UILabel! {
        didSet {
            tuesdayLabel.font = .bold(ofSize: UIFont.font18)
            tuesdayLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    @IBOutlet weak var wednesdayLabel: UILabel! {
        didSet {
            wednesdayLabel.font = .bold(ofSize: UIFont.font18)
            wednesdayLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    @IBOutlet weak var thursdayLabel: UILabel! {
        didSet {
            thursdayLabel.font = .bold(ofSize: UIFont.font18)
            thursdayLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    @IBOutlet weak var fridayLabel: UILabel! {
        didSet {
            fridayLabel.font = .bold(ofSize: UIFont.font18)
            fridayLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    @IBOutlet weak var saturdayLabel: UILabel! {
        didSet {
            saturdayLabel.font = .bold(ofSize: UIFont.font18)
            saturdayLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    
    /// Constants/Variables
    var currentIndex = 0
    var availableDates = [String]()
    
    /// Holds CalendarViewModel with strong reference
    var viewModel: CalendarViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: - Intializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    private func initialSetup() {
        loadFromNib()
        registerCells()
        loadCalendarView()
    }
    
    private func registerCells() {
        calendarView.register(UINib.init(nibName: String(describing: CalendarCell.self), bundle: nil), forCellWithReuseIdentifier: CalendarCell.identifier)
    }
    
    func loadCalendarView() {
        self.calendarView.calendarDelegate = self
        self.calendarView.calendarDataSource = self
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        
        //Set month label
        self.monthLabel.text = Date().toString(withFormat: Constants.DateFormat.MMMMyyyy)
    }
    
    func configureCell(view: JTACDayCell?, cellState: CellState) {
        guard let cell = view as? CalendarCell  else { return }
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
    }
    
    //MARK:- IBActions
    @IBAction func nextAction(_ sender: Any) {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.calendarView.scrollToSegment(.next)
            self.currentIndex += 1
            self.handlePreviousNextButton()
        }
    }
    
    @IBAction func previousAction(_ sender: Any) {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.calendarView.scrollToSegment(.previous)
            self.currentIndex -= 1
            self.handlePreviousNextButton()
        }
    }
    
    //MARK:- UI updation
    func handleCellTextColor(cell: CalendarCell, cellState: CellState) {
        if shouldSelectable(cell: cell, cellState: cellState) {
            cell.dateLabel.textColor = UIColor.BiWFColors.purple
        } else {
            cell.dateLabel.textColor = UIColor.BiWFColors.med_grey.withAlphaComponent(0.5)
        }
    }
    
    func handleCellSelected(cell: CalendarCell, cellState: CellState) {
        if cell.isSelected {
            cell.selectedView.isHidden = false
            cell.dateLabel.textColor = UIColor.BiWFColors.white
            cell.dateLabel.font = .bold(ofSize: UIFont.font18)
        } else {
            cell.selectedView.isHidden = true
            cell.dateLabel.font = .regular(ofSize: UIFont.font18)
        }
    }
    
    func shouldSelectable(cell: CalendarCell, cellState: CellState) -> Bool {
        return (cellState.dateBelongsTo == .thisMonth && (cellState.date > Date() || cellState.date.isTodayDate()) && availableDates.contains(cellState.date.toString(withFormat: Constants.DateFormat.YYYY_M_d)))
    }
    
    func updateMonth(from visibleDates: DateSegmentInfo) {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            guard let date = visibleDates.monthDates.first?.date else { return }
            self.monthLabel.text = date.toString(withFormat: Constants.DateFormat.MMMMyyyy)
        }
    }
    
    func handlePreviousNextButton() {
        nextButton.isEnabled = (currentIndex < (Constants.CalendarView.maxMonthToView - 1))
        previousButton.isEnabled = (currentIndex > 0)
    }
}

extension CalendarView: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.DateFormat.YYYY_MM_dd
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.timeZone = Calendar.current.timeZone
        
        self.calendarView.cellSize = (UIScreen.main.bounds.width - Constants.CalendarView.padding) / CGFloat(Constants.CalendarView.numberOfDaysInWeek)
        
        let startDate = Date()
        let endDate = dateFormatter.date(from: "2030-07-30")!
        let parameter = ConfigurationParameters(startDate: startDate,
                                                endDate: endDate,
                                                numberOfRows: Constants.CalendarView.numberOfRows,
                                                calendar: Calendar.current,
                                                generateInDates: .forAllMonths,
                                                generateOutDates: .tillEndOfGrid,
                                                firstDayOfWeek: .sunday,
                                                hasStrictBoundaries: true)
        return parameter
    }
}

extension CalendarView: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: CalendarCell.identifier, for: indexPath) as! CalendarCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        guard let calendarCell = cell as? CalendarCell else {return true}
        return (shouldSelectable(cell: calendarCell, cellState: cellState))
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        viewModel.input.selectedDateObserver.onNext(date)
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.updateMonth(from: visibleDates)
    }
}

/// CalendarView extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension CalendarView: Bindable {
    
    /// Binding all the input and output observers from viewmodel to get the events and values
    func bindViewModel() {
        viewModel.output.availableDatesDriver
            .drive(onNext: { [weak self] availableDates in
                self?.availableDates = availableDates
                self?.calendarView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}
