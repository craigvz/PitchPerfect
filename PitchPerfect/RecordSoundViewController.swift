//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by Craig Vanderzwaag on 10/31/15.
//  Copyright © 2015 blueHula Studios. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordingPausedLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    var fileName = "audioFile.m4a"
    
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAudioRecorder()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        recordingLabel.alpha = 1.0
        recordingLabel.text = "Tap Mic To Record"
        recordingLabel.textColor = UIColor.greenColor()
        pauseButton.setImage(UIImage(named: "pause"), forState: UIControlState.Normal)
        pauseButton.hidden = true
        stopButton.hidden = true
        recordingPausedLabel.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeRecordingLabelState () {
        
        if (recordingLabel.text == "Tap Mic To Record") {
            recordingLabel.text = "Recording..."
            recordingLabel.textColor = UIColor.redColor()
        } else {
            recordingLabel.text = "Tap Mic To Record"
            recordingLabel.textColor = UIColor.greenColor()
        }
    }
    
    //MARK: View Animation
    
    func animateRecordButton () {
        
        UIView.animateWithDuration(0.4, delay:0, options:[.Autoreverse, .Repeat], animations: {
            self.recordingLabel.alpha = 0.5
            }, completion: nil)
    }
    
    //MARK: Audio Recorder Setup
    
    func setupAudioRecorder () {
        
        //Assigne Recorder Settings
        let recorderSettings : [String : AnyObject] =
        [
            AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatAppleLossless),
            AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue as NSNumber,
            AVEncoderBitRateKey : 320000 as NSNumber,
            AVNumberOfChannelsKey: 2 as NSNumber,
            AVSampleRateKey : 44100.0 as NSNumber
        ]
        
        
        do {
            try! audioRecorder = AVAudioRecorder (URL: getFileURL(), settings: recorderSettings)
        }
        
        audioRecorder.delegate = self;
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        
        
    }
    
    
    //MARK: Audio File Location Methods
    
    func getFileURL () -> NSURL {
        
        let path = getCacheDirectory().stringByAppendingString(fileName)
        let filePath = NSURL(fileURLWithPath: path)
        
        return filePath
        
    }
    
    func getCacheDirectory () -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) 
        
        return paths[0]
    }
    
    
    
    @IBAction func recordAudio(sender: UIButton) {
        
        recordingLabel.hidden = false
        changeRecordingLabelState()
        animateRecordButton()
        stopButton.hidden = false
        pauseButton.hidden = false
        
        audioRecorder.record()
        
    }
    
    @IBAction func pauseRecordingAudio(sender: AnyObject) {
        if audioRecorder.recording {
            audioRecorder.pause()
            pauseButton.setImage(UIImage(named: "resume"), forState: UIControlState.Normal)
            recordingLabel.hidden = true
            recordingPausedLabel.hidden = false
        } else {
            audioRecorder.record()
            pauseButton.setImage(UIImage(named: "pause"), forState: UIControlState.Normal)
            recordingLabel.hidden = false
            recordingPausedLabel.hidden = true
        }
    }
    
    @IBAction func stopRecordingAudio(sender: UIButton) {
        
        changeRecordingLabelState()
        
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    
    //MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "play") {
            let playSoundVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundVC.recievedAudio = data
            
        }
    }
    
    
    //MARK: AVAudioRecorder delegate methods
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio (filePathURL: recorder.url, title: recorder.url.lastPathComponent)
            print("Recording Was Sucessful!")
            self.performSegueWithIdentifier("play", sender: recordedAudio)
            
        } else {
            print("Recording Was Not Sucessful")
            stopButton.hidden = true
        }
       
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder, error: NSError?) {
        print("Error recording audio \(error?.localizedDescription)")
    }

    
}

