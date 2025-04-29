//
//  ViewController.swift
//  Pomodoro_App
//
//  Created by furkan yetgin on 27.04.2025.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var audioPlayer: AVAudioPlayer!

    @IBOutlet weak var pomodoroCountLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var timerLabel: UILabel!
    
    var timer: Timer?
    var totalTİme = 25 * 60
    var breakTime = 5 * 60
    var remaningTime = 25 * 60
    var isTimerRunning = false
    var isWorkTime = true
    var pomoCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.progress = 0.0
           updateTimerLabel()
           pomodoroCountLabel.text = "Bugün 0 Pomodoro tamamladın!"
    }

    @IBAction func startButtonPressed(_ sender: UIButton) {
        startTimer()
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        pauseTimer()
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        resetTimer()
    }

    
}

extension ViewController {
    func startTimer() {
        if !isTimerRunning {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            isTimerRunning = true
        }
    }
    
    func pauseTimer() {
        timer?.invalidate()
        isTimerRunning = false
    }
    
    
    func resetTimer() {
        timer?.invalidate()
        isTimerRunning = false
        isWorkTime = true
        totalTİme = 25 * 60
        remaningTime = totalTİme
        progressView.progress = 0.0
        updateTimerLabel()
    }
    
    @objc func updateTimer() {
        if remaningTime > 0 {
            remaningTime -= 1
            updateProgress()
            updateTimerLabel()
        }else {
            timer?.invalidate()
            isTimerRunning = false
            playSound()
            if isWorkTime {
                pomoCount += 1
                pomodoroCountLabel.text = "Bugün Tamamlanan Pomodoro Sayısı:\(pomoCount)"
                startBreak()
            }else{
                startWork()
            }
        }
    }
    
    func startWork() {
        isWorkTime = true
        totalTİme = 25 * 60
        remaningTime = totalTİme
        startTimer()
    }
    
    func startBreak() {
        isWorkTime = false
        totalTİme = 5 * 60
        remaningTime = totalTİme
        startTimer()
    }
    
    func updateTimerLabel() {
        let minutes = Int(remaningTime) / 60
        let seconds = Int(remaningTime) % 60
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        timerLabel.text = timeString
    }
    
    func updateProgress() {
        let progress = Float(totalTİme - remaningTime) / Float(totalTİme)
        progressView.progress = progress
    }
    
    func playSound(){
        guard let path = Bundle.main.path(forResource: "pomodoro_sound", ofType: "wav") else {
            print("ses dosyası bulunamadı")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
              audioPlayer = try AVAudioPlayer(contentsOf: url)
              audioPlayer?.play()
          } catch {
              print("Ses oynatılamadı: \(error.localizedDescription)")
          }
    }
        
    
}
