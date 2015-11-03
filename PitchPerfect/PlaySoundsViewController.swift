//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Craig Vanderzwaag on 10/31/15.
//  Copyright © 2015 blueHula Studios. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    
    
    var audioPlayer: AVAudioPlayer!
    var recievedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initalize AVAudioPlayer with Passed Recorded Audio
        audioPlayer = try! AVAudioPlayer(contentsOfURL: recievedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        //Initialize AVAudioEngine1
        audioEngine = AVAudioEngine ()
        audioFile = try! AVAudioFile (forReading: recievedAudio.filePathUrl)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Play Audio Functions
    
    func playAudioWithVariableSpeed(rate: Float) {
        
        resetAudioPlayerAndEngine()
        
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        
    }
    
    
    func playAudioWithEffect (effect: NSObject) {
        
        resetAudioPlayerAndEngine()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(effect as! AVAudioNode)
        
        audioEngine.connect(audioPlayerNode, to: effect as! AVAudioNode, format: nil)
        audioEngine.connect(effect as! AVAudioNode, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        try! audioEngine.start()
        audioPlayerNode.play()
        
    }
    
    
    //MARK: IBActions from buttons

    @IBAction func didTouchSlowButton(sender: UIButton) {
        
        playAudioWithVariableSpeed(0.5)
    }
    
    @IBAction func didTouchFastButton(sender: UIButton) {
        
        playAudioWithVariableSpeed(1.5)
    }
    
    @IBAction func didTouchChipmunkButton(sender: UIButton) {
        
        let highPitchEffect = AVAudioUnitTimePitch()
        highPitchEffect.pitch = 1000
        playAudioWithEffect(highPitchEffect)
        
    }
  
    @IBAction func didTouchVaderButton(sender: UIButton) {
        
        let lowPitchEffect = AVAudioUnitTimePitch()
        lowPitchEffect.pitch = -1000
        playAudioWithEffect(lowPitchEffect)
    }
    
    @IBAction func didTouchReverbButton(sender: UIButton) {
        
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(.LargeRoom2)
        reverbEffect.wetDryMix = 70
        playAudioWithEffect(reverbEffect)
    
    }
    
    @IBAction func didTouchEchoButton(sender: UIButton) {
        
        let echoEffect = AVAudioUnitDelay()
        echoEffect.delayTime = 0.7
        playAudioWithEffect(echoEffect)
    
    }
    
    
    @IBAction func stopAudio(sender: UIButton) {
        
        resetAudioPlayerAndEngine()
    }
    
    func resetAudioPlayerAndEngine () {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
    }
}
