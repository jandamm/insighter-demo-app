//
//  RatingView.swift
//  insighter
//
//  Created by Jan Dammshäuser on 14.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class RatingVC: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var ratingLbl: JDLabel!
    @IBOutlet weak var explanationLeft: JDLabel!
    @IBOutlet weak var explanationRight: JDLabel!

    
    // MARK: - Startup

    convenience init() {
        self.init(nibName: "RatingVC", bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
