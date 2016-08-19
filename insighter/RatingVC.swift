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
    @IBOutlet weak var explanationLeftLbl: JDLabel!
    @IBOutlet weak var explanationRightLbl: JDLabel!

    
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
        animateExplanationLabels(hidden: false)
    }
    
    func ratingSliderDidEnd() {
        animateExplanationLabels(hidden: true)
    }
    
    func ratingSliderDidChange() {
        let rating = ratingSlider.value
        
        ratingLbl.text = rating.string
        ratingLbl.textColor = rating.color
        
        if let questionVC = parentViewController as? QuestionVC {
            questionVC.stateButtonApply()
        }
    }
    
    
    // MARK: - Animation
    
    private func animateExplanationLabels(hidden hidden: Bool) {
        let alpha: CGFloat = hidden ? 0 : 1
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseOut, animations: {
            self.explanationLeftLbl.alpha = alpha
            self.explanationRightLbl.alpha = alpha
            }, completion: nil)
    }
}
