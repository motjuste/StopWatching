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
    var totalWatch = Watch()
    var currentWatch = Watch()
    var laps = [String]()
    
    @IBOutlet weak var totalUILabel: UILabel!
    @IBOutlet weak var currentUILabel: UILabel!
    @IBOutlet weak var stopresetButton: UIButton!
    @IBOutlet weak var lapsTableView: UITableView!
    
    var stopwatchRunning: Bool = false
    var resetEnabled: Bool = false  // Reset enabled only when stopwatch is stopped
    
    @IBAction func screenTap(sender: AnyObject) {
        if stopwatchRunning {

            // Reset currentWatch
            currentWatch.resetWatch(); currentUILabel.text = currentWatch.watchString
            
            // Add Lap
            laps.insert(totalWatch.watchString, atIndex: 0); lapsTableView.reloadData()
            
            
        } else {
            
            // Start Timer
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "updateLabels", userInfo: nil, repeats: true)
            stopwatchRunning = true
            
            // Enable and Unhide stopresetButton as Stop
            stopresetButton.enabled = true
            stopresetButton.hidden = false
            stopresetButton.setImage(UIImage(named: "stop.png"), forState: .Normal)
            
            // If stop watch started after Stop, scroll lapsTableView to top and make un-scrollable
            if resetEnabled {
                resetEnabled = false
                lapsTableView.scrollToRowAtIndexPath(NSIndexPath (forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
                lapsTableView.scrollEnabled = false
            }
        }
    }
    
    @IBAction func stopreset(sender: AnyObject) {
        if resetEnabled {
            resetEnabled = false
            
            // Reset the stopwatches
            totalWatch.resetWatch(); totalUILabel.text = totalWatch.watchString
            currentWatch.resetWatch(); currentUILabel.text = currentWatch.watchString
            
            // Reset laps and lapsTableView
            laps.removeAll(keepCapacity: false)
            lapsTableView.reloadData()
            lapsTableView.scrollEnabled = false
            
            // Disable and hide stopresetButton
            stopresetButton.enabled = false
            stopresetButton.hidden = true
        } else {

            // Stop timer
            timer.invalidate()
            stopwatchRunning = false
            
            // Change stopresetButton to Reset
            stopresetButton.setImage(UIImage(named: "reset.png"), forState: .Normal)
            resetEnabled = true
            
            // make lapsTableView scrollable
            lapsTableView.scrollEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize stopwatches
        totalUILabel.text = totalWatch.watchString
        currentUILabel.text = currentWatch.watchString
        
        // Disable and hide stopresetButton
        stopresetButton.enabled = false
        stopresetButton.hidden = true
        
        // make lapsTableView un-scrollable
        lapsTableView.scrollEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLabels () {
        totalWatch.incrementWatch(); totalUILabel.text = totalWatch.watchString
        currentWatch.incrementWatch(); currentUILabel.text = currentWatch.watchString
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
        cell.textLabel!.text = "Lap \(laps.count - indexPath.row)"
        cell.detailTextLabel!.text = laps[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return laps.count
    }
    
}

