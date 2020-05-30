//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var timerTitle: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    var player: AVAudioPlayer!
    let eggTime = ["Soft": 2.0, "Medium": 7.0, "Hard": 12.0]
    var totalSeconds = 0.0
    var passedSeconds = 0.0
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        if let timer = self.timer {
            timer.invalidate()
        }
        self.totalSeconds = eggTime[sender.currentTitle!]!
        self.passedSeconds = 0.0
        self.progressBar.progress = 0.0
        timerTitle.text = "\(totalSeconds) seconds timer"
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    @objc private func update() {
        if self.passedSeconds < totalSeconds {
            print(self.passedSeconds)
            self.passedSeconds += 1
            self.progressBar.progress = Float(self.passedSeconds / self.totalSeconds)
        } else {
            self.timer!.invalidate()
            timerTitle.text = "done"
            let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3")
            player = try! AVAudioPlayer(contentsOf: url!)
            player.play()
        }
    }
    
}
