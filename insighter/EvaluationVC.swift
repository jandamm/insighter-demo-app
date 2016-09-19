//
//  EvaluationVC.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit
import Firebase

class EvaluationVC: UIViewController {

	weak var delegate: EvaluationDelegate?

	@IBOutlet weak var scrollView: JDPagingScrollView!

	fileprivate var evalUserVC: EvaluationUserVC!
	fileprivate var evalCompVC: EvaluationCompanyVC!

	override func viewDidLoad() {
		super.viewDidLoad()

		setupScrollView()
	}

	// MARK: - Actions

	@IBAction func logout(_ sender: UIButton) {
		UserLoginService.shared.signOutUser(nil)

		self.delegate?.logout()
	}

	// MARK: - Private Methods

	fileprivate func setupScrollView() {
		evalUserVC = EvaluationUserVC()
		evalCompVC = EvaluationCompanyVC()

		addChildViewController(evalUserVC)
		scrollView.addSubview(evalUserVC.view)
		evalUserVC.didMove(toParentViewController: self)

		addChildViewController(evalCompVC)
		scrollView.addSubview(evalCompVC.view)
		evalCompVC.didMove(toParentViewController: self)
	}
}
