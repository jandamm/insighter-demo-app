//
//  EvaluationCompanyVC.swift
//  insighter
//
//  Created by Jan Dammshäuser on 14.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class EvaluationCompanyVC: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var averageView: UIStackView!

	// MARK: - Private Data

	// MARK: - Startup

	// MARK: - Internal Methods

	func addAverage(_ average: Average) {
		let bar = AverageVC()

		bar.setAverage(average)

		addChildViewController(bar)
		averageView.addArrangedSubview(bar.view)
		bar.didMove(toParentViewController: self)
	}
}
