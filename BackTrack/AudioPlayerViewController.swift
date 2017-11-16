//
//  AudioPlayerViewController.swift
//  BackTrack
//
//  Created by Wilson Ding on 8/6/16.
//  Copyright © 2016 Wilson Ding. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var transferURL: NSURL!
    var flagArray: [Int] = []
    var transcriptionText: String!
    
    @IBOutlet weak var transcriptionField: UITextView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!

    var player = AVAudioPlayer()
    var toggleState = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        
        self.transcriptionField.text = transcriptionText
        
        let updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(AudioPlayerViewController.updateTime), userInfo: nil, repeats: true)
        let timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(AudioPlayerViewController.updateSlider), userInfo: nil, repeats: true)
            
        do {
            
            try player = AVAudioPlayer(contentsOfURL: transferURL)
            
        } catch {
            
            print("error")
        }
        
        timeSlider.maximumValue = Float(player.duration)
        
        self.tableview.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        player.pause()
    }
    
    @IBAction func playPauseButton(sender: AnyObject) {
        let playBtn = sender as! UIButton
        if toggleState == 1 {
            player.play()
            toggleState = 2
            playBtn.setTitle("Pause",forState:.Normal)
        } else {
            player.pause()
            toggleState = 1
            playBtn.setTitle("Play",forState:.Normal)
        }
    }
    
    @IBAction func scrubAudio(sender: AnyObject) {
        player.stop()
        player.currentTime = NSTimeInterval(timeSlider.value)
        player.prepareToPlay()
        player.play()
    }
    
    func updateSlider() {
        timeSlider.value = Float(player.currentTime)
    }
    
    func updateTime() {
        let currentTime = Int(player.currentTime)
        
        let minutes = currentTime/60
        let seconds = currentTime - minutes / 60
        
        timeLabel.text = NSString(format: "%02d:%02d", minutes,seconds) as String
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return flagArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        // Configure the cell...
        cell.textLabel!.text = NSString(format: "%02d:%02d", flagArray[indexPath.row]/60, flagArray[indexPath.row]%60) as String
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var time = flagArray[indexPath.row] - 10
    
        if time < 0 {
            time = 0
        }
        
        timeSlider.value = Float(time)
        player.stop()
        player.currentTime = NSTimeInterval(timeSlider.value)
        player.prepareToPlay()
        player.play()
        self.toggleState = 2
    }
    
    @IBAction func homeButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(false, completion: nil)
    }
}
