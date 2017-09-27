//
//  ViewControllerGame.swift
//  SB-Final-Soundz
//
//  Created by Shane on 11/19/16.
//  Copyright © 2016 ssd. All rights reserved.
//

import UIKit
import AVFoundation

class ViewControllerGame: UIViewController {
    
    //class variables
    var isGameStarted = Bool() //a status check for if the game is running
    var incorrectAudio = AVAudioPlayer()    //audio player for gameover sound
    var correctAudio = AVAudioPlayer()
    var audioPlayerArray = [AVAudioPlayer]()    //array of audio players to be filled later
    var currentSoundTag = Int() //the tag of the current button/sound
    var chosenSoundTag = Int()  //the tag of the button the user has chosen
    var btnCount = Int()    //counts how many buttons need to be placed according to difficulty
    var gameScore = Int()   //the player's score
    
    var scoreLabel = UILabel()  //display for the player score
    
    var difficultyStr = String()    //the difficulty will be read to this from user defaults
    
    let scoreEnterer = ViewControllerScores()   //uses a view controller to access the score array functions
    
    var lowestScore = Int() //this is the lowest score of the array
    
    var delayTimer = Timer()
    var gameTimer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //initializes the score array
        scoreEnterer.initializeScoreArray()
        
        //sets the game state to false
        isGameStarted = false
        
        view.backgroundColor = .white
        
        let defaults = UserDefaults.standard
        
        //gets the difficulty from user defaults
        difficultyStr = defaults.string(forKey: "difficulty")!
        
        //sets the amount of buttons to generate based on difficulty
        if(difficultyStr == "Easy"){
            btnCount = 4
        } else if (difficultyStr == "Medium") {
            btnCount = 5
        } else {
            btnCount = 6
        }
        
