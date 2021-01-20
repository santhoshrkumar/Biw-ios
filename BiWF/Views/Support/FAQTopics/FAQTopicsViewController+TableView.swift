//
//  FAQTopicsViewController+TableView.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 16/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import UIKit
import RxDataSources
/*
  FAQTopicsViewController confirming to UITableViewDelegate and UITableViewDataSource
 */
extension FAQTopicsViewController: UITableViewDelegate, UITableViewDataSource {
    
    ///Returns the number of rows for the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = FAQTopicsViewModel.Section.init(rawValue: section)
        switch section {
        case .frequentlyAskedQuestions:
            return viewModel.faqTopicData.count
        default:
            return FAQTopicsViewModel.Section.contactUs.rawValue + 1
        }
    }
    
    ///Provides a cell object for each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < viewModel.faqTopicData.count && indexPath.section == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: FAQQuestionsCell.identifier,
                                                     for: indexPath) as! FAQQuestionsCell
            cell.setViewModel(to: FAQQuestionsCellViewModel(withContent: viewModel.faqTopicData[indexPath.row]))
            cell.selectionStyle = .none
            if cell.viewModel.loadingInitially {
                self.binCellInputs(forCell: cell,
                                   atIndexPath: indexPath)
                cell.viewModel.loadingInitially = false
            }
            return cell
        } else {
            let title = indexPath.row == 0 ? Constants.Support.liveChat : Constants.FAQTopics.scheduledCall
            let description = indexPath.row == 0 ? viewModel.contactUsData.liveChatTimings : viewModel.contactUsData.scheduleCallbackTimings
            var cell = tableView.dequeueReusableCell(withIdentifier: ContactUsTableViewCell.identifier,
                                                     for: indexPath) as! ContactUsTableViewCell
            cell.selectionStyle = .none
            cell.setViewModel(to: ContactUsCellViewModel(with: title,
                                                         description: description))
            return cell
        }
    }
    
    /// Returns a number of sections in a table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return FAQTopicsViewModel.Section.contactUs.rawValue + 1
    }
    
    /// Used to give the custom height for the view inside the table which returns a UIView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard var headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: TitleHeaderview.identifier)
            as? TitleHeaderview
            else { return UITableViewHeaderFooterView() }
        let hideTopBottomSeperator = (false, false)
        let title = section == 0 ? Constants.Support.faqTopics : Constants.FAQTopics.cantFindAnswer
        let viewModel = TitleHeaderViewModel(title: title,
                                             hideTopSeperator: hideTopBottomSeperator.0,
                                             hideBottomSeperator: hideTopBottomSeperator.1)
        headerView.setViewModel(to: viewModel)
        return headerView
    }

    /// Used to give custom height for header section in a tableview which returns a float
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let section = FAQTopicsViewModel.Section.init(rawValue: section)
        switch section {
        case .frequentlyAskedQuestions:
            return Constants.FAQTopics.faqHeaderViewCellHeight
        default:
            return Constants.FAQTopics.cantFindAnswerHeaderCellHeight
        }
    }
    
    /// Binding all the cells to expand/collapse
    /// - Parameter FAQQuestionsCell : UITableview cell that needs to expand/collaps with indexpath
    private func binCellInputs(forCell cell: FAQQuestionsCell, atIndexPath: IndexPath) {
        cell.viewModel.expandButtonObserver
            .subscribe(onNext: {
                self.viewModel.updateFAQSection(forIndexpath: atIndexPath,
                                                isExpanded: cell.viewModel.isExpanded)
            }).disposed(by: disposeBag)
    }
}
