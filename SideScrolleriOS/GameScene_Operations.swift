//
//  GameScene_Operations.swift
//  SideScrolleriOS
//
//  Created by Justin Dike 2 on 12/8/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
//

import Foundation
import SpriteKit


extension GameScene {

    func addToBulletCount(playerBeingControlled:Player, amount:Int  ){
        
        
        
        if (playerBeingControlled == thePlayer){
            
            
            
            
            bulletCountPlayer1 = bulletCountPlayer1 + amount
            
            defaults.setInteger(bulletCountPlayer1, forKey: "BulletCountPlayer1")
            
            bulletLabel1.text = String(self.bulletCountPlayer1 )
            
            
            
            
        } else if (playerBeingControlled == thePlayer2){
            
            
            
            bulletCountPlayer2 = bulletCountPlayer2 + amount
            
            defaults.setInteger(bulletCountPlayer2, forKey: "BulletCountPlayer2")
            
            bulletLabel2.text = String(self.bulletCountPlayer2 )
            
            
            
            
            
        }
        
        
        
        
        
    }
    
    func addToScore(firedFromWho:String, amount:Int  ){
        
        
        
        if (firedFromWho == "Player1"){
            
            scorePlayer1 = scorePlayer1 + amount
            
            defaults.setInteger(scorePlayer1, forKey: "ScorePlayer1")
            
            scoreLabelPlayer1.text = String(scorePlayer1 )
            
            
        } else if (firedFromWho == "Player2"){
            
            scorePlayer2 = scorePlayer2 + amount
            
            defaults.setInteger(scorePlayer2, forKey: "ScorePlayer2")
            
            scoreLabelPlayer2.text = String(scorePlayer2 )
            
            
        }
        
        
        combinedScore = scorePlayer2 + scorePlayer1
        
        if ( combinedScore > highScore ){
            
            
            defaults.setInteger(combinedScore, forKey: "HighScore")
            
            highScoreLabel.text = "High Score: " + String(combinedScore)
            
            
        }
        
        
        if (self.passLevelWithScore == true ){
            
            self.combinedScoreLabel.text =  String( self.combinedScore ) + " / " + String( self.passLevelWithScoreOver )
        } else {
            
            self.combinedScoreLabel.text =  String(self.combinedScore)
        }
        
        
        
        
        
        if ( playerVersusPlayer == false){
            
            checkScoreForWin()
            
        }
        
        
    }
    
    
    func addToEnemyKillCount(amount:Int){
        
        if ( amount > 0){
            
            enemiesKilled = enemiesKilled + amount
            
            if (self.passLevelWithEnemiesKilled == true){
                
                self.killCountLabel.text =  String( enemiesKilled ) + " / " + String( passLevelWithEnemiesKilledOver )
                
                if (enemiesKilled >= passLevelWithEnemiesKilledOver){
                    
                    levelsPassed = levelsPassed + 1
                    
                    loadAnotherLevel(currentLevel + 1 , transitionImage: "LevelPassed" )
                    
                    
                }
                
                
            } else {
                
                self.killCountLabel.text =  String( self.enemiesKilled )
            }
            
        }
        
        
        
        
        
    }
    
    func checkScoreForWin(){
        
        
        if ( passLevelWithScore == true ) {
            
            
            if (combineScoresToPassLevel == true){
                
                
                if (combinedScore >= passLevelWithScoreOver) {
                    
                    levelsPassed = levelsPassed + 1
                    
                    loadAnotherLevel(currentLevel + 1 , transitionImage: "LevelPassed" )
                    
                    
                }
                
                
            } else if (scorePlayer1 >= passLevelWithScoreOver) {
                
                levelsPassed = levelsPassed + 1
                
                loadAnotherLevel(currentLevel + 1 , transitionImage: "LevelPassed" )
                
            } else if (scorePlayer2 >= passLevelWithScoreOver) {
                
                levelsPassed = levelsPassed + 1
                
                loadAnotherLevel(currentLevel + 1, transitionImage: "LevelPassed" )
                
            }
            
        }
        
        
        
    }
    
    
    
