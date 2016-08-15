//
//  RatingView.swift
//  insighter
//
//  Created by Jan Dammshäuser on 14.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class RatingVC: UIViewController, RatingSliderDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var ratingLbl: JDLabel!
    @IBOutlet weak var ratingSlider: RatingSlider!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ratingSlider.delegate = self
    }
    
    
    // MARK: - RatingSliderDelegate
    
    func ratingSliderDidStart() {
        animateExplanation(false)
    }
    
    func ratingSliderDidEnd() {
        animateExplanation(true)
    }
    
    func ratingSliderDidChange() {
        let rating = ratingSlider.rating
        ratingLbl.text = rating.ratingString
        ratingLbl.textColor = rating.color
    }
    
    
    // MARK: - Animation
    
    private func animateExplanation(hidden: Bool) {
        let alpha: CGFloat = hidden ? 0 : 1
        UIView.animateWithDuration(0.5) {
            self.explanationLeft.hidden = hidden
            self.explanationLeft.alpha = alpha
            self.explanationRight.hidden = hidden
            self.explanationLeft.alpha = alpha
        }
    }
}
