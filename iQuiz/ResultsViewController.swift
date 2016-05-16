//
//  ResultsViewController.swift
//  iQuiz
//
//  Created by Peter Freschi on 5/9/16.
//  Copyright © 2016 Peter Freschi. All rights reserved.
//

import Foundation
import UIKit

class ResultsViewController: UIViewController {
    

    @IBOutlet weak var howUserDid: UILabel!
    
    @IBOutlet weak var youScored: UILabel!
    
    var numCorrect = Int()
    var numTotalQuestions = Int()
    
    var scoreString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var performance = String()
        if (numCorrect == numTotalQuestions) {
            performance = "Perfect!"
        } else {
            performance = "Almost!"
        }
        howUserDid.text = performance
        
        youScored.text = "You scored: \(numCorrect) out of \(numTotalQuestions)"
        
        scoreString = "You scored: \(numCorrect) out of \(numTotalQuestions) \n"
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(QuestionViewController.handleSwipes(_:)))
        
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(rightSwipe)

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Right) {
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("startOver", sender: nil)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "startOver"{
            let vc = segue.destinationViewController as! ViewController
            vc.scoreString = self.scoreString
        }
    }


    
    
}



