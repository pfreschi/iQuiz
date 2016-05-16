//
//  RevealViewController.swift
//  iQuiz
//
//  Created by Peter Freschi on 5/9/16.
//  Copyright © 2016 Peter Freschi. All rights reserved.
//

import Foundation
import UIKit

class RevealViewController: UIViewController {
    
    
    var questions = [Question]()
    
    var numCorrect = Int()
    var numTotalQuestions = Int()
    
    var userAnswer = Int()
    
    @IBOutlet weak var rightOrWrong: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet var answerLabels: [UILabel]!
    
    var scoreString = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let qnumber = 0
        questionLabel.text = questions[qnumber].Question
        let grayColor = UIColor(red: 247/255.0, green: 246/255.0, blue: 252/255.0, alpha: 1.0)
        for i in 0..<answerLabels.count{
            answerLabels[i].text = questions[qnumber].Answers[i]
            answerLabels[i].textColor = grayColor
            answerLabels[i].backgroundColor = grayColor
        }
        numTotalQuestions = numTotalQuestions + 1
        
        if userAnswer - 1 == questions[qnumber].Answer {
            rightOrWrong.text = "You got it right!"
            numCorrect = numCorrect + 1
            let greenColor = UIColor(red: 55/255.0, green: 207/255.0, blue: 14/255.0, alpha: 1.0)
            self.view.backgroundColor = greenColor
            for i in 0..<answerLabels.count{
                answerLabels[i].backgroundColor = greenColor
            }

            answerLabels[userAnswer - 1].backgroundColor = UIColor.greenColor()
            answerLabels[userAnswer - 1].textColor = UIColor.whiteColor()
        } else {
            rightOrWrong.text = "You got it wrong!"
            let redColor = UIColor(red: 207/255.0, green: 55/255.0, blue: 14/255.0, alpha: 1.0)
            self.view.backgroundColor = redColor
            for i in 0..<answerLabels.count{
                answerLabels[i].backgroundColor = redColor
            }
            answerLabels[userAnswer - 1].backgroundColor = UIColor.redColor()
            answerLabels[questions[qnumber].Answer].backgroundColor = UIColor.greenColor()
            
        }
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(QuestionViewController.handleSwipes(_:)))
        
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(QuestionViewController.handleSwipes(_:)))
        
        leftSwipe.direction = .Left
        
        view.addGestureRecognizer(leftSwipe)
        
        questions.removeAtIndex(qnumber)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Right && userAnswer != 0) {
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("showNextQuestion", sender: nil)
            }
        } else if (sender.direction == .Left) {
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("goBackHome", sender: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showNextQuestion"{
            let vc = segue.destinationViewController as! QuestionViewController
            vc.questions = self.questions
            vc.numCorrect = self.numCorrect
            vc.numTotalQuestions = self.numTotalQuestions
            vc.userAnswer = self.userAnswer
            vc.scoreString = self.scoreString
        } else if segue.identifier == "goBackHome"{
            let vc = segue.destinationViewController as! ViewController
            vc.scoreString = self.scoreString
        }
    }
    
    
    
    
}


