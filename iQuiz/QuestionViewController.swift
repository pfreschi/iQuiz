//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Peter Freschi on 5/9/16.
//  Copyright © 2016 Peter Freschi. All rights reserved.
//

import Foundation
import UIKit

class QuestionViewController: UIViewController {
    
    var qnumber = Int()
    
    var questions = [Question]()
    
    var numCorrect = Int()
    var numTotalQuestions = Int()
    
    var userAnswer = Int()
    
    let tealColor = UIColor(red: 102/255.0, green: 204/255.0, blue: 255/255.0, alpha: 1.0)
    let darkTealColor = UIColor(red: 0/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0)
    
    var scoreString = String()
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet var questionButtons: [UIButton]!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func answer1Pressed(sender: UIButton) {
        userAnswer = 1
        submitButton.userInteractionEnabled = true
        for i in 0..<questionButtons.count{
            questionButtons[i].backgroundColor = tealColor
        }
        questionButtons[0].backgroundColor = darkTealColor
    }
    @IBAction func answer2Pressed(sender: UIButton) {
        userAnswer = 2
        submitButton.userInteractionEnabled = true
        for i in 0..<questionButtons.count{
            questionButtons[i].backgroundColor = tealColor
        }
        questionButtons[1].backgroundColor = darkTealColor
    }
    @IBAction func answer3Pressed(sender: UIButton) {
        userAnswer = 3
        submitButton.userInteractionEnabled = true
        for i in 0..<questionButtons.count{
            questionButtons[i].backgroundColor = tealColor
        }
        questionButtons[2].backgroundColor = darkTealColor
    }
    @IBAction func answer4Pressed(sender: UIButton) {
        userAnswer = 4
        submitButton.userInteractionEnabled = true
        for i in 0..<questionButtons.count{
            questionButtons[i].backgroundColor = tealColor
        }
        questionButtons[3].backgroundColor = darkTealColor
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.userInteractionEnabled = false
        
        pickQuestion()
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(QuestionViewController.handleSwipes(_:)))
        
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(QuestionViewController.handleSwipes(_:)))
        
        leftSwipe.direction = .Left
        
        view.addGestureRecognizer(leftSwipe)
        

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Right && userAnswer != 0) {
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("validateAnswer", sender: nil)
            }
        } else if (sender.direction == .Left) {
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("backHome", sender: nil)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (questions.count <= 0){
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("showResults", sender: self)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func pickQuestion() {
        if (questions.count > 0) {
            qnumber = 0
            questionLabel.text = questions[qnumber].Question
            
            for i in 0..<questionButtons.count{
                questionButtons[i].setTitle(questions[qnumber].Answers[i], forState: UIControlState.Normal)
            }
            
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("showResults", sender: nil)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "validateAnswer"{
            let vc = segue.destinationViewController as! RevealViewController
            vc.questions = self.questions
            vc.numCorrect = self.numCorrect
            vc.numTotalQuestions = self.numTotalQuestions
            vc.userAnswer = self.userAnswer
            vc.scoreString = self.scoreString
        } else if segue.identifier == "showResults"{
            let vc = segue.destinationViewController as! ResultsViewController
            //pass over results
            vc.numCorrect = self.numCorrect
            vc.numTotalQuestions = self.numTotalQuestions
            vc.scoreString = self.scoreString
        }

    }

    
    
    
    
}