    func removeGestures(){
        
        if let recognizers = self.view!.gestureRecognizers {
            
            for recognizer in recognizers {
                
                self.view!.removeGestureRecognizer(recognizer as UIGestureRecognizer)
            }
            
        }
        
        
    }
    
    
    func startAutoAdvance(){
        
        let wait:SKAction = SKAction.waitForDuration(autoAdvanceLevelTime)
        let run:SKAction = SKAction.runBlock{
            
            
            
            self.loadAnotherLevel(self.currentLevel + 1, transitionImage: "TimesUp")
        }
        let seq:SKAction = SKAction.sequence( [ wait, run ] )
        self.runAction(seq)
        
    }
    
    
    func loadAnotherLevel(var levelToLoad:Int, transitionImage:String ) {
        
        if (transitionInProgress == false){
            
            
            let scale:SKAction = SKAction.scaleTo(0, duration: 0.0)
            let unhide:SKAction = SKAction.unhide()
            let scaleUp:SKAction = SKAction.scaleTo(1, duration: 0.5)
            
            
            if (transitionImage == "Player1Won"){
                
                playSound(soundPlayer1Win)
                
                if ( player1WonImage != nil) {
                    
                    player1WonImage?.position = transitionImageLocation
                    player1WonImage!.runAction(SKAction.sequence( [scale, unhide, scaleUp ]  ))
                    
                }
                
            } else if (transitionImage == "Player2Won"){
                
                if ( player2WonImage != nil) {
                    
                    playSound(soundPlayer2Win)
                    
                    player2WonImage?.position = transitionImageLocation
                    player2WonImage!.runAction(SKAction.sequence( [scale, unhide, scaleUp ]  ))
                    
                }
                
                
            } else if (transitionImage == "LevelPassed"){
                
                if ( levelPassedImage != nil) {
                    
                    playSound(soundLevelSucceed)
                    
                    levelPassedImage?.position = transitionImageLocation
                    
                    levelPassedImage!.runAction(SKAction.sequence( [scale, unhide, scaleUp ]  ))
                    
                }
                
                
            } else if (transitionImage == "LevelFailed"){
                
                if ( levelFailedImage != nil) {
                    
                    playSound(soundLevelFail)
                    
                    levelFailedImage?.position = transitionImageLocation
                    levelFailedImage!.runAction(SKAction.sequence( [scale, unhide, scaleUp ]  ))
                    
                }
                
                
            } else if (transitionImage == "TimesUp"){
                
                if ( timesUpImage != nil) {
                    
                    playSound(soundLevelSucceed)
                    
                    timesUpImage?.position = transitionImageLocation
                    timesUpImage!.runAction(SKAction.sequence( [scale, unhide, scaleUp ]  ))
                    
                }
                
                
            }
            
            
            
            
            removeGestures()
            cleanUpScene()
            
            transitionInProgress = true
            
            
            
            
            let wait:SKAction = SKAction.waitForDuration(3)
            let run:SKAction = SKAction.runBlock{
                
                
                if (levelToLoad > self.maxLevels){
                    
                    levelToLoad = 1
                }
                
                let sksNameToLoad:String = Helpers.parsePropertyListForLevelToLoad(levelToLoad, levelsName:self.levelsName)
                
                
                
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
                    
                    scene.currentLevel = levelToLoad
                    scene.playerVersusPlayer = self.playerVersusPlayer
                    scene.singlePlayerGame = self.singlePlayerGame // or false
                    scene.player2NotInUse = self.player2NotInUse
                    scene.levelsName = self.levelsName
                    
                    //v1.2
                    if ( self.currentLevel == scene.currentLevel){
                        print ("failed must be replaying same level")
                        scene.lastChosenTrack = self.lastChosenTrack
                        
                    }
                    
                    
                    if ( isMadeForPad == false){
                        
                        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad ){
                            //adjustments will be made in the scene to account for Aspect Fit deing used
                            
                            //as of 7.1.1 th behavior of AspectFill has changd, so using Fill here too 
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
                    
                    
                    
                    
                    
                    if ( self.levelsPassed > self.defaults.integerForKey("LevelsPassed") ){
                        
                        self.defaults.setInteger(self.levelsPassed, forKey: "LevelsPassed")
                        
                    }
                    
                    scene.levelsPassed = self.levelsPassed
                    
                    
                    
                    self.view?.presentScene(scene, transition:SKTransition.fadeWithColor(SKColor.blackColor(), duration: 2))
                    
                }
                
                
                
                
            }
            let seq:SKAction = SKAction.sequence( [ wait, run ] )
            self.runAction(seq)
            
            
        }
        
        
        
    }
    
