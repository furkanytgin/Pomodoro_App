import UIKit
import AVFoundation

class ViewController: UIViewController {
    var audioPlayer: AVAudioPlayer!

    @IBOutlet weak var restartText: UIButton!
    @IBOutlet weak var stopText: UIButton!
    @IBOutlet weak var startText: UIButton!
    @IBOutlet weak var pomodoroCountLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    var timer: Timer?
    var totalTİme = 25 * 60
    var breakTime = 5 * 60
    var remaningTime = 25 * 60
    var isTimerRunning = false
    var isWorkTime = true
    var pomoCount = 0

    // Daire Progress Bar Katmanları
    var shapeLayer = CAShapeLayer()
    var progressLayer = CAShapeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        starterLabels()
        setupTimerLabel()
        setupCircle()
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
    func setupCircle() {
        let center = timerLabel.center

        // Arka Plan Daire
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 80, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)


        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 8
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.position = center
        view.layer.insertSublayer(shapeLayer, below: timerLabel.layer)

        // Progress Daire
        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = UIColor.systemRed.cgColor
        progressLayer.lineWidth = 15
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.position = center
        progressLayer.strokeEnd = 0  // Başlangıç 0
        view.layer.insertSublayer(progressLayer, above: shapeLayer)
    }

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
        updateTimerLabel()
        updateProgress()
    }
    
    @objc func updateTimer() {
        if remaningTime > 0 {
            remaningTime -= 1
            updateProgress()
            updateTimerLabel()
        } else {
            timer?.invalidate()
            isTimerRunning = false
            playSound()
            if isWorkTime {
                pomoCount += 1
                pomodoroCountLabel.text = "Bugün Tamamlanan Pomodoro Sayısı: \(pomoCount)"
                startBreak()
            } else {
                startWork()
            }
        }
    }
    
    func startWork() {
        isWorkTime = true
        totalTİme = 25 * 60
        remaningTime = totalTİme
        updateProgress()
        startTimer()
    }
    
    func startBreak() {
        isWorkTime = false
        totalTİme = 5 * 60
        remaningTime = totalTİme
        updateProgress()
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
        progressLayer.strokeEnd = CGFloat(progress)
    }
    
    func playSound() {
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
    private func setupTimerLabel() {
            // Modern görünüm için timerLabel'ı konfigüre edelim
            timerLabel.layer.cornerRadius = 12
            timerLabel.clipsToBounds = true
            
            // Arkaplanı yarı-saydam siyah yap
            timerLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            
            // Yazı rengi ve stilini ayarla
            timerLabel.textColor = UIColor.white
            timerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .medium)
            
            // Padding eklemek için insets kullanıyoruz
            timerLabel.textAlignment = .center
            timerLabel.adjustsFontSizeToFitWidth = true
            timerLabel.minimumScaleFactor = 0.7
            
            // Gölge efekti ekleyelim
            timerLabel.layer.shadowColor = UIColor.black.cgColor
            timerLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
            timerLabel.layer.shadowOpacity = 0.3
            timerLabel.layer.shadowRadius = 3
            
            // İç içe padding için bir içerik dolgusu ekleyelim
            timerLabel.layoutMargins = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
            
            // Kenarlık ekleyelim
            timerLabel.layer.borderWidth = 1.0
            timerLabel.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        }
    
    private func restartTextLabel(){
        restartText.titleLabel?.font = UIFont.monospacedDigitSystemFont(ofSize: 25, weight: .medium)
        restartText.layer.cornerRadius = 12
        restartText.clipsToBounds = true
        restartText.layer.borderWidth = 1
        restartText.layer.borderColor = UIColor.systemGray.cgColor

        
    }
    private func startTextLabel(){
        startText.titleLabel?.font = UIFont.monospacedDigitSystemFont(ofSize: 25, weight: .medium)
        startText.layer.cornerRadius = 12
        startText.clipsToBounds = true
        startText.layer.borderWidth = 1
        startText.layer.borderColor = UIColor.systemGray.cgColor
        
    }
    private func stopTextLabel(){
        stopText.titleLabel?.font = UIFont.monospacedDigitSystemFont(ofSize: 25, weight: .medium)
        stopText.layer.cornerRadius = 12
        stopText.clipsToBounds = true
        stopText.layer.borderWidth = 1
        stopText.layer.borderColor = UIColor.systemGray.cgColor
        
    }
    private func pomodoroLabel(){
        pomodoroCountLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .medium)

        pomodoroCountLabel.layer.shadowColor = UIColor.black.cgColor
        pomodoroCountLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        pomodoroCountLabel.layer.shadowOpacity = 0.3
        pomodoroCountLabel.layer.shadowRadius = 3
    }
    private func starterLabels(){
        stopTextLabel()
        startTextLabel()
        restartTextLabel()
        pomodoroLabel()
    }
        
}
