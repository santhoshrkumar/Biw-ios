//
//  FAQQuestionsCell.swift
//  BiWF
//
//  Created by pooja.q.gupta on 16/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
import RxFeedback
/*
 FAQQuestionscell contains FAQ cells
 */
class FAQQuestionsCell: UITableViewCell {
    /// reuse identifier
    static let identifier = "FAQQuestionsCell"
    
    ///IBOutlet
    @IBOutlet weak var questionLabel: UILabel! {
        didSet {
            questionLabel.textColor = UIColor.BiWFColors.dark_grey
            questionLabel.font = .regular(ofSize: UIFont.font16)
        }
    }
    @IBOutlet weak var answerTextView: UITextView! {
        didSet {
            answerTextView.textColor = UIColor.BiWFColors.dark_grey
            answerTextView.font = .regular(ofSize: UIFont.font16)
            answerTextView.tintColor = UIColor.BiWFColors.purple
        }
    }
    @IBOutlet weak var constraintTextviewHeight: NSLayoutConstraint!
    @IBOutlet weak var expandCellButton: UIButton!
    
    private var disposeBag = DisposeBag()
    
    /// Holds FAQQuestionsCellViewModel with strong reference
    var viewModel: FAQQuestionsCellViewModel!
    
    ///this is called just before the cell is returned from the table view method
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

/// FAQQuestionsCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension FAQQuestionsCell: Bindable {
    
    /// Binding all the observers from viewmodel to get the events and values
    func bindViewModel() {
        viewModel.question
            .drive(questionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.answer
            .drive(answerTextView.rx.attributedText)
            .disposed(by: disposeBag)
        updateTextViewHeight()
        initialSetup()
        
        viewModel.cellShouldExpandObserver.subscribe(onNext: {[weak self] cellShouldExpand in
            guard let self = self else { return }
            let buttonImage = cellShouldExpand ?
            UIImage.init(named: Constants.FAQTopics.expandCellArrowImage) :
            UIImage.init(named: Constants.FAQTopics.collapseCellArrowImage)
            self.expandCellButton.setImage(buttonImage, for: .normal)
            self.updateTextViewHeight()
        }).disposed(by: disposeBag)
        
        expandCellButton.rx.tap.subscribe(onNext: {[weak self] cellShouldExpand in
            guard let self = self else { return }
            self.viewModel.expandButtonObserver.onNext(())
            AnalyticsEvents.trackButtonTapEvent(with: !self.viewModel.isExpanded ? AnalyticsConstants.EventButtonTitle.FAQDetailsListExpand : AnalyticsConstants.EventButtonTitle.FAQDetailsListCollapse)
        }).disposed(by: disposeBag)
    }
    
    /// Textview setup
    fileprivate func initialSetup() {
        answerTextView.sizeToFit()
        answerTextView.isScrollEnabled = false
        answerTextView.textContainerInset = UIEdgeInsets.zero
        answerTextView.textContainer.lineFragmentPadding = 0
    }

    /// Updating the height of textview depends on answer in the text view
    fileprivate func updateTextViewHeight() {
        constraintTextviewHeight.constant = answerTextView.text.isEmpty ? 0 : answerTextView.contentSize.height
    }
}
