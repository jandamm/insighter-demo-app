//
//  AverageView.swift
//  insighter
//
//  Created by Jan Dammshäuser on 18.09.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class AverageVC: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var userScoreLbl: JDLabel!
	@IBOutlet weak var compScoreLbl: JDLabel!
	@IBOutlet weak var weekLbl: JDLabel!
	@IBOutlet weak var ratingBar: AverageBar!

	// MARK: - Private Data

	private var average: Average!

	// MARK: - Startup

	override func viewDidLoad() {
		super.viewDidLoad()

		setupDataFields()

		ratingBar.layout(andSetAverage: average)
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		ratingBar.layout()
	}

	// MARK: - Internal Methods

	func setAverage(_ average: Average) {
		self.average = average
	}

	// MARK: - Private Methods

	private func setupDataFields() {
		userScoreLbl.text = average.user?.average ?? "--"
		compScoreLbl.text = average.company?.average ?? "--"
		weekLbl.text = average.week
	}
}
