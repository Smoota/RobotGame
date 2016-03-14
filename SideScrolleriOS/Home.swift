//
//  Home.swift
//
//
//  Created by Justin Dike 2 on 10/6/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
//

import SpriteKit
import GameController
import AVFoundation.AVAudioSession

import GameKit



class Home: SKScene, GKGameCenterControllerDelegate {
    
    
    var enableGameCenter:Bool = false
    var canSelect:Bool = true 
    var selectionOrder = [Button]()
    var selectedIndex:Int = -1
    var maxIndex:Int = -1
    var selectionColumns:Int = 1
    var selectedButton:Button?
    
    var highScore:Int = 0
  
    var bgSoundPlaying:Bool = false
    
    var wrapAroundSelection:Bool = true
    
    var playerIndexInUse1:Bool = false
    var playerIndexInUse2:Bool = false
    
    var singlePlayerGame:Bool = true // 
    var player2NotInUse:Bool = false
    var playerVersusPlayer:Bool = false
    
    var currentLevel:Int = 0
    var sksNameToLoad:String = "Level1"  //refers to the .sks file that will get loaded for the GameScene class
    var propertyListData:String = "Home" // refers to the name of the dictionary to look up in the property list. By default is "Home" but will get overridden when a new Home scene is created. This should match the SKS file's base name, for example when loading Home.sks, this value should be "Home"    
    
   
    
    var newGameLocation:CGPoint = CGPointZero
    var chooseLocation:CGPoint = CGPointZero
    
    var transitionInProgress:Bool = true

    let tapGeneralSelection = UITapGestureRecognizer()
  
    
    let swipeUp = UISwipeGestureRecognizer()
    let swipeDown = UISwipeGestureRecognizer()
    let swipeRight = UISwipeGestureRecognizer()
    let swipeLeft = UISwipeGestureRecognizer()

    var defaults:NSUserDefaults =  NSUserDefaults.standardUserDefaults()
    
    var highScoreLabel:SKLabelNode = SKLabelNode()
     var leaderBoardID:String = "HighScore" // will change based on property list
    
    var continueGame:Bool = false
    
    var allowGCtoShow:Bool = true
    var allowScorePosting:Bool = true
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
         try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        
        
        
            
        highScore = defaults.integerForKey("HighScore")
            
        
        checkToSeeIfGameCenterShouldBeEnabled()
        
        if (enableGameCenter == true){
            
            print("Game center will be enabled")
        }
        
        parsePropertyList()
        
        
        if ( Helpers.loggedIntoGC == true){
            
            saveHighScore(leaderBoardID, score: highScore)
            
        }
        
        
        
        self.enumerateChildNodesWithName("//*") {
            node, stop in

            if let someButton:Button = node as? Button {
                
                someButton.createButton()
               
            }
            
            if (node.name == "HighScore"){
                
                if let label:SKLabelNode = node as? SKLabelNode{
                    
                    self.highScoreLabel = label
                    
                    self.highScoreLabel.text = "High Score: " + String(self.highScore)
                    
                }
                
                
            }
            
            
        }
        
        if ( selectionOrder.count > 0){
        
            selectedIndex = 0
            selectedButton = selectionOrder[selectedIndex]
            selectedButton?.select()
            
            maxIndex = selectionOrder.count - 1
            
        }
        
        
        
       setUpControllerObservers()
       connectControllers()
        
        
        
        tapGeneralSelection.addTarget(self, action: "pressedSelect")
        tapGeneralSelection.numberOfTapsRequired = 1
        tapGeneralSelection.numberOfTouchesRequired = 1
        self.view!.addGestureRecognizer(tapGeneralSelection)
        
        
        swipeRight.addTarget(self, action: "swipedRight")
        swipeRight.direction = .Right
        self.view!.addGestureRecognizer(swipeRight)
        
        swipeLeft.addTarget(self, action: "swipedLeft")
        swipeLeft.direction = .Left
        self.view!.addGestureRecognizer(swipeLeft)
        
        swipeUp.addTarget(self, action: "swipedUp")
        swipeUp.direction = .Up
        self.view!.addGestureRecognizer(swipeUp)
        
