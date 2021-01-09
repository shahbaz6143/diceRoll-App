//
//  ViewController.swift
//  autoLayout
//
//  Created by Shahbaz Alam on 27/10/1941 Saka.
//  Copyright © 1941 Shahbaz Alam. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {

    @IBOutlet weak var playerTwoScore: UILabel!
    @IBOutlet weak var playerOne: UILabel!
    @IBOutlet weak var playerOneScore: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var playerTwo: UILabel!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var leftDiceImage: UIImageView!
    @IBOutlet weak var rightDiceImage: UIImageView!
    @IBOutlet weak var tapBtnOutlet: UIButton!
    
      var audio: AVAudioPlayer!
      var timer = Timer()
      var milliseconds:Float = 30 * 1000 //10 seconds
      var firstScore: Int = 0
      var secondScore: Int = 0
      var firstPlayerName: String = ""
      var secondPlayerName: String = ""
      var defaultScore = 0
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isHidden = true
        playerOne.text = firstPlayerName
        playerTwo.text = secondPlayerName
        setTimer()
        setElements()
    }
   
    
    @IBAction func Rollbtn(_ sender: UIButton) {
                
        let sound = URL(fileURLWithPath: Bundle.main.path(forResource: "diceRollSound", ofType: "mp3") ?? "Error")
        print("sound",sound)
        do {
                 audio = try AVAudioPlayer(contentsOf: sound)
                 audio.play()
            } catch {
                print("Can't play sound")
            }
        
        let firstnumber = Int.random(in: 1...6)
        let secondnumber = Int.random(in: 1...6)
        
        leftDiceImage.image = UIImage(named: "dice\(firstnumber)")
        rightDiceImage.image = UIImage(named: "dice\(secondnumber)")
        
        if firstnumber > secondnumber {
            firstScore += 1
            playerOneScore.text = String(firstScore)
          
            
        } else if firstnumber < secondnumber {
            secondScore += 1
            playerTwoScore.text = String(secondScore)
           
        } else {
            firstScore += 1
            secondScore += 1
            playerOneScore.text = String(firstScore)
            playerTwoScore.text = String(secondScore)
        }
    }
}


extension GameViewController {
    
    func setTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
    }
    
    @objc func timerElapsed() {
        milliseconds -= 1
        
        let seconds = String(format: "%.2f", milliseconds/1000)
        timerLbl.text = "Time Remaining: \(seconds)"
        
        if milliseconds <= 0 {
            timer.invalidate()
            timerLbl.textColor = UIColor.red
            timerLbl.text = "Time Over"
            
            let p1Score:Int = Int(playerOneScore.text!)!
            let p2Score:Int = Int(playerTwoScore.text!)!
            if p1Score > p2Score {
                showAlert("Congratulation \(firstPlayerName) 😊", "You have won the match")

            } else if p2Score > p1Score {
                showAlert("Congratulation \(secondPlayerName) 😊", "You have won the match")

            } else{
                showAlert("Rematch..!!", "Because Both player's score are equal")
            }
        }
    }
    
    
    func showAlert(_ title:String, _ message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let rematchButton = UIAlertAction(title: "Rematch", style: .default) { (action) in
            
            self.playerOneScore.text = "\(self.defaultScore)"
            self.playerTwoScore.text = "\(self.defaultScore)"
            self.firstScore = 0
            self.secondScore = 0
            self.milliseconds = 30 * 1000
            self.timerLbl.textColor = UIColor.white
            self.setTimer()
        }
        let exitButton = UIAlertAction(title: "Exit", style: .default) { (action) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(rematchButton)
        alert.addAction(exitButton)
        
        present(alert,animated: true , completion: nil)
    }

    
    func setElements() {
        
        tapBtnOutlet.layer.cornerRadius = tapBtnOutlet.layer.bounds.height/2
        tapBtnOutlet.layer.shadowOpacity = 1.0
        tapBtnOutlet.layer.shadowRadius = 20.0
        tapBtnOutlet.layer.shadowOffset = CGSize(width: 10, height: 10)
        mainView.layer.cornerRadius = 30.0
    }
}
