//
//  ViewController.swift
//  iQuiz
//
//  Created by Peter Freschi on 5/1/16.
//  Copyright © 2016 Peter Freschi. All rights reserved.
//

import UIKit

struct Question {
    var Question : String!
    var Answers : [String]!
    var Answer : Int!
}


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    var categories = [String]()
    var descriptions = [String]()
    var images = [UIImage]()
    
    var questionDictionary = Dictionary<String,[Question]>()

    let myDefaults = NSUserDefaults.standardUserDefaults()
    
    var jsonURL = String()
    
    var scoreString = String()

    @IBAction func ScoresPressed(sender: AnyObject) {
        self.myDefaults.objectForKey("scoreString")
        let alert = UIAlertController(title: "Scores", message: self.scoreString, preferredStyle: UIAlertControllerStyle.Alert);
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil));
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func SettingsPressed(sender: AnyObject) {
        let alert = UIAlertController(title: "Settings", message: "Change the URL for quiz data: ", preferredStyle: UIAlertControllerStyle.Alert);
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil));
        let checkAction = UIAlertAction(
        title: "Check Now", style: UIAlertActionStyle.Default) {
            (action) -> Void in
            if (alert.textFields?.first!.text != ""){
                self.jsonURL = (alert.textFields?.first!.text)! as String
                
            }
            self.getJSONandStore()
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (newJSON) -> Void in
            newJSON.placeholder = self.jsonURL
        }
        
        alert.addAction(checkAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.myDefaults.removeObjectForKey("scoreString")
        if (self.myDefaults.objectForKey("scoreString") == nil) {
            self.myDefaults.setObject(String(), forKey: "scoreString")
        }
        let storedScores = self.myDefaults.objectForKey("scoreString") as! String
        var newScoreString = scoreString
        if (storedScores != self.scoreString){
            newScoreString = storedScores + self.scoreString
        }
        self.myDefaults.setObject(newScoreString, forKey: "scoreString")
        scoreString = newScoreString
        
        images = [UIImage(named: "cody.jpg")!, UIImage(named: "cody.jpg")!, UIImage(named: "cody.jpg")!]
        
        jsonURL = "https://tednewardsandbox.site44.com/questions.json"
        
        getJSONandStore()

        self.setupUI()


        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier : String = "Cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
        }
        
        cell?.textLabel?.text = categories[indexPath.row]
        
        let image : UIImage = UIImage(named: "cody.jpg")!
        cell!.imageView!.image = image
        
        cell?.detailTextLabel?.text = descriptions[indexPath.row]
        return cell!
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showQuestion"{
            if let cell = sender as? UITableViewCell {
                let i = tableView.indexPathForCell(cell)!.row
                if segue.identifier == "showQuestion" {
                    let vc = segue.destinationViewController as! QuestionViewController
                    vc.questions = self.questionDictionary[categories[i]]!
                    vc.scoreString = self.scoreString
                }
            }
        }
    }


    func getJSONandStore() {
        //https://tednewardsandbox.site44.com/questions.json
        let requestURL: NSURL = NSURL(string: jsonURL)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            if (statusCode == 200 && Reachability.isConnectedToNetwork()) {
                
                do{
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    self.myDefaults.setObject(json, forKey: "currentJSON")
                    self.processJSON(json)
                }catch {
                    print("Error with Json: \(error)")
                }
            } else {
                print("Used old JSON")
                self.processJSON(self.myDefaults.objectForKey("currentJSON")!)
            }
        }
        task.resume()
    }
    
    func processJSON(json: AnyObject) {
        if let results = json as? [[String: AnyObject]] {
            dispatch_async(dispatch_get_main_queue(), {
                self.categories.removeAll()
                self.descriptions.removeAll()
                self.questionDictionary.removeAll()

                for category in results {
                    self.categories.append(category["title"] as! String)
                    self.descriptions.append(category["desc"] as! String)
                    var questionArray = [Question]()
                    var questionsOriginal = category["questions"] as! [Dictionary<String, AnyObject>]
                    
                    
                    for (index, _) in questionsOriginal.enumerate() {
                        let questionText = questionsOriginal[index]["text"] as! String
                        let correctAnswer = questionsOriginal[index]["answer"] as! String
                        let answers = questionsOriginal[index]["answers"] as! [String]
                        questionArray.append(Question(Question: questionText, Answers: answers, Answer: (Int(correctAnswer)! - 1)))
                    }
                    self.questionDictionary[category["title"] as! String] = questionArray
                }
                dispatch_async(dispatch_get_main_queue(),{
                    self.tableView.reloadData()

                })
            })
        }
    }
}