        initializeNavBars()
        createButtons()
        createScoreLabel()
        loadSounds()
    }
    
    //compares the button tag with the current sound tag
    func compareSoundTags(sender:UIButton) {
        let tag = sender.tag-1
        let origColor = sender.backgroundColor
        
        if(tag == currentSoundTag) {    //increments the score and continues the game
            correctAnswer()
        } else {    //calls game over function to end game
            gameOver()
        }
        
    }
    
    func correctAnswer() {
        correctAudio.pause()
        correctAudio.currentTime = 0
        correctAudio.play()
        incrementScore()
        startDelayTimer()
    }
    
    func changeButtonColor(sender:UIButton, color:UIColor) {
        sender.backgroundColor = color
    }
    
    func randomDelay(sender:UIButton) {
        stopDelayTimer()
        randomSound()
        startGameTimer()
    }
    
    func startDelayTimer() {
        delayTimer.invalidate()
        
        delayTimer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.randomDelay), userInfo: nil, repeats: true);
    }
    
    func startGameTimer() {
        gameTimer.invalidate()
        
        gameTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.gameOver), userInfo: nil, repeats: true);
    }
    
    func stopGameTimer() {
        gameTimer.invalidate()
    }
    
    func stopDelayTimer() {
        delayTimer.invalidate()
    }
    
    func playCorrect(){
        
    }
    
    func initializeNavBars(){
        
        navigationItem.title = "Game"
        
        //Nav Bar Items
        let navScores = UIBarButtonItem(title: "High Scores", style: .plain, target: self, action: #selector(viewScores))
        
        let navBack = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(forceBack))
        
        //Tool Bar Items - Start game [spacer] Instruction alert
        let tbStart = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(startGame))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let tbInstruct = UIBarButtonItem(title: "Instructions", style: .plain, target: self, action: #selector(showInstructions))
        
        navigationItem.setRightBarButton(navScores, animated: true)
        navigationItem.setLeftBarButton(navBack, animated: true)
        
        toolbarItems = [tbStart, spacer, tbInstruct]
    }
    
    //displays the instructions in an alert
    func showInstructions() {
        let alert = UIAlertController(title: "Instructions", message: "Press each button to hear its sound. Once you press Start, the game will play a random sound. You have to match that sound with the right button.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //called when user selects wrong button
    func gameOver() {
        scoreLabel.textColor = .red
        incorrectAudio.play()
        stopGameTimer()
        stopDelayTimer()
        resetToolBar()  //brings the toolbar back
        
        //if the current score is higher than the lowest score, the user inputs their name for the scoreboard
        if gameScore > lowestScore {
            typeName()
        }
    }
    
    //when a high score, creates an alert with a text field to type in the user's name
    func typeName() {
        var newName = String()
        let alert = UIAlertController(title: "Congratulations!", message: "You have acheived a high score. Please enter your name.", preferredStyle: .alert)
        
        let gmScore = gameScore
        let diff = difficultyStr
        
        alert.addTextField { (textfield) in
            textfield.text = ""
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {[weak alert](_) in
            let textfield = alert?.textFields![0]
            newName = (textfield?.text)!
            print("New Name: \(newName)")
            
            self.scoreEnterer.initializeScoreArray()
            self.scoreEnterer.setScoreArray()
            //sets the elements into a new score line
            self.scoreEnterer.loadNewScore(name:newName, score:gmScore, difficulty:diff)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //creates the buttons
    func createButtons() {
        let colorArray:[UIColor] = [.red, .blue, .orange, .green, .yellow, .purple]
        
        //ints to keep track of how many buttons go into each column
        var col1 = Int()
        var col2 = Int()
        
        switch (btnCount) {
            case 4:
                col1 = 2
                col2 = 2
                break
            case 5:
                col1 = 3
                col2 = 2
                break
            case 6:
                col1 = 3
                col2 = 3
                break
            default:
                col1 = 2
                col2 = 2
                break
        }
        
        
        //For sizing and placement of buttons
        let bnds = view.bounds
        
        let buttonSize = CGSize(width: bnds.width/3.5, height: bnds.width/3.5)
        
        let yStart = buttonSize.height + buttonSize.height/2
        
        var yOffset = yStart
        var xOffset = buttonSize.width/2
        
        //loop - creates buttons and adds them to the first column
        for index in 0...col1-1 {
            
            let btn = UIButton(frame: CGRect(x: xOffset, y: yOffset, width: buttonSize.width, height: buttonSize.height))
                btn.backgroundColor = colorArray[index]
                btn.tag = index + 1 //Ensures there is no 0 tag
                btn.addTarget(self, action: #selector(btnClicked), for: .touchDown)
            view.addSubview(btn)
            
            yOffset = yOffset + buttonSize.height + buttonSize.height/4
        }
        
        yOffset = yStart
        xOffset = buttonSize.width + buttonSize.width
        
        //loop - creates buttons and adds them to the first column
        for index in col1...btnCount-1 {
            
            let btn = UIButton(frame: CGRect(x: xOffset, y: yOffset, width: buttonSize.width, height: buttonSize.height))
            btn.backgroundColor = colorArray[index]
            btn.tag = index + 1 //Ensures there is no 0 tag
            btn.addTarget(self, action: #selector(btnClicked), for: .touchDown)
            view.addSubview(btn)
            
            yOffset = yOffset + buttonSize.height + buttonSize.height/4
        }
    }
    
    //sets up the score label
    func createScoreLabel() {
        let bnds = view.bounds
        
        let lblSize = CGSize(width: bnds.width/2, height: bnds.width/5)
        
        scoreLabel = UILabel(frame: CGRect(x: bnds.width/2 - lblSize.width/2, y: lblSize.height, width: lblSize.width, height: lblSize.height))
            scoreLabel.text = "Score: \(gameScore)"
            scoreLabel.font = UIFont(name: scoreLabel.font.fontName, size: 40)
            scoreLabel.textAlignment = .center
        view.addSubview(scoreLabel)
    }
    
    //adds one to the score and updates the score label
    func incrementScore() {
        gameScore = gameScore + 1
        scoreLabel.text = "Score: \(gameScore)"
    }
    
    //resets the score and updates the label
    func resetScore() {
        gameScore = 0
        scoreLabel.text = "Score: \(gameScore)"
    }
    
    
    func loadSounds() {
        
        //String array that holds the names of all the sounds
        //var soundNameArray: [String] = ["sound1", "sound2", "sound3", "sound4", "sound5", "03jump"]
        var soundNameArray: [String] = ["01slap", "02shatter", "03jump", "sound1", "05doorbell", "06squeaky"]
        
        //loop - creates audioPlayers and adds them to the audioPlayer array
        for index in 0...5 {
            //Creates an audioPlayer
            var audioPlayer:AVAudioPlayer?
            let path = Bundle.main.path(forResource: soundNameArray[index], ofType: "mp3")
            let sound = URL(fileURLWithPath: path!)
            
            try! audioPlayer = AVAudioPlayer(contentsOf: sound)
            
            audioPlayerArray.append(audioPlayer!)   //adds the audioPlayer to the array
        }
        
        //The incorrect sound buzzer
        var path = Bundle.main.path(forResource: "99wrong", ofType: "mp3")
        var sound = URL(fileURLWithPath: path!)
        
        try! incorrectAudio = AVAudioPlayer(contentsOf: sound)
        
        //The correct sound buzzer
        path = Bundle.main.path(forResource: "99correct", ofType: "mp3")
        sound = URL(fileURLWithPath: path!)
        
        try! correctAudio = AVAudioPlayer(contentsOf: sound)
        correctAudio.volume = 0.25
    }
    
    //runs an if statement depending on if the game is started
    //if not - plays button sound
    //if started - calls teh compare button function
    func btnClicked(sender: UIButton) {
        if (isGameStarted == false){
            playSound(sender:sender)
        } else {
            //changeButtonColor(sender: sender, color: .gray)
            compareSoundTags(sender:sender)
        }
        
    }
    
    //Plays the sound from the selected audioPlayer
    func playSound(sender:UIButton) {
        
        let selected = sender.tag - 1
        
        audioPlayerArray[selected].pause()
        audioPlayerArray[selected].currentTime = 0 //seeks to a particular time
        audioPlayerArray[selected].play()
        
    }
    
    //calls a random sound for the app to play
    func randomSound() {
        currentSoundTag = Int(arc4random_uniform(UInt32(btnCount)))
        
        audioPlayerArray[currentSoundTag].pause()
        audioPlayerArray[currentSoundTag].currentTime = 0 //seeks to a particular time
        audioPlayerArray[currentSoundTag].play()
        
    }
    
    //brings the toolbar back into view
    func resetToolBar() {
        isGameStarted = false
        navigationController?.isToolbarHidden = false
        navigationController?.isNavigationBarHidden = false
    }
    
    //starts the game
    func startGame() {
        let defaults = UserDefaults.standard
        
        //gets the lowest score form the leaderboard for comparison with final score
        if let tempLow = defaults.object(forKey: "score05") as! Int!{
                lowestScore = tempLow
        } else {
            lowestScore = 0
        }
        isGameStarted = true    //sets the game mode to started
        
        //hides the toolbars
        navigationController?.isToolbarHidden = true
        navigationController?.isNavigationBarHidden = true
        scoreLabel.textColor = .black
        resetScore()
        startDelayTimer()
        
        //randomSound()
    }
    
    //loads the high score view
    func viewScores() {
        let nextVC = ViewControllerScores()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //goes back
    func forceBack() {
        navigationController?.popViewController(animated: true)
    }
    
    //shows the toolbars
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isToolbarHidden = false
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
