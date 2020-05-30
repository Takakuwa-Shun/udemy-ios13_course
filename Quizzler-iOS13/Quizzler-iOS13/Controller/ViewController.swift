//
//  ViewController.swift
//  Quizzler-iOS13
//
//  Created by Angela Yu on 12/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var choice1: UIButton!
    @IBOutlet weak var choice2: UIButton!
    @IBOutlet weak var choice3: UIButton!
    var quizBrain: QuizBrain = QuizBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text! = quizBrain.getQuestionText()
        choice1.setTitle(quizBrain.getChoiceText(0), for: .normal)
        choice2.setTitle(quizBrain.getChoiceText(1), for: .normal)
        choice3.setTitle(quizBrain.getChoiceText(2), for: .normal)
        scoreLabel.text = quizBrain.getScore()
    }

    @IBAction func answerBtnTapped(_ sender: UIButton) {
        if quizBrain.checkAnswer(sender.currentTitle!) {
            sender.backgroundColor = UIColor.green
        } else {
            sender.backgroundColor = UIColor.red
        }
        quizBrain.updateQuestionNumber()
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateUi), userInfo: nil, repeats: false)
    }
    
    @objc private func updateUi() {
        questionLabel.text! = quizBrain.getQuestionText()
        progressBar.progress = quizBrain.getProgress()
        scoreLabel.text = quizBrain.getScore()
        choice1.setTitle(quizBrain.getChoiceText(0), for: .normal)
        choice2.setTitle(quizBrain.getChoiceText(1), for: .normal)
        choice3.setTitle(quizBrain.getChoiceText(2), for: .normal)
        self.choice1.backgroundColor = UIColor.clear
        self.choice2.backgroundColor = UIColor.clear
        self.choice3.backgroundColor = UIColor.clear
    }
    
}

