//
//  ViewControllerMenu.swift
//  SB-Final-Soundz
//
//  Created by Shane on 11/19/16.
//  Copyright © 2016 ssd. All rights reserved.
//

import UIKit

class ViewControllerMenu: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Initializes the Scores Array - 
        //this way it can be checked for high scores even if the score page hasn't been opened
        let defaults = UserDefaults.standard
        ViewControllerScores().initializeScoreArray()
        
        view.backgroundColor = .white
        
        //Check for difficulty settings from previous use
        if let difficulty = defaults.object(forKey: "difficulty"){
            setDifficulty(mode: difficulty as! String)
        } else {
            setDifficulty(mode: "Easy")
        }
        
        createButtons()
        createTitleImage()
        
    }
    
    //loads the title image to a view
    func createTitleImage() {
        let bnds = view.bounds
        let imageSize = CGSize(width: bnds.width - bnds.width/8, height: bnds.height/4)
        
        let titleImg = UIImage(named:"Soundz_TitleScreen")
        let titleView = UIImageView(frame: CGRect(x: bnds.width/16, y: bnds.height/8, width: imageSize.width, height: imageSize.height))
        titleView.image = titleImg
        view.addSubview(titleView)
        
    }
    
    //creates the buttons for the menu
    func createButtons() {
        print("Buttons creating...")
        let defaults = UserDefaults.standard
        
        let bnds = view.bounds
        
        let buttonSize = CGSize(width: bnds.width/2, height: bnds.height/10)
        
        let startY = bnds.height/2
        var yOffset = buttonSize.height + buttonSize.height/4
        
        let btnMode = UIButton(frame: CGRect(x: bnds.width/2 - buttonSize.width/2, y: startY, width: buttonSize.width, height: buttonSize.height))
            btnMode.backgroundColor = .black
            btnMode.setTitle("Difficulty: " + defaults.string(forKey: "difficulty")!, for: .normal)
            btnMode.setTitleColor(.white, for: .normal)
            btnMode.addTarget(self, action: #selector(toggleDifficulty), for: .touchDown)
        view.addSubview(btnMode)
        
        yOffset = yOffset+startY
        
        let btnScores = UIButton(frame: CGRect(x: bnds.width/2 - buttonSize.width/2, y: yOffset, width: buttonSize.width, height: buttonSize.height))
            btnScores.backgroundColor = .black
            btnScores.setTitle("High Scores", for: .normal)
            btnScores.setTitleColor(.white, for: .normal)
            btnScores.addTarget(self, action: #selector(viewHighScores), for: .touchDown)
        view.addSubview(btnScores)
        
        yOffset = yOffset+buttonSize.height*1.5
        
        let btnStart = UIButton(frame: CGRect(x: bnds.width/2 - ((buttonSize.width/2)*1.5), y: yOffset, width: buttonSize.width*1.5, height: buttonSize.height*1.25))
            btnStart.backgroundColor = .black
            btnStart.setTitle("Start", for: .normal)
            btnStart.setTitleColor(.white, for: .normal)
            btnStart.addTarget(self, action: #selector(viewGame), for: .touchDown)
        view.addSubview(btnStart)
        
        print("Buttons created...")
    }
    
    //pressing the difficulty button will toggle the difficulty between three choices
    func toggleDifficulty(sender:UIButton) {
        print("toggleDifficulty()")
        
        let defaults = UserDefaults.standard
        var difficulty = String()
        difficulty = defaults.object(forKey: "difficulty") as! String
        
        
        switch (difficulty) {
            case "Easy":
                difficulty = "Medium"
                break
            case "Medium":
                difficulty = "Hard"
                break
            case "Hard":
                difficulty = "Easy"
                break
            default:
                difficulty = "N/A"
                break
        }
        
        setDifficulty(mode: difficulty)
        
        //displays the difficulty on the button
        sender.setTitle("Difficulty: " + difficulty, for: .normal)
        
    }
    
    //sets the difficulty to the user defaults
    func setDifficulty(mode:String) {
        
        let defaults = UserDefaults.standard
        
        defaults.set(mode, forKey: "difficulty")
        
    }
    
    //opens the high score screen
    func viewHighScores(sender:UIButton) {
        print("viewHighScores()")
        let nextVC = ViewControllerScores()
        navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    //opens the game screen
    func viewGame(sender: UIButton) {
        print("viewGame()")
        
        let nextVC = ViewControllerGame()
        navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    
    //Hides the toolbar when this view loads
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isToolbarHidden = true
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.isToolbarHidden = true
        navigationController?.isNavigationBarHidden = true
    }
    
    //Starts to slide
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    //Leaves Screen - returns the toolbar to view
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.isToolbarHidden = false
        navigationController?.isNavigationBarHidden = false
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
