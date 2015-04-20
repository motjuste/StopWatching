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
    
    var stopwatchRunning: Bool = false
    var resetEnabled: Bool = false
    
    @IBOutlet weak var totalUILabel: UILabel!
    @IBOutlet weak var currentUILabel: UILabel!
    @IBOutlet weak var stopresetButton: UIButton!
    @IBOutlet weak var lapsTableView: UITableView!
    
    @IBAction func screenTap(sender: AnyObject) {
        if stopwatchRunning {
            currentWatch.resetWatch()
            currentUILabel.text = currentWatch.watchString
            
            laps.insert(totalWatch.watchString, atIndex: 0)
            lapsTableView.reloadData()
        } else {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "updateLabels", userInfo: nil, repeats: true)
            
            stopresetButton.enabled = true
            stopresetButton.hidden = false
            stopresetButton.setImage(UIImage(named: "stop.png"), forState: .Normal)
            
            stopwatchRunning = true
            
            if resetEnabled {
                resetEnabled = false
                stopresetButton.setImage(UIImage(named: "stop.png"), forState: .Normal)
                
                lapsTableView.scrollToRowAtIndexPath(NSIndexPath (forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
                lapsTableView.scrollEnabled = false
            }
        }
    }
    
    @IBAction func stopreset(sender: AnyObject) {
        if resetEnabled {
            totalWatch.resetWatch()
            totalUILabel.text = totalWatch.watchString
            currentWatch.resetWatch()
            currentUILabel.text = currentWatch.watchString
            
            laps.removeAll(keepCapacity: false)
            lapsTableView.reloadData()
            
            stopresetButton.enabled = false
            stopresetButton.hidden = true
            resetEnabled = false
            
            stopwatchRunning = false
            
            lapsTableView.scrollEnabled = false
        } else {
            timer.invalidate()
            stopwatchRunning = false
            stopresetButton.setImage(UIImage(named: "reset.png"), forState: .Normal)
            resetEnabled = true
            
            lapsTableView.scrollEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        totalUILabel.text = totalWatch.watchString
        currentUILabel.text = currentWatch.watchString
        stopresetButton.enabled = false
        stopresetButton.hidden = true
        
        lapsTableView.scrollEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLabels () {
        totalWatch.incrementWatch()
        totalUILabel.text = totalWatch.watchString
        currentWatch.incrementWatch()
        currentUILabel.text = currentWatch.watchString
    }

    // Table View Methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        
        cell.backgroundColor = self.view.backgroundColor
        cell.textLabel?.text = "Lap \(laps.count - indexPath.row)"
        cell.textLabel?.font = UIFont(name: "Helvtica Neu Thin", size: 29)
        cell.detailTextLabel?.text = laps[indexPath.row]
        cell.detailTextLabel?.font = totalUILabel.font
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return laps.count
    }
    
    
}

