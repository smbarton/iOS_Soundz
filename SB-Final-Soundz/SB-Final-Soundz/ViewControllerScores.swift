//
//  ViewControllerScores.swift
//  SB-Final-Soundz
//
//  Created by Shane on 11/19/16.
//  Copyright © 2016 ssd. All rights reserved.
//

import UIKit

//struct to hold information in an array for data manipulation
struct HighScorer {
    var name = ""
    var difficulty = ""
    var score = 0
}

class ViewControllerScores: UIViewController {
    
    //how many scores to keep
    let scoresTotal = 5
    var hiScores = [HighScorer]()   //array of structs

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initializeScoreArray()
        view.backgroundColor = .white
        
        initializeNavBars()
        setScoreArray()
        displayScores()
        createLabels()
        
    }
    
    //creates the nav bar and tool bar
    func initializeNavBars() {
        navigationItem.title = "High Scores"
        
        //Nav Bar Items
        let navBack = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(forceBack))
        
        //Tool Bar Items
        let tbMenu = UIBarButtonItem(title: "Main Menu", style: .plain, target: self, action: #selector(viewMenu))
        
        
        //navigationItem.setRightBarButton(navScores, animated: true)
        navigationItem.setLeftBarButton(navBack, animated: true)
        
        toolbarItems = [tbMenu]
    }
    
    //sets the array to a default HighScorer() in order to manipulate array without all the scores yet
    func initializeScoreArray() {
        for i in 0...scoresTotal-1 {
            print("hiscore now in \(i)")
            let defScore = HighScorer()
            hiScores.append(defScore)
        }
    }
    
    func setScoreArray() {
        
        let defaults = UserDefaults.standard
        
        for i in 1...scoresTotal {
            
            //sets the scores to user defaults or sets a default HighScorer() into the defaults
            if let score = defaults.object(forKey: "score0\(i)") {
                let name = defaults.object(forKey: "name0\(i)")
                let diff = defaults.object(forKey: "diff0\(i)")
                hiScores[i-1].score = score as! Int
                hiScores[i-1].name = name as! String
                hiScores[i-1].difficulty = diff as! String
            } else {
                defaults.set("", forKey: "name0\(i)")
                defaults.set(0, forKey: "score0\(i)")
                defaults.set("", forKey: "diff0\(i)")
            }
        }
    }
    
    //creates labels for the high score categories
    func createLabels() {
        let bnds = view.bounds
        let lblHeight = bnds.height/20
        let lblFontSize = 20
        
        let rankLblSize = CGSize(width: bnds.width/12, height: lblHeight)
        let scoreLblSize = CGSize(width: bnds.width/10, height: lblHeight)
        let nameLblSize = CGSize(width: bnds.width/7, height: lblHeight)
        let diffLblSize = CGSize(width: bnds.width/8, height: lblHeight)
        
        let xGap = bnds.width/10
        let yGap = bnds.height/10
        
        var xOffset = xGap
        var yOffset = yGap
        
        //RANKS
        let rankLbl = UILabel(frame: CGRect(x: xOffset, y: yOffset, width: rankLblSize.width, height: lblHeight))
            rankLbl.text = "Rank"
//            rankLbl.font = UIFont(name: rankLbl.font.fontName, size: CGFloat(lblFontSize))
            rankLbl.textAlignment = .center
            rankLbl.adjustsFontSizeToFitWidth = true
        view.addSubview(rankLbl)
        
        var tempXOffset = xOffset
        var tempYOffset = yOffset + yGap
        
        //individual ranks
        for i in 0...scoresTotal-1 {
            
            let lbl = UILabel(frame: CGRect(x: tempXOffset, y: tempYOffset, width: nameLblSize.width, height: lblHeight))
            print(hiScores[i].name)
            lbl.text = "\(i+1)"
//            lbl.font = UIFont(name: lbl.font.fontName, size: CGFloat(lblFontSize))
            lbl.adjustsFontSizeToFitWidth = true
            //lbl.textAlignment = .center
            view.addSubview(lbl)
            
            tempYOffset = tempYOffset + yGap
        }
        
        xOffset = xOffset + rankLblSize.width + xGap
        
        //NAMES
        let nameLbl = UILabel(frame: CGRect(x: xOffset, y: yOffset, width: nameLblSize.width, height: lblHeight))
            nameLbl.text = "Name"
            nameLbl.font = UIFont(name: nameLbl.font.fontName, size: CGFloat(lblFontSize))
            nameLbl.adjustsFontSizeToFitWidth = true
            nameLbl.textAlignment = .center
        view.addSubview(nameLbl)
        
        tempXOffset = xOffset
        tempYOffset = yOffset + yGap
        
        //individual names
        for i in 0...scoresTotal-1 {
            
            let lbl = UILabel(frame: CGRect(x: tempXOffset, y: tempYOffset, width: nameLblSize.width, height: lblHeight))
            print(hiScores[i].name)
            lbl.text = hiScores[i].name
            lbl.adjustsFontSizeToFitWidth = true
            view.addSubview(lbl)
            
            tempYOffset = tempYOffset + yGap
        }
        
        xOffset = xOffset + nameLblSize.width + xGap
        
        //DIFFICULTIES
        let diffLbl = UILabel(frame: CGRect(x: xOffset, y: yOffset, width: diffLblSize.width, height: lblHeight))
            diffLbl.text = "Difficulty"
            diffLbl.adjustsFontSizeToFitWidth = true
            diffLbl.textAlignment = .center
        view.addSubview(diffLbl)
        
        tempXOffset = xOffset
        tempYOffset = yOffset + yGap
        
        //individual difficulties
        for i in 0...scoresTotal-1 {
            
            let lbl = UILabel(frame: CGRect(x: tempXOffset, y: tempYOffset, width: diffLblSize.width, height: lblHeight))
            lbl.text = hiScores[i].difficulty
            lbl.adjustsFontSizeToFitWidth = true
            view.addSubview(lbl)
            
            tempYOffset = tempYOffset + yGap
        }
        
        xOffset = xOffset + diffLblSize.width + yGap
        
        //SCORES
        let scoreLbl = UILabel(frame: CGRect(x: xOffset, y: yOffset, width: scoreLblSize.width, height: lblHeight))
            scoreLbl.text = "Score"
            scoreLbl.adjustsFontSizeToFitWidth = true
            scoreLbl.textAlignment = .center
        view.addSubview(scoreLbl)
        
        tempXOffset = xOffset
        tempYOffset = yOffset + yGap
        
        //individual scores
        for i in 0...scoresTotal-1 {
            
            let lbl = UILabel(frame: CGRect(x: tempXOffset, y: tempYOffset, width: diffLblSize.width, height: lblHeight))
            lbl.text = "\(hiScores[i].score)"
            lbl.adjustsFontSizeToFitWidth = true
            view.addSubview(lbl)
            
            tempYOffset = tempYOffset + yGap
        }
        
        xOffset = xGap
        yOffset = yGap
        
    }
    
    //shows the scores by sorting the array by score and creating the labels
    func displayScores() {
        if hiScores.count == 0 {
            print("No high scores...")
        } else {
            sortScoresArray()
            createLabels()
        }
        
    
    }
    
    //sets a new high score int the leaderboard
    func loadNewScore(name:String, score:Int, difficulty:String) {
        let defaults = UserDefaults.standard
        
        hiScores[4].name = name
        hiScores[4].score = score
        hiScores[4].difficulty = difficulty
        
        defaults.set(hiScores[4].name, forKey: "name05")
        defaults.set(hiScores[4].score, forKey: "score05")
        defaults.set(hiScores[4].difficulty, forKey: "diff05")
        
        sortScoresArray()
    }
    
    func sortScoresArray() {
        hiScores.sort{$0.score > $1.score}  //sorts the array in ascending order
        
        let defaults = UserDefaults.standard
        
        for i in 1...scoresTotal {
            defaults.set(hiScores[i-1].name, forKey: "name0\(i)")
            defaults.set(hiScores[i-1].score, forKey: "score0\(i)")
            defaults.set(hiScores[i-1].difficulty, forKey: "diff0\(i)")
        }
        
    }
    
    //goes back to previous screen
    func forceBack() {
        navigationController?.popViewController(animated: true)
    }
    
    //goes to the main menu
    func viewMenu() {
        let nextVC = ViewControllerMenu()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //when the view will appear, it displays the scores
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isToolbarHidden = false
        displayScores()
    }
    
    //Starts to slide
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    //Leaves Screen - returns the toolbar to view
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.isToolbarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
