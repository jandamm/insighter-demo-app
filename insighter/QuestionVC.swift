//
//  QuestionVC.swift
//  insighter
//
//  Created by Jan Dammshäuser on 14.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class QuestionVC: UIViewController {

	weak var delegate: QuestionDelegate?

	private var question: RatingQuestion!
	private var questionNumber: Int!
	private let questionCount = RemoteConfig.shared.getInt(forKey: .Questions_Per_Week) + 1

	fileprivate var state: State = .rating {
		didSet {
			stateApply()
		}
	}

	fileprivate enum State {
		case rating, comment
	}

	// MARK: - Outlets

	@IBOutlet weak var questionNumberLbl: JDLabel!
	@IBOutlet weak var questionLbl: JDLabel!

	@IBOutlet weak var ratingView: UIStackView!
	fileprivate var ratingSliderVC: RatingVC!
	fileprivate var ratingCommentTxtView: JDTextView!

	@IBOutlet weak var upperBtn: JDButton!
	@IBOutlet weak var lowerBtn: JDButton!

	// MARK: - Startup

	init(withQuestion question: RatingQuestion, andQuestionNumber num: Int) {
		super.init(nibName: "QuestionVC", bundle: nil)

		self.question = question
		self.questionNumber = num
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		setupRatingStackView()

		state = .rating

		questionSet()
	}

	// MARK: - Actions

	@IBAction func upperBtnPressed(_ sender: UIButton) {
		switch state {
		case .rating:
			state = .comment
		case .comment:
			dismissKeyboard()

			state = .rating
		}
	}

	@IBAction func lowerBtnPressed(_ sender: UIButton) {
		switch state {
		case .rating:
			saveAnswerAndProceed()
		case .comment:
			deleteComment()
			dismissKeyboard()

			state = .rating
		}
	}

	// MARK: - Appearance

	fileprivate func setupRatingStackView() {
		ratingSliderVC = RatingVC()
		ratingCommentTxtView = JDTextView()

		addChildViewController(ratingSliderVC)

		ratingView.addArrangedSubview(ratingSliderVC.view)
		ratingView.addArrangedSubview(ratingCommentTxtView)

		ratingSliderVC.didMove(toParentViewController: self)

		ratingStackViewShowSubview()
	}

	fileprivate func ratingStackViewShowSubview() {
		let stateRating = state == .rating

		ratingSliderVC.view.isHidden = !stateRating
		ratingSliderVC.view.alpha = !stateRating ? 0 : 1
		ratingCommentTxtView.isHidden = stateRating
		ratingCommentTxtView.alpha = stateRating ? 0 : 1
	}

	private func questionSet() {
		let questionNumber = self.questionNumber ?? 1
		let replace = ["[first]": "\(questionNumber)", "[second]": "\(questionCount)"]

		questionNumberLbl.replaceStrings = replace
		questionLbl.text = question.question
	}

	// MARK: - State

	func stateButtonApply() {
		switch state {
		case .rating:
			lowerBtn.isEnabled = ratingSliderVC.ratingSlider.value.slided
		case .comment:
			lowerBtn.isEnabled = true
		}
	}

	private func stateApply() {
		switch state {
		case .rating:
			if let text = ratingCommentTxtView.text, text != "" {
				upperBtn.remoteConfigKey = RemoteStringKey.Que_Rating_Commented_Btn.rawValue
			} else {
				upperBtn.resetRemoteConfigText()
			}
			lowerBtn.resetRemoteConfigText()

			upperBtn.fontStyle = TextStyle.Button.rawValue
			lowerBtn.fontStyle = TextStyle.ButtonPrimary.rawValue
		case .comment:
			upperBtn.remoteConfigKey = RemoteStringKey.Que_Comment_Save_Btn.rawValue
			lowerBtn.remoteConfigKey = RemoteStringKey.Que_Comment_Discard_Btn.rawValue

			upperBtn.fontStyle = TextStyle.ButtonPrimary.rawValue
			lowerBtn.fontStyle = TextStyle.ButtonError.rawValue
		}

		stateButtonApply()

		UIView.animate(withDuration: 0.3, animations: { [weak self] in
			self?.ratingStackViewShowSubview()
		})
	}

	// MARK: - Private Methods

	fileprivate func dismissKeyboard() {
		UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}

	fileprivate func deleteComment() {
		ratingCommentTxtView.text = nil
	}

	fileprivate func saveAnswerAndProceed() {
		let UID = question.uid
		let rating = ratingSliderVC.ratingSlider.value.integer
		var comment: String? = nil

		if let text = ratingCommentTxtView.text, text.trimmed != "" {
			comment = text
		}

		let ratingAnswer = RatingAnswer(UID: UID, rating: rating, comment: comment)

		nextQuestion(withRatingAnswer: ratingAnswer)
	}

	fileprivate func nextQuestion(withRatingAnswer answer: RatingAnswer) {
		delegate?.nextQuestion(withRatingAnswer: answer)
	}
}
