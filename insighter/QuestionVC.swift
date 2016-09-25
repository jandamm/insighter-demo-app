//
//  QuestionVC.swift
//  insighter
//
//  Created by Jan Dammshäuser on 14.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class QuestionVC: UIViewController, Flashable {

	weak var delegate: QuestionDelegate?

	fileprivate var questions = [RatingQuestion]()

	fileprivate var questionsActiveIndex = 0 {
		didSet {
			let maxIndex = questions.count - 1

			questionsActiveIndex = questionsActiveIndex.makeBetween(0, and: maxIndex)

			questionSet()
		}
	}

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

	init(withQuestions questions: [RatingQuestion]) {
		super.init(nibName: "QuestionVC", bundle: nil)

		self.questions = questions
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		setupRatingStackView()

		state = .rating

		questionsActiveIndex = 0
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

	fileprivate func questionSet() {
		var text = RemoteConfig.shared.getString(forKey: .Que_Number_Of_Number)

		text = text.replacingOccurrences(of: "[first]", with: "\(questionsActiveIndex + 1)")
		text = text.replacingOccurrences(of: "[second]", with: "\(questions.count)")

		questionNumberLbl.text = text
		questionLbl.text = questions[questionsActiveIndex].question
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

	fileprivate func stateApply() {
		switch state {
		case .rating:
			upperBtn.resetRemoteConfigText()
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

	fileprivate func unknownError() {
		let HUD = JDPopup(titleKey: .ERROR_UNKNOWN_TITLE, subTitleKey: .ERROR_UNKNOWN_EXPLANATION, imageStyle: .error)
		HUD.show(in: view)
	}

	fileprivate func dismissKeyboard() {
		UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}

	fileprivate func deleteComment() {
		ratingCommentTxtView.text = nil
	}

	fileprivate func saveAnswerAndProceed() {
		let UID = questions[questionsActiveIndex].uid
		let rating = ratingSliderVC.ratingSlider.value.integer
		let lastQuestion = questionsActiveIndex == questions.count - 1
		var comment: String? = nil

		if let text = ratingCommentTxtView.text, text.trimmed != "" {
			comment = text
		}

		let ratingAnswer = RatingAnswer(UID: UID, rating: rating, comment: comment)

		guard DataService.shared.addRating(ratingAnswer, lastQuestion: lastQuestion) else {
			return unknownError()
		}

		let flashSpeed = 0.3

		if lastQuestion {
			NotificationService.shared.setupNotifications()

			flash(.in, speed: flashSpeed, completion: { _ in
				self.dismissVC()
			})
		} else {
			flash(.in, speed: flashSpeed, completion: { _ in
				self.resetView(andNextQuestion: true)
				self.flash(.out, speed: flashSpeed, completion: nil)
			})
		}
	}

	fileprivate func dismissVC() {
		delegate?.nextQuestion()
	}

	fileprivate func resetView(andNextQuestion nextQuestion: Bool = false) {

		deleteComment()

		ratingSliderVC.ratingSlider.reset()

		if state != .rating {
			state = .rating
		}

		if nextQuestion {
			questionsActiveIndex += 1
		}
	}
}
