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
    
    var circleRadius: CGFloat = 0
    var buttonPressed: Bool = false
    var validBreathe: Bool = true
    var inhaleDuration: Double = 4.0
    var exhaleDuration: Double = 4.0
    var timer: Timer = Timer()
    var timeCounter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.circleRadius = self.breatheView.frame.width/2
        self.breatheView.layer.cornerRadius = self.circleRadius
    }
    
    private func inhaleAnimation() {
        UIView.animate(withDuration: self.inhaleDuration, animations: {
            self.breatheView.transform = CGAffineTransform(scaleX: 20, y: 20)
        }, completion: { _ in
            if self.validBreathe {
                self.exhaleAnimation()
            }
        })
    }
    
    private func exhaleAnimation() {
        UIView.animate(withDuration: self.exhaleDuration, animations: {
            self.breatheView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }, completion: { _ in
                self.inhaleAnimation()
        })

    }
    
    @IBAction func didPressedButton(_ sender: Any) {
        self.buttonPressed = !self.buttonPressed
        self.validBreathe = true
        if self.buttonPressed {
            self.inhaleAnimation()
            self.timer = Timer.scheduledTimer(timeInterval: 1.0,
                                             target: self,
                                             selector: #selector(incrementTime),
                                             userInfo: nil,
                                             repeats: true)
        }
    }
    
    @objc private func incrementTime() {
        self.timeCounter += 1
        print(self.timeCounter)
        if self.timeCounter >= 60 {
            self.validBreathe = false
            self.timer.invalidate()
        }
    }
    
}

