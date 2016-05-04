//
//  ViewController.swift
//  iQuiz
//
//  Created by Peter Freschi on 5/1/16.
//  Copyright © 2016 Peter Freschi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    
    var categories = [String]()
    var descriptions = [String]()
    var images = [UIImage]()
    
    @IBAction func SettingsPressed(sender: AnyObject) {
        let alert = UIAlertController(title: "Settings", message: "Settings go here!", preferredStyle: UIAlertControllerStyle.Alert);
        //close dialog box
        alert.addAction(UIAlertAction(title: "OKAY", style: UIAlertActionStyle.Cancel, handler: nil));
        presentViewController(alert, animated: true, completion: nil);
    }
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categories = ["Mathematics", "Marvel Super Heroes", "Science"]
        descriptions = ["A lot of x's and y's", "To the rescue and beyond?", "Atoms and Molecules included!"]
        images = [UIImage(named: "cody.jpg")!, UIImage(named: "cody.jpg")!, UIImage(named: "cody.jpg")!]
        
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
   

}

