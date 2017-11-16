//
//  RecordViewController.swift
//  BackTrack
//
//  Created by Wilson Ding on 8/6/16.
//  Copyright © 2016 Wilson Ding. All rights reserved.
//

import UIKit
import AVFoundation
import SpeechToTextV1
import AlchemyLanguageV1
import SwiftyJSON
import QuartzCore
import Pulsator

class RecordViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var transcriptionField: UITextView!
    @IBOutlet weak var animationView: UIView!
    
    var swiftTimer = NSTimer()
    var timerSec = 0
    var timerMin = 0
    
    var stt: SpeechToText?
    var recorder: AVAudioRecorder!
    var isStreamingDefault = false
    var stopStreamingDefault: (Void -> Void)? = nil
    var captureSession: AVCaptureSession? = nil
    
    var transferURL: NSURL!
    var flagArray: [Int] = []
    var transcriptionText = "<Watson was unable to transcribe your text, due to lack of internet or too much noise>"
    
    var summary: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        
        timer.hidden = true
        
        transcriptionField.textColor = UIColor.whiteColor()
        
        self.background.image! = UIImage(named: "Background_Blue.png")!
        
        // create file to store recordings
        let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let filename = "SpeechToTextRecording.wav"
        let filepath = NSURL(fileURLWithPath: documents + "/" + filename)
        
        // set up session and recorder
        let session = AVAudioSession.sharedInstance()
        var settings = [String: AnyObject]()
        settings[AVSampleRateKey] = NSNumber(float: 44100.0)
        settings[AVNumberOfChannelsKey] = NSNumber(int: 1)
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            recorder = try AVAudioRecorder(URL: filepath, settings: settings)
        } catch {
            failure("Audio Recording", message: "Error setting up session/recorder.")
        }
        
        // ensure recorder is set up
        guard let recorder = recorder else {
            failure("AVAudioRecorder", message: "Could not set up recorder.")
            return
        }
        
        // prepare recorder to record
        recorder.delegate = self
        recorder.meteringEnabled = true
        recorder.prepareToRecord()
        
        // hide play button
        actionButton.hidden = true
        
        instantiateSTT()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        flagArray = []
    }
    
    func instantiateSTT() {
        let user = "<import STT api key here>"

        let password = "<import STT api secret key here>"
        
        
        stt = SpeechToText(username: user, password: password)
    }
    
    @IBAction func recordButtonPressed(sender: AnyObject) {
        if self.background.image! == UIImage(named: "Background_Blue.png") {
            // ensure recorder is set up
            guard let recorder = recorder else {
                failure("Start/Stop Recording", message: "Recorder not properly set up.")
                return
            }
            
            startTimer()
            
            streamToWatson()
            
            do {
                let session = AVAudioSession.sharedInstance()
                try session.setActive(true)
                recorder.record()
                self.background.image = UIImage(named: "Background_Red.png")
                self.actionButton.hidden = false
                self.actionButton.setImage(UIImage(named: "Check.png"), forState: UIControlState.Normal)
            } catch {
                failure("Start/Stop Recording", message: "Error setting session active.")
            }
            
            
        }

        else if self.background.image! == UIImage(named: "Background_Red.png") {
            recorder.stop()
            stopStreamingDefault?()
            endTimer()
            isStreamingDefault = false
            self.background.image = UIImage(named: "Background_Blue.png")
            self.actionButton.setImage(UIImage(named: "Play.png"), forState: UIControlState.Normal)
            
            sentimentScore()
        }
        
        else {
            print("Oops...")
        }
    }
    
    @IBAction func actionButtonPressed() {
        if self.actionButton.imageView!.image == UIImage(named: "Play.png") {
            // ensure recorder is set up
            guard let recorder = recorder else {
                failure("Play Recording", message: "Recorder not properly set up")
                return
            }
            
            sentimentScore()
            
            if self.transcriptionField.text != nil {
                self.transcriptionText = self.transcriptionField.text
            }
            
            self.transcriptionText = self.transcriptionText.stringByAppendingString(summary)
            
            self.transcriptionField.text = self.transcriptionText
            
            // play saved recording
            if (!recorder.recording) {
                self.transferURL = recorder.url
                
                self.performSegueWithIdentifier("actionButtonPressed", sender: self)
            }
        }
            
        else if self.actionButton.imageView!.image == UIImage(named: "Check.png") {
            flagArray.append(timerMin*60 + timerSec)
            //print("Added Flag at \(timerMin):\(timerSec)")
        }
            
        else {
            print("Oops...")
        }
    }
    
    func streamToWatson() {
        // stop if already streaming
        if (isStreamingDefault) {
            stopStreamingDefault?()
            isStreamingDefault = false
            return
        }
        
        // set streaming
        isStreamingDefault = true
        
        // ensure SpeechToText service is up
        guard let stt = stt else {
            failure("STT Streaming (Default)", message: "SpeechToText not properly set up.")
            return
        }
        
        // configure settings for streaming
        var settings = TranscriptionSettings(contentType: .L16(rate: 44100, channels: 1))
        settings.continuous = true
        settings.interimResults = true
        
        // start streaming from microphone
        stopStreamingDefault = stt.transcribe(settings, failure: failureDefault) { results in
            self.showResults(results)
        }
    }
    
    func failure(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default) { action in }
        alert.addAction(ok)
        presentViewController(alert, animated: true) { }
    }
    
    func failureData(error: NSError) {
        let title = "Speech to Text Error:\nTranscribe"
        let message = error.localizedDescription
        failure(title, message: message)
    }
    
    func failureDefault(error: NSError) {
        let title = "Speech to Text Error:\nStreaming (Default)"
        let message = error.localizedDescription
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default) { action in
            self.stopStreamingDefault?()
            self.background.image = UIImage(named: "Background_Blue.png")
            self.isStreamingDefault = false
        }
        alert.addAction(ok)
        presentViewController(alert, animated: true) { }
    }
    
    func showResults(results: [TranscriptionResult]) {
        var text = ""
        
        for result in results {
            if let transcript = result.alternatives.last?.transcript where result.final == true {
                let title = titleCase(transcript)
                text += String(title.characters.dropLast()) + "." + " "
            }
        }
        
        if results.last?.final == false {
            if let transcript = results.last?.alternatives.last?.transcript {
                text += titleCase(transcript)
            }
        }
        
        self.transcriptionField.text = text
    }
    
    func titleCase(s: String) -> String {
        let first = String(s.characters.prefix(1)).uppercaseString
        return first + String(s.characters.dropFirst())
    }
    
    func startTimer() {
        timer.hidden = false
        swiftTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(RecordViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
    func endTimer() {
        timer.hidden = true
        timer.text = "0.00"
        swiftTimer.invalidate()
        timerMin = 0
        timerSec = 0
    }
    
    func updateTimer() {
        if timerSec < 59 {
            timerSec += 1
        }
        
        else {
            timerSec = 0
            timerMin += 1
        }
        
        if timerSec < 10 {
            timer.text = "\(timerMin):0\(timerSec)"
        }
        
        else {
            timer.text = "\(timerMin):\(timerSec)"
        }
    }
    
    func sentimentScore() {
        if self.transcriptionText != "<Watson was unable to transcribe your text, due to lack of internet or too much noise>" {
            let apiKey = "<import Sentiment api key here>"
            let alchemyLanguage = AlchemyLanguage(apiKey: apiKey)
            
            let filename = getDocumentsDirectory().stringByAppendingPathComponent("output.txt")
            
            do {
                try self.transcriptionText.writeToFile(filename, atomically: true, encoding: NSUTF8StringEncoding)
            } catch {
                // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
            }
            
            let url = NSURL(fileURLWithPath: filename)
            
            let failure = { (error: NSError) in print(error) }
            alchemyLanguage.getTextSentiment(forText: url, failure: failure) { sentiment in
                let score = sentiment.docSentiment?.score
                let type = sentiment.docSentiment?.type
                self.summary = " [Sentiment Analysis: \(score! * 100)% \(type!)]"
            }
        }
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "actionButtonPressed"{
            let targetController = segue.destinationViewController as! AudioPlayerViewController
            targetController.flagArray = self.flagArray
            targetController.transferURL = self.transferURL
            targetController.transcriptionText = self.transcriptionText
        }
    }
}