    //v1.4  entire function added
    
    func loadSpecificLevel(theLevelToLoad:Int, theLevelsName:String, showLevelPassedImage:Bool, addsToLevelsPassed:Bool   ) {
        
        var waitTime:NSTimeInterval = 1
        
        if (transitionInProgress == false){
            
            if ( showLevelPassedImage == true ){
                
                
                waitTime = 3
                let scale:SKAction = SKAction.scaleTo(0, duration: 0.0)
                let unhide:SKAction = SKAction.unhide()
                let scaleUp:SKAction = SKAction.scaleTo(1, duration: 0.5)
                
                
                
                if ( levelPassedImage != nil) {
                    
                    playSound(soundLevelSucceed)
                    
                    levelPassedImage?.position = transitionImageLocation
                    
                    levelPassedImage!.runAction(SKAction.sequence( [scale, unhide, scaleUp ]  ))
                    
                }
                
            }
            
            
            if (addsToLevelsPassed == true  ){
                
                // whether to save to the defaults the overall number of levels passed has increased. Only set this to true if the Portal is going to the next level in main "Levels" array, leave this false for Bonus / Secret Levels.
                
                levelsPassed = levelsPassed + 1
                
                if ( levelsPassed > self.defaults.integerForKey("LevelsPassed") ){
                    
                    self.defaults.setInteger(levelsPassed, forKey: "LevelsPassed")
                    
                }
            }
            
            
            
            removeGestures()
            cleanUpScene()
            
            transitionInProgress = true
            
            let wait:SKAction = SKAction.waitForDuration(waitTime)
            let run:SKAction = SKAction.runBlock{
                
                let sksNameToLoad:String = Helpers.parsePropertyListForLevelToLoad(theLevelToLoad, levelsName:theLevelsName)
                
                
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
                    
                    scene.currentLevel = theLevelToLoad
                    scene.playerVersusPlayer = self.playerVersusPlayer
                    scene.singlePlayerGame = self.singlePlayerGame // or false
                    scene.player2NotInUse = self.player2NotInUse
                    scene.levelsName = theLevelsName
                    scene.prefersNoMusic = self.prefersNoMusic
                    
                    if ( isMadeForPad == false){
                        
                        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad ){
                            //adjustments will be made in the scene to account for Aspect Fit deing used
                            
                            //as of 7.1.1 th behavior of AspectFill has changd, so using Fill here too
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
                    
                    
                    
                    self.view?.presentScene(scene, transition:SKTransition.fadeWithColor(SKColor.blackColor(), duration: 2))
                    
                }
                
                
                
            }
            let seq:SKAction = SKAction.sequence( [ wait, run ] )
            self.runAction(seq)
            
            
        }
        
        
        
    }

    
    
    
    func killPlayer(somePlayer:Player){
        
        if (somePlayer.playerIsDead == false) {
            
            somePlayer.playerIsDead = true
            
            somePlayer.die()
            
            
            self.loseLife(somePlayer);
            
            //v 1.42
            
            if ( resetPlatformTime > 0){
            
            resetPlatforms()
                
            }
            
        }
        
    }
    
    
    //v 1.42
    
