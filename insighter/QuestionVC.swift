//
//  QuestionVC.swift
//  insighter
//
//  Created by Jan Dammshäuser on 14.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class QuestionVC: UIViewController, Flashable {
    
    private var _questions = [RatingQuestion]()
    
    private var _activeQuestionIndex = 0 {
        didSet {
            _activeQuestion = _questions[_activeQuestionIndex]
        }
    }
    
    private var _activeQuestion: RatingQuestion! {
        didSet {
            setQuestion()
        }
    }
    
    private var state: State = .Rating {
        didSet {
            applyState()
        }
    }
    enum State {
        case Rating, Comment
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var questionNumberLbl: JDLabel!
    @IBOutlet weak var questionLbl: JDLabel!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var upperBtn: JDButton!
    @IBOutlet weak var lowerBtn: JDButton!
    
    private var ratingVC: RatingVC!
    private var commentTxtView: JDTextView!
    
    
    // MARK: - Startup
    
    convenience init() {
        self.init(nibName: "QuestionVC", bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStackView()
        applyState()
        
        _activeQuestionIndex = 0
    }

    
    // MARK: - Global Methods
    
    func initiate(withQuestions questions: [RatingQuestion]) {
        _questions = questions
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
            saveAnswer()
        case .Comment:
            commentTxtView.text = nil
            dismissKeyboard()
            
            state = .Rating
        }
    }
    
    
    // MARK: - Appearance
    
    private func setupStackView() {
        ratingVC = RatingVC()
        commentTxtView = JDTextView()
        
        addChildViewController(ratingVC)
        
        ratingStackView.addArrangedSubview(ratingVC.view)
        ratingStackView.addArrangedSubview(commentTxtView)
        
        ratingVC.didMoveToParentViewController(self)
        
        showFields()
    }
    
    
    // MARK: - State
    
    func applyButtonState() {
        switch state {
        case .Rating:
            lowerBtn.enabled = ratingVC.ratingSlider.rating.slided
        case .Comment:
            lowerBtn.enabled = true
        }
    }
    
    private func applyState() {
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
        
        applyButtonState()
        
        UIView.animateWithDuration(0.5, animations: {
            self.showFields()
        })
    }
    
    private func showFields() {
        let stateRating = state == .Rating
        
        ratingVC.view.hidden = !stateRating
        ratingVC.view.alpha = !stateRating ? 0 : 1
        commentTxtView.hidden = stateRating
        commentTxtView.alpha = stateRating ? 0 : 1
    }
    
    private func setQuestion() {
        var text = RemoteConfig.sharedInstance.getString(forKey: .Que_Number_Of_Number)
        
        text = text.stringByReplacingOccurrencesOfString("[first]", withString: "\(_activeQuestionIndex + 1)")
        text = text.stringByReplacingOccurrencesOfString("[second]", withString: "\(_questions.count)")
        
        questionNumberLbl.text = text
        questionLbl.text = _activeQuestion.question
    }

    
    // MARK: - Private Methods
    
    private func unknownError() {
        let HUD = JDPopup(titleKey: .ERROR_UNKNOWN_TITLE, subTitleKey: .ERROR_UNKNOWN_EXPLANATION, imageStyle: .Error)
        HUD.showInView(view)
    }
    
    private func dismissKeyboard() {
        UIApplication.sharedApplication().sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, forEvent: nil)
    }
    
    private func saveAnswer() {
        let UID = _activeQuestion.uid
        let rating = ratingVC.ratingSlider.rating.ratingInt
        let lastQuestion = _activeQuestionIndex == _questions.count-1
        var comment: String? = nil
        
        if let c = commentTxtView.text where c.trimmed != "" {
            comment = c
        }
        
        let ratingAnswer = RatingAnswer(UID: UID, rating: rating, comment: comment)
        
        guard DataService.sharedInstance.addRating(ratingAnswer, lastQuestion: lastQuestion) else {
            return unknownError()
        }
        
        if lastQuestion {
            NotificationService.sharedInstance.setupNotifications()
            
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            flash(.In, speed: 0.3, completion: { _ in
                self.resetView(andNextQuestion: true)
                self.flash(.Out, speed: 0.3, completion: nil)
            })
        }
    }
    
    private func resetView(andNextQuestion nextQuestion: Bool = false) {
        commentTxtView.text = nil
        ratingVC.ratingSlider.reset()
        state = .Rating
        
        if nextQuestion {
            _activeQuestionIndex += 1
        }
    }
}
