//
//  JDQuestionCoordinator.swift
//  insighter
//
//  Created by Jan Dammshäuser on 30.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import JDCoordinator

protocol QuestionDelegate: JDCoordinatorDelegate {
	func nextQuestion()
}

class JDQuestionCoordinator: JDCoordinator, QuestionDelegate {

	weak var delegate: JDQuestionCoordinatorDelegate?

	var questions = [RatingQuestion]()

	// MARK: - Coordinator

	override func start() {
		if questions.count > 0 {
			showQuestionVC()
		} else {
			NSLog("Empty Questions")
			questionsAsked()
		}
	}

	func nextQuestion() {
		questionsAsked()
	}

	// MARK: - Private Methods

	private func questionsAsked() {
		delegate?.questionsAsked(self)
	}

	// MARK: - Show Methods

	private func showQuestionVC() {

		// TODO: - Implement Checking for Question

		let vc = QuestionVC(withQuestions: questions)

		vc.delegate = self

		pushViewController(vc, animated: true)
	}
}
