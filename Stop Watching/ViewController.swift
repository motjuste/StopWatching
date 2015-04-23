//
//  ViewController.swift
//  Stop Watching
//
//  Created by Abdullah on 19/04/15.
//  Copyright (c) 2015 motjuste. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var timer = NSTimer()
//    let totalWatch = Watch()
//    let currentWatch = Watch()
//    var laps = [String]()
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var totalUILabel: UILabel!
    @IBOutlet weak var currentUILabel: UILabel!
    @IBOutlet weak var stopresetButton: UIButton!
    @IBOutlet weak var lapsTableView: UITableView!
    
    let stopresetButtonImageNames = [false: "stop.png", true: "reset.png"]
//    var stopwatchRunning: Bool = false
//    var resetEnabled: Bool = true  // Reset enabled only when stopwatch is stopped
    
    @IBAction func screenTap(sender: AnyObject) {
        if appDelegate.stopwatchRunning {

            // Reset currentWatch
            appDelegate.currentWatch.resetWatch(); currentUILabel.text = appDelegate.currentWatch.watchString
            
            // Add Lap
            appDelegate.laps.insert(appDelegate.totalWatch.watchString, atIndex: 0); lapsTableView.reloadData()
            appDelegate.resetEnabled = false
            
        } else {
            
            // Start Timer
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "updateLabels", userInfo: nil, repeats: true)
            appDelegate.stopwatchRunning = true
            
            // Enable and Unhide stopresetButton as Stop
//            stopresetButton.enabled = true
//            stopresetButton.hidden = false
//            stopresetButton.setImage(UIImage(named: "stop.png"), forState: .Normal)
            updateButton()
            
            // If stop watch started after Stop, scroll lapsTableView to top and make un-scrollable
            if appDelegate.resetEnabled {
//                appDelegate.resetEnabled = false
                if let firstIndexPath = NSIndexPath (forRow: 0, inSection: 0) {
                    lapsTableView.scrollToRowAtIndexPath(NSIndexPath (forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
                    lapsTableView.scrollEnabled = false
                }
            }
            appDelegate.resetEnabled = false
        }
    }
    
    @IBAction func stopreset(sender: AnyObject) {
        if appDelegate.resetEnabled {
            appDelegate.resetEnabled = false
            
            // Reset the stopwatches
            appDelegate.totalWatch.resetWatch(); totalUILabel.text = appDelegate.totalWatch.watchString
            appDelegate.currentWatch.resetWatch(); currentUILabel.text = appDelegate.currentWatch.watchString
            
            // Reset laps and lapsTableView
            appDelegate.laps.removeAll(keepCapacity: false)
            lapsTableView.reloadData()
            lapsTableView.scrollEnabled = false
            
            // Disable and hide stopresetButton
//            stopresetButton.enabled = false
//            stopresetButton.hidden = true
            updateButton()
        } else {

            // Stop timer
            timer.invalidate()
            appDelegate.stopwatchRunning = false
            
            // Change stopresetButton to Reset
//            stopresetButton.setImage(UIImage(named: "reset.png"), forState: .Normal)
            appDelegate.resetEnabled = true
            updateButton()
            
            // make lapsTableView scrollable
            lapsTableView.scrollEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize stopwatches
        totalUILabel.text = appDelegate.totalWatch.watchString
        currentUILabel.text = appDelegate.currentWatch.watchString
        
        // Disable and hide stopresetButton
//        stopresetButton.enabled = false
//        stopresetButton.hidden = true
        updateButton()
        
        // make lapsTableView un-scrollable
        lapsTableView.scrollEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLabels () {
        appDelegate.totalWatch.incrementWatch(); totalUILabel.text = appDelegate.totalWatch.watchString
        appDelegate.currentWatch.incrementWatch(); currentUILabel.text = appDelegate.currentWatch.watchString
    }
    
    func updateButton() {
        stopresetButton.setImage(UIImage(named: stopresetButtonImageNames[appDelegate.resetEnabled && !appDelegate.stopwatchRunning]!), forState: .Normal)
        stopresetButton.enabled = appDelegate.stopwatchRunning || appDelegate.resetEnabled
        stopresetButton.hidden  = !(appDelegate.stopwatchRunning || appDelegate.resetEnabled)
    }

    // Table View Methods
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
        
        // if a reusable UITableViewCell "Cell" is not available, create one
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: "Cell")  // UITableViewCellStyle.Value2 has two labels, first: Blue, aligned Right, second: Tint, aligned left
            
            // Customize cell
            cell.backgroundColor = self.view.backgroundColor
            
            cell.textLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: 24)
            cell.textLabel!.textColor = UIColor.blackColor()
            cell.textLabel!.textAlignment = NSTextAlignment.Left
            cell.detailTextLabel!.font = UIFont(name: "HelveticaNeue-UltraLight", size: 29)
        }
        
        // Add recent lap to top
        cell.textLabel!.text = "Lap \(appDelegate.laps.count - indexPath.row)"
        cell.detailTextLabel!.text = appDelegate.laps[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.laps.count
    }
    
}

