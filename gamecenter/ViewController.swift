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
                // 1 Show login if player is not logged in
                self.presentViewController(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.authenticated) {
                // 2 Player is already euthenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler({ (leaderboardIdentifer: String?, error: NSError?) -> Void in
                    if error != nil {
                        print(error)
                    } else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                    }
                })
                
                
            } else {
                // 3 Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated, disabling game center")
                print(error)
            }
            
        }
        
    }

    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
            gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func showLeaderboard(sender: UIButton) {
        let gcVC: GKGameCenterViewController = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = GKGameCenterViewControllerState.Leaderboards
        gcVC.leaderboardIdentifier = "LeaderboardID"
        self.presentViewController(gcVC, animated: true, completion: nil)
    }

    @IBAction func submitScore(sender: UIButton) {
        let leaderboardID = "LeaderboardID"
        let sScore = GKScore(leaderboardIdentifier: leaderboardID)
        sScore.value = Int64(score)
        
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        GKScore.reportScores([sScore], withCompletionHandler: { (error: NSError?) -> Void in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Score submitted")
                
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