    func resetPlatforms(){
        
        
        
        self.enumerateChildNodesWithName("*") {
            node, stop in
            
            if let somePlatform:Platform = node as? Platform {
                
                somePlatform.resetPlatform(self.resetPlatformTime)
                
                
                
            }
            
        }
        
        
        
    }
    
    
    
    
    
    
    func loseLife(somePlayer:Player){
        
        
        var currentHearts:Int = 0
        
        if (somePlayer == thePlayer){
            
            heartsPlayer1 = heartsPlayer1 - 1
            
            defaults.setInteger(heartsPlayer1, forKey: "HeartsPlayer1")
            
            currentHearts = heartsPlayer1
            
            
            
            currentMovingPole = nil
            
            currentMovingPlatform = nil
            
            thePlayer.isClimbing = false
            thePlayer.cantBeHurt = false
            
        } else if (somePlayer == thePlayer2){
            
            
            heartsPlayer2 = heartsPlayer2 - 1
            
            defaults.setInteger(heartsPlayer2, forKey: "HeartsPlayer2")
            
            currentHearts = heartsPlayer2
            
            
            currentMovingPole2 = nil
            
            currentMovingPlatform2 = nil
            
            thePlayer2.isClimbing = false
            thePlayer2.cantBeHurt = false
        }
        
        
        
        tallyHearts()
        
        
        
        
        if ( currentHearts >= 1 ) {
            
            //PLAYER is still Alive
            
            somePlayer.playSound(somePlayer.soundLoseHeart)
            
            
            somePlayer.physicsBody?.velocity = CGVectorMake(0, 0)
            
            
            somePlayer.currentDirection = .None
            //somePlayer.removeAllActions()
            
            var startBackToLocation:CGPoint = CGPointZero
            
            if (somePlayer == thePlayer) {
                
                
                
                if ( respawnPointPlayer1 != CGPointZero) {
                    
                    startBackToLocation = respawnPointPlayer1
                    
                } else {
                    
                    startBackToLocation = getClosestSpawnLocationTo(thePlayer2)
                    startBackToLocation = CGPointMake(startBackToLocation.x + 10, startBackToLocation.y)
                    
                }
                
                
                
                playerLastPosition = CGPointZero
                
                if ( player2NotInUse == true || player2OutOfGame == true){
                    
                    thePlayerCameraFollows = thePlayer
                }
                    
                else if ( onePlayerModeBasedOnControllers == false ){
                    
                    thePlayerCameraFollows = thePlayer2
                    
                    
                    self.cameraIcon2?.hidden = false
                    self.cameraIcon1?.hidden = true
                    
                    if (cameraFollowsPlayerX == true || cameraFollowsPlayerY == true ) {
                        
                        cameraDonePanningToNewFollower = false
                        
                        if ( cameraFollowsPlayerX == true ){
                            
                            let move:SKAction = SKAction.moveToX((thePlayerCameraFollows?.position.x)!, duration: 1)
                            move.timingMode = .EaseOut
                            
                            let run:SKAction = SKAction.runBlock{
                                
                                self.cameraDonePanningToNewFollower = true
                            }
                            theCamera.runAction(SKAction.sequence([move, run ]))
                            
                        }
                        
                        if ( cameraFollowsPlayerY == true ){
                            
                            let move:SKAction = SKAction.moveToY((thePlayerCameraFollows?.position.y)!, duration: 1)
                            move.timingMode = .EaseOut
                            
                            let run:SKAction = SKAction.runBlock{
                                
                                self.cameraDonePanningToNewFollower = true
                            }
                            theCamera.runAction(SKAction.sequence([move, run ]))
                            
                        }
                        
                        
                        
                    } else if (cameraBetweenPlayersX == true || cameraBetweenPlayersY == true) {
                        
                        cameraDonePanningToNewFollower = false
                        
                        if ( cameraBetweenPlayersX == true ){
                            
                            var newCentralLocation:CGPoint = CGPointZero
                            
                            let xDiff:CGFloat = abs( startBackToLocation.x - thePlayer2.position.x  ) / 2
                            
                            if (startBackToLocation.x < thePlayer2.position.x) {
                                
                                newCentralLocation = CGPointMake( startBackToLocation.x + xDiff, theCamera.position.y )
                                
                                
                            } else {
                                
                                newCentralLocation = CGPointMake( thePlayer2.position.x + xDiff, theCamera.position.y )
                                
                            }
                            
                            
                            
                            
                            let move:SKAction = SKAction.moveToX(newCentralLocation.x, duration: 1)
                            move.timingMode = .EaseOut
                            
                            let run:SKAction = SKAction.runBlock{
                                
                                self.cameraDonePanningToNewFollower = true
                            }
                            theCamera.runAction(SKAction.sequence([move, run ]))
                        }
                        
                        
                        
                        if ( cameraBetweenPlayersY == true ){
                            
                            var newCentralLocation:CGPoint = CGPointZero
                            
                            let yDiff:CGFloat = abs( startBackToLocation.y - thePlayer2.position.y  ) / 2
                            
                            if (startBackToLocation.y < thePlayer2.position.y) {
                                
                                newCentralLocation = CGPointMake( theCamera.position.x, startBackToLocation.y + yDiff )
                                
                                
                            } else {
                                
                                newCentralLocation = CGPointMake( theCamera.position.x, thePlayer2.position.y + yDiff  )
                                
                            }
                            
                            
                            
                            
                            let move:SKAction = SKAction.moveToY(newCentralLocation.y, duration: 1)
                            move.timingMode = .EaseOut
                            
                            let run:SKAction = SKAction.runBlock{
                                
                                self.cameraDonePanningToNewFollower = true
                            }
                            theCamera.runAction(SKAction.sequence([move, run ]))
                        }
                    }
                    
                    
                    
                }
                
            } else if (somePlayer == thePlayer2) {
                
                if ( respawnPointPlayer2 != CGPointZero){
                    
                    startBackToLocation = respawnPointPlayer2
                    
                } else {
                    
                    startBackToLocation = getClosestSpawnLocationTo(thePlayer)
                    startBackToLocation = CGPointMake(startBackToLocation.x - 10, startBackToLocation.y)
                    
                }
                
                playerLastPosition = CGPointZero
                
                if (singlePlayerGame == true){
                    
                    //dont swap cameras
                    
                    thePlayerCameraFollows = thePlayer
                    
                } else if (player1OutOfGame == true ) {
                    
                    // player is totally out of the game
                    
                    thePlayerCameraFollows = thePlayer2
                    
                } else if ( onePlayerModeBasedOnControllers == false){
                    
                    thePlayerCameraFollows = thePlayer
                    
                    self.cameraIcon2?.hidden = true
                    self.cameraIcon1?.hidden = false
                    
                    if (cameraFollowsPlayerX == true || cameraFollowsPlayerY == true) {
                        
                        cameraDonePanningToNewFollower = false
                        
                        if ( cameraFollowsPlayerX == true ){
                            
                            let move:SKAction = SKAction.moveToX((thePlayerCameraFollows?.position.x)!, duration: 1)
                            move.timingMode = .EaseOut
                            
                            let run:SKAction = SKAction.runBlock{
                                
                                self.cameraDonePanningToNewFollower = true
                            }
                            theCamera.runAction(SKAction.sequence([move, run ]))
                            
                        }
                        
                        if ( cameraFollowsPlayerY == true ){
                            
                            let move:SKAction = SKAction.moveToY((thePlayerCameraFollows?.position.y)!, duration: 1)
                            move.timingMode = .EaseOut
                            
                            let run:SKAction = SKAction.runBlock{
                                
                                self.cameraDonePanningToNewFollower = true
                            }
                            theCamera.runAction(SKAction.sequence([move, run ]))
                            
                        }
                        
                    } else if (cameraBetweenPlayersX == true || cameraBetweenPlayersY == true ) {
                        
                        cameraDonePanningToNewFollower = false
                        
                        
                        if ( cameraBetweenPlayersX == true){
                            
                            var newCentralLocation:CGPoint = CGPointZero
                            
                            let xDiff:CGFloat = abs( startBackToLocation.x - thePlayer.position.x  ) / 2
                            
                            if (startBackToLocation.x < thePlayer.position.x) {
                                
                                newCentralLocation = CGPointMake( startBackToLocation.x + xDiff, theCamera.position.y )
                                
                                
                            } else {
                                
                                newCentralLocation = CGPointMake( thePlayer.position.x + xDiff, theCamera.position.y )
                                
                            }
                            
                            
                            
                            
                            let move:SKAction = SKAction.moveToX(newCentralLocation.x, duration: 1)
                            move.timingMode = .EaseOut
                            
                            let run:SKAction = SKAction.runBlock{
                                
                                self.cameraDonePanningToNewFollower = true
                            }
                            theCamera.runAction(SKAction.sequence([move, run ]))
                            
                        }
                        
                        
                        if ( cameraBetweenPlayersY == true ){
                            
                            var newCentralLocation:CGPoint = CGPointZero
                            
                            let yDiff:CGFloat = abs( startBackToLocation.y - thePlayer2.position.y  ) / 2
                            
                            if (startBackToLocation.y < thePlayer2.position.y) {
                                
                                newCentralLocation = CGPointMake( theCamera.position.x, startBackToLocation.y + yDiff )
                                
                                
                            } else {
                                
                                newCentralLocation = CGPointMake( theCamera.position.x, thePlayer2.position.y + yDiff  )
                                
                            }
                            
                            
                            
                            
                            let move:SKAction = SKAction.moveToY(newCentralLocation.y, duration: 1)
                            move.timingMode = .EaseOut
                            
                            let run:SKAction = SKAction.runBlock{
                                
                                self.cameraDonePanningToNewFollower = true
                            }
                            theCamera.runAction(SKAction.sequence([move, run ]))
                        }
                        
                    }
                    
                }
                
            }
            
            let wait:SKAction = SKAction.waitForDuration(somePlayer.reviveTime)
            let move:SKAction = SKAction.moveTo(startBackToLocation, duration:0)
            let run:SKAction = SKAction.runBlock {
                
                
                somePlayer.playerIsDead = false;
                somePlayer.revive()
            }
            
            let seq:SKAction = SKAction.sequence([wait, move, wait, run])
            somePlayer.runAction(seq)
            
            
            
            
        } else if ( currentHearts <= 0 ) {
            
            //PLayer is dead
            
            somePlayer.playSound(somePlayer.soundDead)
            
            
            if (playerVersusPlayer == true) {
                
                //Not Co-Op Mode
                
                defaults.setInteger(0, forKey: "ScorePlayer1")
                defaults.setInteger(0, forKey: "ScorePlayer2")
                
                // will reload the next level to battle aain
                
                if (somePlayer == thePlayer) {
                    
                    theWinCount2++
                    defaults.setInteger(theWinCount2, forKey: "WinCount2")
                    levelsPassed = levelsPassed + 1
                    
                    loadAnotherLevel(currentLevel + 1, transitionImage:"Player2Won"  )
                    
                } else {
                    
                    theWinCount1++
                    defaults.setInteger(theWinCount1, forKey: "WinCount1")
                    
                    levelsPassed = levelsPassed + 1
                    
                    loadAnotherLevel(currentLevel + 1, transitionImage:"Player1Won"  )
                }
                
                
                
                
            } else {
                
                //in Co-Op Mode
                
                
                let wait:SKAction = SKAction.waitForDuration(somePlayer.reviveTime)
                let run:SKAction = SKAction.runBlock {
                    
                    somePlayer.removeFromParent()
                    
                    if (self.cameraBetweenPlayersX == true || self.cameraBetweenPlayersY == true){
                        
                        print("switching camera mode to follow remaining player ")
                        // switch to camera following a single player instead of between both
                        // if one player has died
                        self.cameraDonePanningToNewFollower = true
                        self.cameraBetweenPlayersX = false
                        self.cameraFollowsPlayerX = true
                        self.cameraBetweenPlayersY = false
                        self.cameraFollowsPlayerY = true
                        
                        if ( somePlayer == self.thePlayer){
                            
                            print("player 1 died, switched to player 2")
                            self.player1OutOfGame = true
                            self.thePlayerCameraFollows = self.thePlayer2
                            self.playerLastPosition  = self.thePlayer2.position
                            
                        } else if ( somePlayer == self.thePlayer2) {
                            self.player2OutOfGame = true
                            print("player 2 died, switch camera to player 1 ")
                            self.thePlayerCameraFollows =  self.thePlayer
                            self.playerLastPosition  = self.thePlayer.position
                            
                        }
                        
                    }
                    
                }
                self.runAction(SKAction.sequence([wait, run ]))
                
                
                
                
                
                
                
                if ( singlePlayerGame == true){
                    
                    if ( somePlayer == thePlayer){
                        //player 1 died in single player game,
                        
                        
                        decideHowToEndFailedGame()
                        
                        
                    } else if ( somePlayer == thePlayer2){
                        
                        cancelOnePlayerLoops()
                        
                    }
                    
                }else if ( heartsPlayer2 <= 0 && heartsPlayer1 <= 0) {
                    
                    //both players are dead
                    
                    decideHowToEndFailedGame()
                    
                }
                
                
                
            }
            
        }
        
        
        
        
    }
    func decideHowToEndFailedGame(){
        
        defaults.setInteger(0, forKey: "ScorePlayer1")
        defaults.setInteger(0, forKey: "ScorePlayer2")
        
        
        defaults.setInteger(bulletsToStart, forKey: "BulletCountPlayer1")
        defaults.setInteger(bulletsToStart, forKey: "BulletCountPlayer2")
        
        
        if ( refreshLevelOnDeath == true){
            
            //play the same level again
            
            
            loadAnotherLevel(currentLevel, transitionImage: "LevelFailed")
            
            
        } else {
            
            
            //go back to the main menu
            
            goBackToMainMenu()
            
        }
        
    }
    
    
    
