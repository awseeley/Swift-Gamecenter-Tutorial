//
//  ViewController.swift
//  gamecenter


import UIKit
import GameKit



class ViewController: UIViewController, GKGameCenterControllerDelegate {
    
    @IBOutlet var lblScore: UILabel!
    
    var score: Int = 0
    
    var gcEnabled = Bool()
    var gcDefaultLeaderBoard = String()
    
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                self.presentViewController(ViewController, animated: true, completion: nil)
            } else if (localPlayer.authenticated) {
                println("Local player already authenticated")
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler({ (leaderboardIdentifer: String!, error: NSError!) -> Void in
                    if error != nil {
                        println(error)
                    } else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer
                    }
                })
                
                
            } else {
                self.gcEnabled = false
                println("Local player could not be authenticated, disabling game center")
                println(error)
            }
            
        }
        
        
    }

    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        
            gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func showLeaderboard(sender: UIButton) {
        var gcVC: GKGameCenterViewController = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = GKGameCenterViewControllerState.Leaderboards
        gcVC.leaderboardIdentifier = "LeaderboardID"
        self.presentViewController(gcVC, animated: true, completion: nil)

    }

    @IBAction func submitScore(sender: UIButton) {
        var leaderboardID = "LeaderboardID"
        var sScore = GKScore(leaderboardIdentifier: leaderboardID)
        sScore.value = Int64(score)
        
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        GKScore.reportScores([sScore], withCompletionHandler: { (error: NSError!) -> Void in
            if error != nil {
               println(error.localizedDescription)
            } else {
                 println("Score submitted")
                
            }
        })
        
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblScore.text = "\(score)"
        self.authenticateLocalPlayer()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func PlusOne(sender: UIButton) {
        score++
        lblScore.text = "\(score)"
        
    }

    @IBAction func MinusOne(sender: UIButton) {
        score--
        lblScore.text = "\(score)"
    }
}

