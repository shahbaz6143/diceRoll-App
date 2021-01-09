//
//  HomeViewController.swift
//  diceRoll App
//
//  Created by Shahbaz Alam on 02/01/21.
//  Copyright © 2021 Shahbaz Alam. All rights reserved.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var bgVideoView: UIView!
    @IBOutlet weak var playerTwo: UITextField!
    @IBOutlet weak var playerOne: UITextField!
    @IBOutlet weak var doneBtnOutlet: UIButton!
        
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    
    var playerItem: AVPlayerItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationController?.navigationBar.isHidden = true
        bgVideoPlay()
        setElements()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        playerOne.text = ""
        playerTwo.text = ""
        bgVideoPlay()
    }
    
    
    @IBAction func doneBtnPressed(_ sender: UIButton) {
        
        player.pause()
        if playerOne.text != "" && playerTwo.text != "" {
            
            let gameVc = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
            
            gameVc.firstPlayerName = playerOne.text!
            gameVc.secondPlayerName = playerTwo.text!
            self.navigationController?.pushViewController(gameVc, animated: true)
        }
        else {
            showAlert("Please Enter both player's name", "It's mandatory to fill both fields")
        }
    }
}




extension HomeViewController {

    func bgVideoPlay() {
        
        guard let pathUrl = Bundle.main.url(forResource: "bgVideo", withExtension: "mov") else { return }
        player = AVPlayer(url: pathUrl)
        playerLayer = AVPlayerLayer(player: player)
        
        NotificationCenter.default.addObserver(self,
        selector: #selector(playerItemDidReachEnd),
        name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
        object: nil)

        playerLayer.frame = CGRect(x: -self.view.frame.size.width*3, y: 0, width: self.view.frame.size.width*5, height: self.view.frame.size.height)
        self.bgVideoView.layer.addSublayer(playerLayer)
        player.playImmediately(atRate: 0.3)
        
        bgVideoView.bringSubviewToFront(doneBtnOutlet)
        bgVideoView.bringSubviewToFront(playerOne)
        bgVideoView.bringSubviewToFront(playerTwo)
        bgVideoView.bringSubviewToFront(img)
    }
    
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        player.seek(to: CMTime.zero)
        player.playImmediately(atRate: 0.3)

    }

    
    func showAlert(_ title:String, _ message:String) {
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alert.addAction(alertAction)
            
            present(alert,animated: true , completion: nil)
        }
    
    
    func setElements() {
        
        doneBtnOutlet.layer.cornerRadius = doneBtnOutlet.layer.bounds.height/2
        doneBtnOutlet.layer.shadowRadius = 30.0
        doneBtnOutlet.layer.shadowOpacity = 1.0
        doneBtnOutlet.layer.shadowOffset = CGSize(width: 10, height: 10)
    }
}
