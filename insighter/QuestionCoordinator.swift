//
//  JDQuestionCoordinator.swift
//  insighter
//
//  Created by Jan Dammshäuser on 30.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import JDCoordinator

protocol QuestionDelegate: JDCoordinatorDelegate {
	func nextQuestion(withRatingAnswer answer: RatingAnswer)
}

class QuestionCoordinator: JDCoordinator, QuestionDelegate {

	weak var delegate: QuestionCoordinatorDelegate?

	private var questions: [RatingQuestion]!

	private var index = 0

	private var lastQuestion: Bool {
		return questions.count - 1 == index
	}

	private weak var activeVC: QuestionVC?

	// MARK: - Coordinator

	override func start() {
		questions = ConstantService.shared.ratingQuestions

		guard questions.count > 0 else {
			NSLog("[JD] No questions available")
			return questionsAsked()
		}

		showQuestionVC()
	}

	func nextQuestion(withRatingAnswer answer: RatingAnswer) {
		guard DataService.shared.addRating(answer, lastQuestion: lastQuestion) else {
			return unknownError()
		}

		if lastQuestion {
			NotificationService.shared.setupNotifications()

			questionsAsked()
		} else {
			index += 1
			showQuestionVC()
		}
	}

	// MARK: - Private Methods

	private func unknownError() {
		let HUD = JDPopup(titleKey: .ERROR_UNKNOWN_TITLE, subTitleKey: .ERROR_UNKNOWN_EXPLANATION, imageStyle: .error)
		HUD.show(in: activeVC?.view)
	}

	private func questionsAsked() {
		delegate?.questionsAsked(self)
	}

	// MARK: - Show Methods

	fileprivate func showQuestionVC() {
		let question = questions[index]
		let vc = QuestionVC(withQuestion: question, andQuestionNumber: index + 1)

		vc.delegate = self

		activeVC = vc

		setViewControllers(vc, animated: true)
	}
}
