//
//  EvaluationCompanyVC.swift
//  insighter
//
//  Created by Jan Dammshäuser on 14.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class EvaluationCompanyVC: UIViewController {

	@IBOutlet weak var averageSView: UIStackView!

	// MARK: - Startup

	override func viewDidLoad() {
		super.viewDidLoad()

		let bar = AverageVC()

		let comp = CompanyAverage(key: "2016-16", users: 12, sum: 24)
		let user = UserAverage(key: "2016-16", answers: ["a": 7])
		let average = Average(key: "2016-16", company: comp, user: user)

		bar.setAverage(average)

		addChildViewController(bar)
		averageSView.addArrangedSubview(bar.view)
		bar.didMove(toParentViewController: self)
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
}
