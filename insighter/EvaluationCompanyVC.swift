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

		averageSView.addArrangedSubview(bar.view)
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		print(averageSView.arrangedSubviews.count)
		print(averageSView.arrangedSubviews.first?.frame)
		print(averageSView.bounds)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	/*
	 // MARK: - Navigation

	 // In a storyboard-based application, you will often want to do a little preparation before navigation
	 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	 // Get the new view controller using segue.destinationViewController.
	 // Pass the selected object to the new view controller.
	 }
	*/
}
