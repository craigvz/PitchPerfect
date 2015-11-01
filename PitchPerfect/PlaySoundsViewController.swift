//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Craig Vanderzwaag on 10/31/15.
//  Copyright © 2015 blueHula Studios. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    
    var movieQuote: AVAudioPlayer!
    var recievedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieQuote = try! AVAudioPlayer(contentsOfURL: recievedAudio.filePathUrl)
        movieQuote.enableRate = true
            
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTouchSlowButton(sender: AnyObject) {
        print("didTouchSlowButton")
        movieQuote.stop()
        movieQuote.rate = 0.5
        movieQuote.currentTime = 0.0
        movieQuote.play()
    }
    
    @IBAction func didTouchFastButton(sender: AnyObject) {
        
        movieQuote.stop()
        movieQuote.rate = 1.5
        movieQuote.currentTime = 0.0
        movieQuote.play()
    }
    
    @IBAction func stopAudio(sender: AnyObject) {
        
        movieQuote.stop()
    }
}