    func getClosestSpawnLocationTo(playerToCheck:Player) -> CGPoint {
        
        var theLocation:CGPoint = CGPointZero
        
        var leastXDistance:CGFloat = 0
        
        for node in spawnArray {
            
            if (leastXDistance == 0){
                
                //set an initial value
                
                leastXDistance = abs(playerToCheck.position.x - node.position.x)
                
                theLocation = node.position
                
            } else {
                
                //check if the current node is closer
                
                let xDiff:CGFloat = abs(playerToCheck.position.x - node.position.x)
                
                if (xDiff < leastXDistance) {
                    
                    leastXDistance = xDiff
                    theLocation = node.position
                    
                }
                
                
            }
            
            
            
        }
        
        
        
        return theLocation
        
    }
    
    
    
    func addLife( playerBeingControlled:Player ){
        
        if ( playerBeingControlled == thePlayer){
            
            heartsPlayer1 = heartsPlayer1 + 1
            
            if (heartsPlayer1 > 4){
                
                heartsPlayer1 = 4
            }
            
            
        } else {
            
            heartsPlayer2 = heartsPlayer2 + 1
            
            if (heartsPlayer2 > 4){
                
                heartsPlayer2 = 4
            }
            
        }
        
        tallyHearts()
        
        
        
    }
    