        swipeDown.addTarget(self, action: "swipedDown")
        swipeDown.direction = .Down
        self.view!.addGestureRecognizer(swipeDown)
        

        
        let wait:SKAction = SKAction.waitForDuration(1)
        let run:SKAction = SKAction.runBlock {
            
            
            self.transitionInProgress = false;
           
        }
        
        let seq:SKAction = SKAction.sequence([wait, run])
        self.runAction(seq)
        
      
    }
    
    
    func checkToSeeIfGameCenterShouldBeEnabled(){
        
        
        
        let path = NSBundle.mainBundle().pathForResource("LevelData", ofType: "plist")
        
        let dict:NSDictionary = NSDictionary(contentsOfFile: path!)!
        
        if (dict.objectForKey("EnableGameCenter") != nil) {
            
            if (dict.objectForKey("EnableGameCenter") is Bool){
                
                enableGameCenter = dict.objectForKey("EnableGameCenter") as! Bool
                
                
                if (dict.objectForKey("LeaderBoardID") != nil  && enableGameCenter == true) {
                    
                    if (dict.objectForKey("LeaderBoardID") is String){
                        
                        leaderBoardID = dict.objectForKey("LeaderBoardID") as! String
                        
                        print("will post scores to leaderboard with ID \(leaderBoardID)")
                        
                    }
                }
                
            }
            
            
        }
        
    }
    
    
    
    func parsePropertyList(){
   
    
        let path = NSBundle.mainBundle().pathForResource("LevelData", ofType: "plist")
    
        let dict:NSDictionary = NSDictionary(contentsOfFile: path!)!
    
        if (dict.objectForKey(propertyListData) != nil) {
    
            if let homeDict:[String : AnyObject] = dict.objectForKey(propertyListData) as? [String : AnyObject] {
            
                for (theKey, theValue) in homeDict {
                    
                    if (theKey == "Buttons") {
                        
                        
                         if let buttonDict:[String : AnyObject] = theValue as? [String : AnyObject] {
                            
                            for (buttonKey, buttonValue) in buttonDict {
                                
                                if (self.childNodeWithName(buttonKey) != nil){
                                    
                                    if let someButton:Button = self.childNodeWithName(buttonKey) as? Button {
                                        
                                        if let someButtonDict:[String : AnyObject] = buttonValue as? [String : AnyObject] {
                                            
                                            
                                            for (someButtonKey, someButtonValue) in someButtonDict {
                                            
                                                if (someButtonKey == "PlayerVersusPlayer") {
                                                    
                                                    if (someButtonValue is Bool){
                                                        
                                                        someButton.playerVersusPlayer = someButtonValue as! Bool
                                                        
                                                        
                                                    }

                                                    
                                                }
                                                else if (someButtonKey == "ReportHighScore") {
                                                    
                                                    if (someButtonValue is Bool){
                                                        
                                                        someButton.reportHighScore = someButtonValue as! Bool
                                                        
                                                        
                                                        if ( Helpers.loggedIntoGC == false && enableGameCenter == true ){
                                                            
                                                            authenticateLocalPlayer()
                                                        }
                                                        
                                                    }
                                                    
                                                    
                                                }
                                                else if (someButtonKey == "ShowGameCenter") {
                                                    
                                                    if (someButtonValue is Bool){
                                                        
                                                        someButton.showGameCenter = someButtonValue as! Bool
                                                       
                                                        
                                                        if ( Helpers.loggedIntoGC == false && enableGameCenter == true ){
                                                            
                                                            authenticateLocalPlayer()
                                                        }
                                                        
                                                    }
                                                    
                                                    
                                                }
                                                else if (someButtonKey == "LoadScene") {
                                                    
                                                    if (someButtonValue is String){
                                                        
                                                        someButton.loadHomeScene = someButtonValue as! String
                                                        
                                                        
                                                    }
                                                    
                                                    
                                                }
                                                else if (someButtonKey == "LoadScene") {
                                                    
                                                    if (someButtonValue is String){
                                                        
                                                        someButton.loadHomeScene = someButtonValue as! String
                                                        
                                                        
                                                    }
                                                    
                                                    
                                                }
                                                else if (someButtonKey == "LevelToLoad") {
                                                    
                                                    if (someButtonValue is Int){
                                                        
                                                        someButton.levelToLoad = someButtonValue as! Int
                                                        
                                                        
                                                    }

                                                    
                                                }
                                                else if (someButtonKey == "ContinueLastGame") {
                                                    
                                                    if (someButtonValue is Bool){


                                                        
                                                        if ( defaults.boolForKey("GameCanHaveContinueButton") == false ){
                                                            
                                                            print ("no continue point")
                                                            
                                                            someButton.alpha = 0.65
                                                            someButton.continueLastLevel = someButtonValue as! Bool
                                                            someButton.levelToLoad = 1
                                                            
                                                        } else {
                                                            
                                                            someButton.continueLastLevel = someButtonValue as! Bool
                                                            someButton.levelToLoad = defaults.integerForKey("LastLevel")
                                                            
                                                        }
                                                        
                                                    }
                                                    
                                                    
                                                }
                                                else if (someButtonKey == "SinglePlayerGame") {
                                                    
                                                    if (someButtonValue is Bool){
                                                        
                                                        someButton.singlePlayerGame = someButtonValue as! Bool
                                                       
                                                        
                                                    }
                                                    
                                                    
                                                    
                                                }
                                                else if (someButtonKey == "Levels") {
                                                    
                                                    if (someButtonValue is String){
                                                        
                                                        someButton.levelsName = someButtonValue as! String
                                                        
                                                        
                                                    }
                                                    
                                                    
                                                    
                                                }
                                                else if (someButtonKey == "DisableIfNotReached") {
                                                    
                                                    if (someButtonValue is Bool){
                                                        
                                                        someButton.disableIfNotReached = someButtonValue as! Bool
                                                        
                                                        
                                                        
                                                    }
                                                    
                                                    
                                                    
                                                }
                                                else if (someButtonKey == "SecondPlayerIsCPU") {
                                                    
                                                    if (someButtonValue is Bool){
                                                        
                                                        someButton.secondPlayerIsCPU = someButtonValue as! Bool
                                                        
                                                        
                                                    }
                                                    
                                                }
                                                else if (someButtonKey == "SelectedImage") {
                                                    
                                                    if (someButtonValue is String){
                                                        
                                                        someButton.selectedImage = someButtonValue as! String
                                                        
                                                        
                                                    }
                                                    
                                                }
                                                else if (someButtonKey == "SoundButtonSelect") {
                                                    
                                                    if (someButtonValue is String){
                                                        
                                                        someButton.soundButtonSelect = someButtonValue as! String
                                                        
                                                        
                                                    }
                                                    
                                                }
                                                else if (someButtonKey == "SoundButtonPress") {
                                                    
                                                    if (someButtonValue is String){
                                                        
                                                        someButton.soundButtonPress = someButtonValue as! String
                                                        
                                                        
                                                    }
                                                    
                                                }
                                                
                                            }
                                        
                                        }
                                        
                                    }
                                    
                                }
                                
                                
                                
                            }
                            
                            
                        }
                        
                        
                        
                    } else if (theKey == "Columns") {
                        
                        
                        if (theValue is Int){
                            
                            selectionColumns = theValue as! Int
                            
                            
                        }
                        
                        
                    } else if (theKey == "MP3Loop") {
                        
                        
                        if (theValue is String){
                            
                            
                            
                            let theFileName:String  = theValue as! String
                            let theFileNameWithNoMp3:String  = theFileName.stringByReplacingOccurrencesOfString(".mp3", withString: "", options:NSStringCompareOptions.CaseInsensitiveSearch , range: nil)
                            
                            
                            
                            let dictToSend: [String: String] = ["fileToPlay":theFileNameWithNoMp3 ]
                            
                            NSNotificationCenter.defaultCenter().postNotificationName("PlayBackgroundSound", object: self, userInfo:dictToSend)
                            
                            bgSoundPlaying = true
                            
                        }
                        
                        
                    } else if (theKey == "IntroSound") {
                        
                        
                        if (theValue is String){
                            
                            
                            playSound(theValue as! String)
                            
                        }
                        
                        
                    } else if (theKey == "SelectionOrder") {
                        
                        if let someArray:[String] = theValue as? [String] {
                            
                            for item in someArray {
                                
                                if (self.childNodeWithName(item) != nil){
                                    
                                    if let someButton:Button = self.childNodeWithName(item) as? Button {
                                        
                                        selectionOrder.append(someButton)
                                        
                                    }
                                    
                                }
                                
                                
                                
                            }
                            
                            
                        }
                        
                        
                    }
                    
                    
                }
    
            }
    
    
        }
    }
    
    
    func changeSelectionWithDirection(type:Direction ){
        
        
        
        if (selectedIndex == -1){
            
            selectedIndex = 0
            selectButton (selectedIndex)
        }
            
            
        else if ( type == Direction.Up){
            
            
            
            if (selectionColumns > 1){
                
                selectedIndex = selectedIndex - selectionColumns
                
                
                
                if (selectedIndex <= -1){
                    
                    if ( wrapAroundSelection == true){
                        
                        selectedIndex = maxIndex
                        
                    } else {
                        //set it back to what it was
                        
                        selectedIndex = selectedIndex + selectionColumns
                    }
                }
                
               
                
                selectButton(selectedIndex)
                
            } else {
                
                changeSelectionWithDirection(Direction.Left )
                
            }
            
            
            
            
        } else if ( type == Direction.Left){
            
           
            
            selectedIndex = selectedIndex - 1
            
            if (selectedIndex <= -1){
                
                if ( wrapAroundSelection == true){
                    
                    selectedIndex = maxIndex
                    
                } else {
                    //set it back to what it was
                    selectedIndex = selectedIndex + 1
                }
            }
            
           
            
            selectButton(selectedIndex)
            
        }
        else if ( type == Direction.Right){
            
           
            
            selectedIndex = selectedIndex + 1
            
           
            
            if (selectedIndex > maxIndex){
                
                if ( wrapAroundSelection == true){
                    
                    selectedIndex = 0
                    
                } else {
                    //set it back to what it was
                    selectedIndex = selectedIndex - 1
                    
                }
            }
            
            
            selectButton(selectedIndex)
            
        }
        else if ( type == Direction.Down){
            
            
            
            if (selectionColumns > 1){
                
                
                selectedIndex = selectedIndex + selectionColumns
                
                
                
                if (selectedIndex > maxIndex){
                    
                    if ( wrapAroundSelection == true){
                        
                        
                        selectedIndex = 0
                        
                    }  else {
                        //set it back to what it was
                        selectedIndex = selectedIndex - selectionColumns
                    }
                    
                }
                
                
                
                selectButton(selectedIndex)
                
                
            } else {
                
                changeSelectionWithDirection(Direction.Right )
                
            }
            
        }
        
        
    }
    
    
    func selectButton(theIndex:Int){
        
        
        
        var counter:Int = 0
        
        for element in selectionOrder{
            
            if (counter == theIndex) {
                
                
                selectedButton?.deselect()
                
                selectedButton!.position = CGPointMake(selectedButton!.position.x, selectedButton!.position.y - 5)
                
                selectedButton = element
                
                
                selectedButton!.select()
                
                selectedButton!.position = CGPointMake(selectedButton!.position.x, selectedButton!.position.y + 5)
                
                break
                
            }
            
            counter++
            
        }
        
        
    }
    
    
    
    
    
    func pressedSelect(){
        
        
        
        
         if ( transitionInProgress == false) {
      
        if (selectedButton?.continueLastLevel == true && defaults.boolForKey("GameCanHaveContinueButton") == false){
            
            // do nothing
            
            
        } else if (selectedButton?.isDisabled == true ){
            
            // do nothing
            
            
        } else if (selectedButton?.loadHomeScene != ""){
            
            loadHomeScene((selectedButton?.loadHomeScene)! )
            
            
        } else if (selectedButton?.reportHighScore == true){
            
           
              saveHighScore(leaderBoardID, score: self.highScore)
            
            
            
        } else if (selectedButton?.showGameCenter == true){
            
            // do nothing
            if (allowGCtoShow == true){
                
                //allowGCtoShow prevents double opening the window
                
                allowGCtoShow = false
                
                if (Helpers.loggedIntoGC == true){
                
                    showGameCenter()
                    
                } else {
                    
                    if (  enableGameCenter == true ){
                    
                        authenticateLocalPlayer()
                        
                    }
                }
               
                
            }
            
            
        } else {
        
        
        
           
        

                transitionInProgress = true
        
                loadGame()
        
            
            
            
        }
            
        }
    }
    
    func loadGame(){
        
        
        print("will load game")
        
        defaults.setInteger(4, forKey: "HeartsPlayer1")
        defaults.setInteger(4, forKey: "HeartsPlayer2")
        
        defaults.setInteger(0, forKey: "WinCount1")
        defaults.setInteger(0, forKey: "WinCount2")
        
        defaults.setInteger(0, forKey: "ScorePlayer1")
        defaults.setInteger(0, forKey: "ScorePlayer2")
        
        
        defaults.setInteger(0, forKey: "BulletCountPlayer1")
        defaults.setInteger(0, forKey: "BulletCountPlayer2")
        
        //for testing force a specific level
        //defaults.setInteger(1, forKey: "LastLevel")
        
        
        var levelsName:String = "Levels"
        
        if (selectedButton?.continueLastLevel == true){
            
            //Continueing Game
            
            continueGame = true
            
            if ( defaults.objectForKey("LevelsName") != nil){
                
                //LevelsName is the array containing all the Levels to use for this game.

                levelsName = defaults.objectForKey("LevelsName") as! String
                
                
            } else {
                
                levelsName = (selectedButton?.levelsName)!
                
                if ( selectedButton?.playerVersusPlayer == false) {
                
                    //don't save the LevelsName for PVP games, as they are intended more for "one off" battles and not part of a campaign mode.
                    
                    defaults.setObject(levelsName, forKey: "LevelsName")
                    
                }
            }
            
            
            if (defaults.integerForKey("LastLevel") != 0) {
                
                
                currentLevel = defaults.integerForKey("LastLevel")
                sksNameToLoad = Helpers.parsePropertyListForLevelToLoad(currentLevel, levelsName:levelsName)
                
            } else {
                
                currentLevel = 1
                sksNameToLoad = Helpers.parsePropertyListForLevelToLoad(currentLevel, levelsName:levelsName)
                defaults.setInteger(currentLevel, forKey: "LastLevel")
                
            }

            
            
        } else {
            
            //Not continueing game, starting a new one.
            
            levelsName = (selectedButton?.levelsName)!
           
            
            if ( selectedButton?.playerVersusPlayer == false) {
                
                //don't save the LevelsName for PVP games, as they are intended more for "one off" battles and not part of a campaign mode.
                
                defaults.setObject(levelsName, forKey: "LevelsName")
                
            }
            
            
            continueGame = false
            
            currentLevel = (selectedButton?.levelToLoad)!
            
            if (currentLevel == 0){
                
                currentLevel = 1
            }
            
            sksNameToLoad = Helpers.parsePropertyListForLevelToLoad(currentLevel, levelsName:levelsName)
           
            
        }
        
        
        
        
        
        cleanUpScene()
        
        
        var isMadeForPad:Bool = false
        var fullSKSNameToLoad:String = sksNameToLoad
        
        
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad ){
            
            if let _ = GameScene(fileNamed: sksNameToLoad + "Pad") {
                
                fullSKSNameToLoad = sksNameToLoad + "Pad"
                isMadeForPad = true
            }
        } else  if (UIDevice.currentDevice().userInterfaceIdiom == .Phone ){
            
            if let _ = GameScene(fileNamed: sksNameToLoad + "Phone") {
                
                fullSKSNameToLoad = sksNameToLoad + "Phone"
                
            }
        }
        
        
        
        
        
        if let scene = GameScene(fileNamed: fullSKSNameToLoad) {
            
             scene.levelsName = levelsName
            
            defaults.setBool(true, forKey: "GameCanHaveContinueButton")
            
            if ( isMadeForPad == false){
                
                if (UIDevice.currentDevice().userInterfaceIdiom == .Pad ){
                     //adjustments will be made in the scene to account for Aspect Fit deing used
                    scene.scaleMode = .AspectFill
                    
                    
                } else {
                    //preferred Aspect Mode for scenes sized for their device
                    scene.scaleMode = .AspectFill
                }
                
                
            } else if ( isMadeForPad == true){
                 //preferred Aspect Mode for scenes sized for their device
                scene.scaleMode = .AspectFill
                scene.isMadeForPad = true
            }
            
            
            
            
            
           
            print("loading SKS File \(sksNameToLoad)")
            
            scene.currentLevel = currentLevel
            
            
             playSound((selectedButton?.soundButtonPress)!)
            
            
            if ( continueGame == true) {
                
                print("continuing game settings from before")
                
                scene.playerVersusPlayer = defaults.boolForKey("PlayerVersusPlayer")
                scene.singlePlayerGame = defaults.boolForKey("SinglePlayerGame")
                scene.player2NotInUse = defaults.boolForKey("Player2NotInUse")
                scene.levelsPassed = defaults.integerForKey("LevelsPassed")
                
                if (scene.levelsPassed <= 0){
                    //make sure this isn't 0 
                    
                    scene.levelsPassed = 1
                    defaults.setInteger(1, forKey: "LevelsPassed")
                }
                
                
            } else {
                
               
                
            
            // game is not continued

            if ( (selectedButton?.singlePlayerGame)! == true ){
                
                //is a single player game
                
                scene.singlePlayerGame = true
                
                
                
                print("single player game")
                
                if  (  (selectedButton?.secondPlayerIsCPU)!  == true ){
                    

                    scene.player2NotInUse = false
                    
                    
                    
                    print("player 2 stays in game as CPU")
                    
                } else  if  (  (selectedButton?.secondPlayerIsCPU)!  == false ){
                    
                     // user does not want to play co-op with CPU second player
                    
                    scene.player2NotInUse = true
                    
                   
                     print("will remove player 2")
                    
                }
                
                
            } else {
                
                //is a two player game
                
                scene.singlePlayerGame = false
                
                
                
                 print("2 Player game")
                
                
            }
            
            

           
            
            if ( (selectedButton?.playerVersusPlayer)! == true ) {
                
                
                scene.playerVersusPlayer = true
                
                
                
                 print("Player vs Player Game")
                
            } else {
                
                scene.playerVersusPlayer = false
                
                
                
                print("Is Not Versus Game")
            }
                
                
            } //ends else for continue game
            
           
            
            
            defaults.setBool(scene.player2NotInUse, forKey: "Player2NotInUse")
            defaults.setBool(scene.singlePlayerGame, forKey: "SinglePlayerGame")
            defaults.setBool(scene.playerVersusPlayer, forKey: "PlayerVersusPlayer")
            
            defaults.synchronize()
            
            self.view?.presentScene(scene, transition: SKTransition.fadeWithColor(SKColor.whiteColor(), duration: 2) )
            
        }
        
        
        
    }
    
   
    func cleanUpScene(){
        
        
        if ( bgSoundPlaying == true){
            
            NSNotificationCenter.defaultCenter().postNotificationName("StopBackgroundSound", object: self)
            
            bgSoundPlaying = false
            
        }
        
        
        if let recognizers = self.view!.gestureRecognizers {
            
            for recognizer in recognizers {
                
                self.view!.removeGestureRecognizer(recognizer as UIGestureRecognizer)
                
            }
            
        }
        
        
        self.removeAllActions()
        
        for node in self.children {
            
            node.removeAllActions()
           // node.removeFromParent()
            
        }
        
        for controller in GCController.controllers(){
            
            
            controller.playerIndex = .IndexUnset
            
            if (controller.extendedGamepad != nil ){
                
                controller.extendedGamepad?.valueChangedHandler = nil
               
                
            } else if (controller.gamepad != nil){
                
                
                controller.gamepad?.valueChangedHandler = nil
               
                
            }
            
            
        }
        
        
        
        
    }
    
    
    func swipedRight(){
        
       
        
        selectRight()
    }
    func swipedLeft(){
        
        selectLeft()
    }
    func swipedUp(){
        
      
        selectUp()
    }
    func swipedDown(){
        
        selectDown()
    }
    
    
    
    func selectRight(){
        
        changeSelectionWithDirection(Direction.Right)
    }
    func selectLeft(){
        
        changeSelectionWithDirection(Direction.Left)
    }
    func selectUp(){
        
        changeSelectionWithDirection(Direction.Up)
    }
    func selectDown(){
        
        changeSelectionWithDirection(Direction.Down)
    }

    func playSound(theSound:String ){
        
        if (theSound != ""){
            
            let sound:SKAction = SKAction.playSoundFileNamed(theSound, waitForCompletion: true)
            self.runAction(sound)
            
        }
        
    }
    
    
    func authenticateLocalPlayer() {
        
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {  (viewController, error )  -> Void in
            
            if (viewController != nil) {
                
                let vc:UIViewController = self.view!.window!.rootViewController!
                vc.presentViewController(viewController!, animated: true, completion:nil)
                
            } else {
                
                
                print ("Authentication is \(GKLocalPlayer.localPlayer().authenticated) ")
                Helpers.loggedIntoGC = true
                
                
                
                // do something based on the player being logged in.
                
              
            }
            
        }
        
    }
    
    func showGameCenter() {
        
        let gameCenterViewController = GKGameCenterViewController()
        
        
        // options for what to initially show...
        
        //gameCenterViewController.viewState = GKGameCenterViewControllerState.Achievements
       // gameCenterViewController.viewState = GKGameCenterViewControllerState.Leaderboards
        
        //gameCenterViewController.leaderboardIdentifier = "VehiclesBuilt"
        
        gameCenterViewController.gameCenterDelegate = self
        
        let vc:UIViewController = self.view!.window!.rootViewController!
        vc.presentViewController(gameCenterViewController, animated: true, completion:nil)
        
        
    }
    
    func saveHighScore(identifier:String, score:Int) {
        
        if ( allowScorePosting == true) {
            
            
            if ( highScore > defaults.integerForKey( "GameCenterHighScore")  && enableGameCenter == true) {
        
                if (GKLocalPlayer.localPlayer().authenticated) {
            
                        allowScorePosting = false
            
                    let scoreReporter = GKScore(leaderboardIdentifier: identifier)
            
                    scoreReporter.value = Int64(score)
            
                    let scoreArray:[GKScore] = [scoreReporter]
            
            
                    GKScore.reportScores(scoreArray, withCompletionHandler: {
                
                        error -> Void in
                
                        if (error != nil) {
                    
                            print("error")
                    
                        } else {
                    
                            self.allowScorePosting = true
                    
                            self.highScoreLabel.text = "Posted a New High Score to Game Center"
                    
                            self.defaults.setInteger(self.highScore, forKey: "GameCenterHighScore")
                    
                            print("posted score of \(score)")
                            //from here you can do anything else to tell the user they posted a high score
                    
                        }
                
                
                    })
            
            
            
                }
                
                
            } else {
                
                
                self.highScoreLabel.text = "High Score: " + String(self.highScore)
                
                
            }
            
        }
    }
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        
        gameCenterViewController.dismissViewControllerAnimated(true, completion:nil)
        
        
        
        print("Game Center Dismissed")
        
        allowGCtoShow = true
       
        
    }
    
    
    
    func loadHomeScene( sksName:String ){
        
        
        
        
        cleanUpScene()
        
        
        
        
        
        var fullSKSNameToLoad:String = sksName
        
        
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad ){
            
            if let _ = GameScene(fileNamed: sksNameToLoad + "Pad") {
                
                fullSKSNameToLoad = sksNameToLoad + "Pad"
                
            }
        } else  if (UIDevice.currentDevice().userInterfaceIdiom == .Phone ){
            
            if let _ = GameScene(fileNamed: sksNameToLoad + "Phone") {
                
                fullSKSNameToLoad = sksNameToLoad + "Phone"
                
            }
        }
        
        
        
        
        if let scene = Home(fileNamed: fullSKSNameToLoad) {
            
            
            scene.propertyListData = sksName 
            scene.scaleMode = .AspectFill
            
            
            
            self.view?.presentScene(scene, transition: SKTransition.fadeWithColor(SKColor.whiteColor(), duration: 2) )
            
        }
        
        
        
    }
    
}
