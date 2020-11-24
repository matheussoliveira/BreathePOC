//
//  ViewController.swift
//  BreathePOC
//
//  Created by Matheus Oliveira on 19/11/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var breatheView: UIView!
    @IBOutlet weak var breatheLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var tipLabel: UILabel!
    
    var circleRadius: CGFloat = 0
    var buttonPressed: Bool = false
    var validBreathe: Bool = true
    var breatheRate: Double = 7.0
    var inhaleDuration: Double!
    var exhaleDuration: Double!
    var timer: Timer = Timer()
    var timeCounter: Int = 0
    var tipCounter: Int = 0
    var delegate: ConfigDelegate?
    var inhaleTimer: Timer = Timer()
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.inhaleDuration = Double((60/breatheRate)/2)
        self.exhaleDuration = Double((60/breatheRate)/2)
        self.circleRadius = self.breatheView.frame.width/2
        self.breatheView.layer.cornerRadius = self.circleRadius
        self.tipLabel.isHidden = true
    }
    
    private func inhaleAnimation() {
        UIView.animate(withDuration: self.inhaleDuration, animations: {
            self.breatheView.transform = CGAffineTransform(scaleX: 10, y: 10)
        }, completion: { _ in
            self.tipCounter += 1
            self.tipLabel.text = "E expire."
            self.inhaleTimer.invalidate()
            self.exhaleAnimation()
        })
    }
    
    private func exhaleAnimation() {
        UIView.animate(withDuration: self.exhaleDuration, animations: {
            self.breatheView.transform = CGAffineTransform(scaleX: 0.10, y: 0.10)
        }, completion: { _ in
            if self.validBreathe {
                self.tipCounter += 1
                self.tipLabel.isHidden = true
                self.inhaleAnimation()
                self.inhaleTimer = Timer.scheduledTimer(timeInterval: self.inhaleDuration/15.0,
                                                 target: self,
                                                 selector: #selector(self.hapticFeedback),
                                                 userInfo: nil,
                                                 repeats: true)
            } else {
                self.resetExersice()
            }
        })

    }
    
    @IBAction func didPressedButton(_ sender: Any) {
        self.buttonPressed = !self.buttonPressed
        self.validBreathe = true
        self.tipCounter = 0
        self.tipLabel.isHidden = false
        self.tipLabel.text = "Fique parado e preste atenção em sua respiração."
        if self.buttonPressed {
            self.button.isHidden = true
            self.timer = Timer.scheduledTimer(timeInterval: 1.0,
                                             target: self,
                                             selector: #selector(prepareForExercise),
                                             userInfo: nil,
                                             repeats: true)
        }
    }
    
    @objc func hapticFeedback() {
        generator.impactOccurred()
    }
    
    @objc private func prepareForExercise() {
        self.timeCounter += 1
        if self.timeCounter == 5 {
            self.timer.invalidate()
            self.timeCounter = 0
            self.timer = Timer.scheduledTimer(timeInterval: 1.0,
                                              target: self,
                                              selector: #selector(incrementTime),
                                              userInfo: nil,
                                              repeats: true)
            self.inhaleTimer = Timer.scheduledTimer(timeInterval: inhaleDuration/15.0,
                                             target: self,
                                             selector: #selector(hapticFeedback),
                                             userInfo: nil,
                                             repeats: true)
            self.inhaleAnimation()
            self.tipLabel.text = "Agora inspire..."
        }
    }
    
    @objc private func incrementTime() {
        self.timeCounter += 1
        if self.timeCounter >= 60 {
            self.validBreathe = false
            self.timer.invalidate()
            self.button.isHidden = false
        }
    }
    
    private func resetExersice() {
        UIView.animate(withDuration: 1.0,
                       animations: { self.breatheView.transform = CGAffineTransform(scaleX: 1, y: 1 )})
        self.circleRadius = self.breatheView.frame.width/2
        self.timeCounter = 0
        self.tipCounter = 0
        self.buttonPressed = false
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToConfig" {
            if let configVC = segue.destination as? ConfigTableViewController {
                configVC.delegate = self
                configVC.currentSelection = Int(breatheRate)
            }
        }
    }
}

extension ViewController: ConfigDelegate {
    func setBreatheRate(rate: Int) {
        self.breatheRate = Double(rate)
        self.inhaleDuration = Double((60/breatheRate)/2.0)
        self.exhaleDuration = Double((60/breatheRate)/2.0)
    }
}