    func stealLife( playerBeingControlled:Player ){
        
        playSound(stealHeartsSound)
        
        if ( playerBeingControlled == thePlayer){
            
            heartsPlayer1 = heartsPlayer1 - 1
            
            
            
            
        } else {
            
            heartsPlayer2 = heartsPlayer2 + 1
            
            
            
        }
        
        tallyHearts()
        
        
        
        
        
    }
    
    func tallyHearts(){
        
        
        if (heartsPlayer1 == 4){
            
            player1Heart1?.hidden = false
            player1Heart2?.hidden = false
            player1Heart3?.hidden = false
            player1Heart4?.hidden = false
            
            
        } else if (heartsPlayer1 == 3){
            
            player1Heart1?.hidden = false
            player1Heart2?.hidden = false
            player1Heart3?.hidden = false
            player1Heart4?.hidden = true
            
        } else if (heartsPlayer1 == 2){
            
            player1Heart1?.hidden = false
            player1Heart2?.hidden = false
            player1Heart3?.hidden = true
            player1Heart4?.hidden = true
            
            
        } else if (heartsPlayer1 == 1){
            
            player1Heart1?.hidden = false
            player1Heart2?.hidden = true
            player1Heart3?.hidden = true
            player1Heart4?.hidden = true
            
            
        } else if (heartsPlayer1 == 0){
            
            player1Heart1?.hidden = true
            player1Heart2?.hidden = true
            player1Heart3?.hidden = true
            player1Heart4?.hidden = true
            
            
        }
        
        
        
        //////////
        
        
        if ( player2NotInUse == false) {
            
            
            if (heartsPlayer2 == 4){
                
                player2Heart1?.hidden = false
                player2Heart2?.hidden = false
                player2Heart3?.hidden = false
                player2Heart4?.hidden = false
                
                
            } else if (heartsPlayer2 == 3){
                
                player2Heart1?.hidden = false
                player2Heart2?.hidden = false
                player2Heart3?.hidden = false
                player2Heart4?.hidden = true
                
            } else if (heartsPlayer2 == 2){
                
                player2Heart1?.hidden = false
                player2Heart2?.hidden = false
                player2Heart3?.hidden = true
                player2Heart4?.hidden = true
                
                
            } else if (heartsPlayer2 == 1){
                
                player2Heart1?.hidden = false
                player2Heart2?.hidden = true
                player2Heart3?.hidden = true
                player2Heart4?.hidden = true
                
            } else if (heartsPlayer2 == 0){
                
                player2Heart1?.hidden = true
                player2Heart2?.hidden = true
                player2Heart3?.hidden = true
                player2Heart4?.hidden = true
                
            }
            
        }
        
    }
    
    
    
    func playSound(theSound:String ){
        
        if (theSound != ""){
            
            //print(theSound)
            
            if ( theSound == p1SoundAmmoCollect){
                
                self.runAction(preloadedp1SoundAmmoCollect!)
                
            } else if ( theSound == p2SoundAmmoCollect){
                
                self.runAction(preloadedp2SoundAmmoCollect!)
                
            } else {
                
                
                
                let sound:SKAction = SKAction.playSoundFileNamed(theSound, waitForCompletion: true)
                self.runAction(sound)
                
            }
            
        }
        
    }



}