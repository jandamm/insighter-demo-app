//
//  QuestionVC.swift
//  insighter
//
//  Created by Jan Dammshäuser on 14.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class QuestionVC: UIViewController, Flashable {
    
    private var questions = [RatingQuestion]()
    
    private var questionsActiveIndex = 0 {
        didSet {
            let maxIndex =  questions.count - 1
            
            questionsActiveIndex = questionsActiveIndex.makeBetween(0, and: maxIndex)
            
            questionSet()
        }
    }
    
    private var state: State = .Rating {
        didSet {
            stateApply()
        }
    }
    
    private enum State {
        case Rating, Comment
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var questionNumberLbl: JDLabel!
    @IBOutlet weak var questionLbl: JDLabel!
    
    @IBOutlet weak var ratingStackView: UIStackView!
    private var ratingSliderVC: RatingVC!
    private var ratingCommentTxtView: JDTextView!
    
    @IBOutlet weak var upperBtn: JDButton!
    @IBOutlet weak var lowerBtn: JDButton!
    
    
    // MARK: - Startup
    
    init(withQuestions questions: [RatingQuestion]) {
        super.init(nibName: "QuestionVC", bundle: nil)
        
        self.questions = questions
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRatingStackView()
        
        state = .Rating
        
        questionsActiveIndex = 0
    }
    
    
    // MARK: - Actions
    
    @IBAction func upperBtnPressed(sender: UIButton) {
        switch state {
        case .Rating:
            state = .Comment
        case .Comment:
            dismissKeyboard()
            
            state = .Rating
        }
    }
    
    @IBAction func lowerBtnPressed(sender: UIButton) {
        switch state {
        case .Rating:
            saveAnswerAndProceed()
        case .Comment:
            deleteComment()
            dismissKeyboard()
            
            state = .Rating
        }
    }
    
    
    // MARK: - Appearance
    
    private func setupRatingStackView() {
        ratingSliderVC = RatingVC()
        ratingCommentTxtView = JDTextView()
        
        addChildViewController(ratingSliderVC)
        
        ratingStackView.addArrangedSubview(ratingSliderVC.view)
        ratingStackView.addArrangedSubview(ratingCommentTxtView)
        
        ratingSliderVC.didMoveToParentViewController(self)
        
        ratingStackViewShowSubview()
    }
    
    private func ratingStackViewShowSubview() {
        let stateRating = state == .Rating
        
        ratingSliderVC.view.hidden = !stateRating
        ratingSliderVC.view.alpha = !stateRating ? 0 : 1
        ratingCommentTxtView.hidden = stateRating
        ratingCommentTxtView.alpha = stateRating ? 0 : 1
    }
    
    private func questionSet() {
        var text = RemoteConfig.sharedInstance.getString(forKey: .Que_Number_Of_Number)
        
        text = text.stringByReplacingOccurrencesOfString("[first]", withString: "\(questionsActiveIndex + 1)")
        text = text.stringByReplacingOccurrencesOfString("[second]", withString: "\(questions.count)")
        
        questionNumberLbl.text = text
        questionLbl.text = questions[questionsActiveIndex].question
    }
    
    
    // MARK: - State
    
    func stateButtonApply() {
        switch state {
        case .Rating:
            lowerBtn.enabled = ratingSliderVC.ratingSlider.value.slided
        case .Comment:
            lowerBtn.enabled = true
        }
    }
    
    private func stateApply() {
        switch state {
        case .Rating:
            upperBtn.resetRemoteConfigText()
            lowerBtn.resetRemoteConfigText()
            
            upperBtn.fontStyle = TextStyle.Button.rawValue
            lowerBtn.fontStyle = TextStyle.ButtonPrimary.rawValue
        case .Comment:
            upperBtn.remoteConfigKey = RemoteStringKey.Que_Comment_Save_Btn.rawValue
            lowerBtn.remoteConfigKey = RemoteStringKey.Que_Comment_Discard_Btn.rawValue
            
            upperBtn.fontStyle = TextStyle.ButtonPrimary.rawValue
            lowerBtn.fontStyle = TextStyle.ButtonError.rawValue
        }
        
        stateButtonApply()
        
        UIView.animateWithDuration(0.3, animations: {
            self.ratingStackViewShowSubview()
        })
    }

    
    // MARK: - Private Methods
    
    private func unknownError() {
        let HUD = JDPopup(titleKey: .ERROR_UNKNOWN_TITLE, subTitleKey: .ERROR_UNKNOWN_EXPLANATION, imageStyle: .Error)
        HUD.showInView(view)
    }
    
    private func dismissKeyboard() {
        UIApplication.sharedApplication().sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, forEvent: nil)
    }
    
    private func deleteComment() {
        ratingCommentTxtView.text = nil
    }
    
    private func saveAnswerAndProceed() {
        let UID = questions[questionsActiveIndex].uid
        let rating = ratingSliderVC.ratingSlider.value.integer
        let lastQuestion = questionsActiveIndex == questions.count - 1
        var comment: String? = nil
        
        if let text = ratingCommentTxtView.text where text.trimmed != "" {
            comment = text
        }
        
        let ratingAnswer = RatingAnswer(UID: UID, rating: rating, comment: comment)
        
        guard DataService.sharedInstance.addRating(ratingAnswer, lastQuestion: lastQuestion) else {
            return unknownError()
        }
        
        let flashSpeed = 0.3
        
        if lastQuestion {
            NotificationService.sharedInstance.setupNotifications()
            
            flash(.In, speed: flashSpeed, completion: { _ in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        } else {
            flash(.In, speed: flashSpeed, completion: { _ in
                self.resetView(andNextQuestion: true)
                self.flash(.Out, speed: flashSpeed, completion: nil)
            })
        }
    }
    
    private func resetView(andNextQuestion nextQuestion: Bool = false) {
        
        deleteComment()
        
        ratingSliderVC.ratingSlider.reset()
        
        if state != .Rating {
            state = .Rating
        }

        if nextQuestion {
            questionsActiveIndex += 1
        }
    }
}
