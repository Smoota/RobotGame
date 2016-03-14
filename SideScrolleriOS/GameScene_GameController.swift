//
//  GameScene_GameController.swift
//  SideScroller
//
//  Created by Justin Dike 2 on 10/28/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
//

import Foundation
import SpriteKit
import GameController

extension GameScene {
    
    func setUpControllerObservers(){
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "connectControllers", name: GCControllerDidConnectNotification, object: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "controllerDisconnected", name: GCControllerDidDisconnectNotification, object: nil)
        
        
    }
    
    func checkPlayerIndexes(){
        
        playerIndex1InUse = false
        playerIndex2InUse = false
        
        
        //controllers in use keep their indexes obviously, so any one that has been disconnected will reset the playerIndexInUse1 or playerIndexInUse2 var
        
        for controller in GCController.controllers(){
            
            if (controller.playerIndex == .Index1){
                
                //notes this is still in use
                playerIndex1InUse = true
                
                
            }
            else if (controller.playerIndex == .Index2){
                
                playerIndex2InUse = true
                
                
            }
            
        }
        
        
        if ( playerIndex1InUse == false && player1HasMicroController == true){
            
            player1HasMicroController = false
            
        }
        
        if ( playerIndex1InUse == false && player2HasMicroController == true){
            
            player2HasMicroController = false
            
        }
        
        
        
    }
    
    
    func connectControllers(){
        
        
        if (GCController.controllers().count > 1) {
            
            onePlayerModeBasedOnControllers = false
            hideControllerLabel()
            cancelOnePlayerLoops()
            
        } else {
            
            //means there's only one controller
            
            onePlayerModeBasedOnControllers = true
            
            if ( player2NotInUse == true && singlePlayerGame == true){
                
            } else {
                
                showControllerLabel()
                
            }
            
            
        }
        
        
        
        unpauseScene()
        
        
        for controller in GCController.controllers() {
            
            if (controller.extendedGamepad != nil && controller.playerIndex == .IndexUnset){
                
                if (playerIndex1InUse == false){
                    
                    // this means that we haven't setup player 1
                    
                    playerIndex1InUse = true
                    controller.playerIndex = .Index1
                    
                } else if (playerIndex2InUse == false){
                    
                    playerIndex2InUse = true
                    
                    if ( singlePlayerGame == true){
                        
                        controller.playerIndex = .Index1
                        
                    } else {
                        
                        controller.playerIndex = .Index2
                        
                    }
                    
                } else {
                    
                    
                    if (player1HasMicroController == true){
                        
                        controller.playerIndex = .Index1
                        
                    } else if (player2HasMicroController == true){
                        
                        if ( singlePlayerGame == true){
                            
                            controller.playerIndex = .Index1
                            
                        } else {
                            
                            controller.playerIndex = .Index2
                            
                        }
                        
                    } else {
                        
                        if ( singlePlayerGame == true){
                            
                            controller.playerIndex = .Index1
                            
                        } else {
                            
                            controller.playerIndex = .Index2
                            
                        }
                    }
                    
                    
                }
                
                
                controller.extendedGamepad?.valueChangedHandler = nil
                setUpExtendedController(controller)
                
            } else if (controller.extendedGamepad != nil && controller.playerIndex != .IndexUnset){
                
                // is extended gamepad with an index already established
                
                controller.extendedGamepad?.valueChangedHandler = nil
                setUpExtendedController(controller)
                
                
            }else if (controller.gamepad != nil && controller.playerIndex == .IndexUnset){
                
                if (playerIndex1InUse == false){
                    
                    // this means that we haven't setup player 1
                    
                    playerIndex1InUse = true
                    controller.playerIndex = .Index1
                    
                } else if (playerIndex2InUse == false){
                    
                    playerIndex2InUse = true
                    
                    if ( singlePlayerGame == true){
                        
                        controller.playerIndex = .Index1
                        
                    } else {
                        
                        controller.playerIndex = .Index2
                        
                    }
                    
                } else {
                    
                    
                    if (player1HasMicroController == true){
                        
                        controller.playerIndex = .Index1
                        
                    } else if (player2HasMicroController == true){
                        
                        if ( singlePlayerGame == true){
                            
                            controller.playerIndex = .Index1
                            
                        } else {
                            
                            controller.playerIndex = .Index2
                            
                        }
                        
                    } else {
                        
                        if ( singlePlayerGame == true){
                            
                            controller.playerIndex = .Index1
                            
                        } else {
                            
                            controller.playerIndex = .Index2
                            
                        }
                    }
                    
                    
                }
                
                
                controller.gamepad?.valueChangedHandler = nil
                setUpStandardController(controller)
                
            } else if (controller.gamepad != nil && controller.playerIndex != .IndexUnset){
                
                controller.gamepad?.valueChangedHandler = nil
                setUpStandardController(controller)
                
            }
            
            
        }
        
        #if os(tvOS)
            
            for controller in GCController.controllers() {
                
                if (controller.extendedGamepad != nil ){
                    
                    //ignore extended
                    
                } else if (controller.gamepad != nil ){
                    
                    //ignore standard
                    
                } else if (controller.microGamepad != nil && controller.playerIndex == .IndexUnset ) {
                    
                    if (playerIndex1InUse == false) {
                        
                        playerIndex1InUse = true
                        player1HasMicroController = true
                        player2HasMicroController = false
                        controller.playerIndex = .Index1
                        
                    } else if (playerIndex2InUse == false) {
                        
                        playerIndex2InUse = true
                        
                        
                        if ( singlePlayerGame == true){
                            
                            controller.playerIndex = .Index1
                            player2HasMicroController = false
                            player1HasMicroController = true
                            
                        } else {
                            
                            controller.playerIndex = .Index2
                            player2HasMicroController = true
                            player1HasMicroController = false
                            
                        }
                        
                        
                    } else {
                        
                        
                        
                        if ( singlePlayerGame == true){
                            
                            player2HasMicroController = false
                            player1HasMicroController = true
                            controller.playerIndex = .Index1
                            
                        } else {
                            
                            player2HasMicroController = true
                            player1HasMicroController = false
                            controller.playerIndex = .Index2
                            
                        }
                        
                    }
                    
                    
                    
                    
                    controller.microGamepad?.valueChangedHandler = nil
                    setUpMicroController(controller)
                    
                    
                    
                } else if (controller.microGamepad != nil && controller.playerIndex != .IndexUnset ) {
                    
                    controller.microGamepad?.valueChangedHandler = nil
                    setUpMicroController(controller)
                    
                    
                }
                
                
            }
            
            
        #endif
        
        
    }
    
    
    func setUpExtendedController(controller:GCController){
        
        
        
        controller.extendedGamepad?.valueChangedHandler = {
            (gamepad: GCExtendedGamepad, element:GCControllerElement) in
            
            #if os(iOS)
                
                self.button1.alpha = 0
                self.button2.alpha = 0
                self.ball.alpha = 0
                self.base.alpha = 0
                
            #endif
            
            
            var playerBeingControlled:Player?
            
            if ( gamepad.controller?.playerIndex == .Index1){
                
                playerBeingControlled = self.thePlayer
                
            } else if ( gamepad.controller?.playerIndex == .Index2) {
                
                playerBeingControlled = self.thePlayer2
                
            }
            
            if (gamepad.leftThumbstick == element){
                
                
                if (gamepad.leftThumbstick.down.value > 0.2){
                    
                    if (self.paused == false){
                        
                        self.gcDownWithPlayer(playerBeingControlled!)
                        
                    }  else {
                        
                        self.selectMainMenu()
                    }
                    
                } else if (gamepad.leftThumbstick.up.value > 0.2){
                    
                    if (self.paused == false){
                        
                        self.gcUpWithPlayer(playerBeingControlled!)
                        
                    }  else {
                        
                        self.selectResumeGame()
                    }
                    
                }
                    
                else if (gamepad.leftThumbstick.right.value > 0.2){
                    
                    self.gcRightWithPlayer(playerBeingControlled!)
                    
                } else if (gamepad.leftThumbstick.left.value > 0.2){
                    
                    self.gcLeftWithPlayer(playerBeingControlled!)
                    
                } else if (gamepad.leftThumbstick.left.pressed == false && gamepad.leftThumbstick.right.pressed == false && gamepad.leftThumbstick.up.pressed == false && gamepad.leftThumbstick.down.pressed == false){
                    
                    self.gcLiftUpDPadWithPlayer(playerBeingControlled!)
                    
                }
                
                
                
                
            } else  if (gamepad.rightThumbstick == element){
                
                
                if (gamepad.rightThumbstick.down.value > 0.2){
                    
                    if (self.paused == false){
                        
                        self.gcDownWithPlayer(playerBeingControlled!)
                        
                    }  else {
                        
                        self.selectMainMenu()
                    }
                    
                } else if (gamepad.rightThumbstick.up.value > 0.2){
                    
                    if (self.paused == false){
                        
                        self.gcUpWithPlayer(playerBeingControlled!)
                        
                    }  else {
                        
                        self.selectResumeGame()
                    }
                    
                }
                    
                else if (gamepad.rightThumbstick.right.value > 0.2){
                    
                    self.gcRightWithPlayer(playerBeingControlled!)
                    
                } else if (gamepad.rightThumbstick.left.value > 0.2){
                    
                    self.gcLeftWithPlayer(playerBeingControlled!)
                    
                } else if (gamepad.rightThumbstick.left.pressed == false && gamepad.rightThumbstick.right.pressed == false && gamepad.rightThumbstick.up.pressed == false && gamepad.rightThumbstick.down.pressed == false){
                    
                    self.gcLiftUpDPadWithPlayer(playerBeingControlled!)
                    
                }
                
                
                
                
            } else if (gamepad.dpad == element){
                
                if (gamepad.dpad.down.pressed == true){
                    
                    if (self.paused == false){
                        
                        self.gcDownWithPlayer(playerBeingControlled!)
                        
                    } else {
                        
                        self.selectMainMenu()
                    }
                    
                    
                } else if (gamepad.dpad.up.pressed == true){
                    
                    if (self.paused == false){
                        
                        self.gcUpWithPlayer(playerBeingControlled!)
                        
                    } else {
                        
                        self.selectResumeGame()
                    }
                    
                    
                } else if (gamepad.dpad.right.pressed == true){
                    
                    //v1.2
                    if ( self.paused == true && self.justStartedNewTrack == false){
                        
                        self.nextTrackByGoingRight()
                        
                    } else {
                        
                        self.gcRightWithPlayer(playerBeingControlled!)
                    }
                    
                } else if (gamepad.dpad.left.pressed == true){
                    
                    
                    //v1.2
                    if ( self.paused == true){
                        
                        self.stopMusicByGoingLeft()
                        
                    } else {
                        
                        self.gcLeftWithPlayer(playerBeingControlled!)
                        
                    }
                    
                    
                    
                } else if (gamepad.dpad.left.pressed == false && gamepad.dpad.right.pressed == false && gamepad.dpad.up.pressed == false && gamepad.dpad.down.pressed == false){
                    
                    self.gcLiftUpDPadWithPlayer(playerBeingControlled!)
                    self.justStartedNewTrack = false
                    
                }
                
                
            } // ends if (gamepad.dpad == element){
                
            else if (gamepad.buttonA == element ){
                
                if ( gamepad.buttonA.pressed == false){
                    
                    if (self.paused == false){
                        
                        self.pressedJump ( playerBeingControlled! )
                        
                    } else {
                        
                        self.menuSelectionMade()
                        
                    }
                    
                }
                
                
            }
            else if (gamepad.buttonX == element){
                
                
                
                if (self.paused == false){
                    
                    if ( gamepad.buttonX.pressed == true){
                        
                        playerBeingControlled!.xHeldDown = true
                        playerBeingControlled?.run()
                        
                        
                    } else if ( gamepad.buttonX.pressed == false){
                        
                        playerBeingControlled!.xHeldDown = false
                        playerBeingControlled?.releaseRun()
                        self.pressedShoot ( playerBeingControlled! )
                        
                    }
                    
                } else {
                    
                    self.menuSelectionMade()
                }
            }
                
                
            else if (gamepad.buttonY == element){
                
                #if os(iOS)
                    
                    //y must pause on iOS
                    
                    if ( gamepad.buttonY.pressed == false ){
                        
                        if (self.paused == false){
                            
                            self.pauseScene()
                            
                        } else {
                            
                            self.unpauseScene()
                            
                        }
                    }
                    
                #endif
                
                #if os(tvOS)
                    
                    if (self.paused == false){
                        
                        if ( gamepad.buttonY.pressed == false){
                            
                            self.pressedJump ( playerBeingControlled! )
                            
                        }
                    } else {
                        
                        self.menuSelectionMade()
                        
                    }
                    
                #endif
            }
                
            else if (gamepad.leftShoulder == element){
                
                if ( gamepad.leftShoulder.pressed == false){
                    
                    self.pressedJump ( playerBeingControlled! )
                    
                }
            }
            else if (gamepad.leftTrigger == element){
                
                if ( gamepad.leftTrigger.pressed == false){
                    
                    
                    self.pressedShoot(playerBeingControlled! )
                    
                }
            }
                
            else if (gamepad.rightShoulder == element){
                
                if ( gamepad.rightShoulder.pressed == false){
                    
                    self.pressedJump ( playerBeingControlled! )
                    
                }
            }
            else if (gamepad.rightTrigger == element){
                
                if ( gamepad.rightShoulder.pressed == false){
                    
                    self.pressedShoot(playerBeingControlled! )
                    
                }
            }
            
            
            
        }
        
        
    }
    
    func setUpStandardController(controller:GCController){
        
        
        
        controller.gamepad?.valueChangedHandler = {
            (gamepad: GCGamepad, element:GCControllerElement) in
            
            
            #if os(iOS)
                
                self.button1.alpha = 0
                self.button2.alpha = 0
                self.ball.alpha = 0
                self.base.alpha = 0
                
            #endif
            
            
            //print(gamepad.controller?.playerIndex.rawValue)
            
            var playerBeingControlled:Player?
            
            if ( gamepad.controller?.playerIndex == .Index1){
                
                playerBeingControlled = self.thePlayer
                
            } else if ( gamepad.controller?.playerIndex == .Index2){
                
                playerBeingControlled = self.thePlayer2
                
            }
            
            
            
            if (gamepad.dpad == element){
                
                if (gamepad.dpad.down.pressed == true){
                    
                    if (self.paused == false){
                        
                        self.gcDownWithPlayer(playerBeingControlled!)
                        
                    } else {
                        
                        self.selectMainMenu()
                    }
                    
                } else if (gamepad.dpad.up.pressed == true){
                    
                    if (self.paused == false){
                        
                        self.gcUpWithPlayer(playerBeingControlled!)
                        
                        
                    } else {
                        
                        self.selectResumeGame()
                        
                    }
                    
                    
                } else if (gamepad.dpad.right.pressed == true){
                    
                    
                    //v1.2
                    if ( self.paused == true && self.justStartedNewTrack == false){
                        
                        self.nextTrackByGoingRight()
                        
                    } else {
                        self.gcRightWithPlayer(playerBeingControlled!)
                        
                    }
                    
                    
                    
                } else if (gamepad.dpad.left.pressed == true){
                    
                    //v1.2
                    if ( self.paused == true){
                        
                        self.stopMusicByGoingLeft()
                        
                    } else {
                        
                        self.gcLeftWithPlayer(playerBeingControlled!)
                    }
                    
                } else if (gamepad.dpad.left.pressed == false && gamepad.dpad.right.pressed == false && gamepad.dpad.up.pressed == false && gamepad.dpad.down.pressed == false){
                    
                    self.gcLiftUpDPadWithPlayer(playerBeingControlled!)
                    self.justStartedNewTrack = false
                    
                }
                
                
            } // ends if (gamepad.dpad == element){
                
            else if (gamepad.buttonA == element ){
                
                if (self.paused == false){
                    
                    if ( gamepad.buttonA.pressed == false){
                        
                        self.pressedJump ( playerBeingControlled! )
                        
                    }
                    
                } else {
                    
                    self.menuSelectionMade()
                    
                }
                
                
            }
            else if (gamepad.buttonX == element){
                
                if (self.paused == false){
                    
                    if ( gamepad.buttonX.pressed == true){
                        
                        playerBeingControlled!.xHeldDown = true
                        playerBeingControlled?.run()
                        
                    } else if ( gamepad.buttonX.pressed == false){
                        
                        playerBeingControlled!.xHeldDown = false
                        playerBeingControlled?.releaseRun()
                        self.pressedShoot ( playerBeingControlled! )
                        
                    }
                    
                } else {
                    
                    self.menuSelectionMade()
                    
                }
                
                
                
            }
                
                
            else if (gamepad.buttonY == element){
                
                #if os(iOS)
                    
                    //y must pause on iOS
                    
                    if ( gamepad.buttonY.pressed == false ){
                        
                        if (self.paused == false){
                            
                            self.pauseScene()
                            
                        } else {
                            
                            self.unpauseScene()
                            
                        }
                    }
                    
                #endif
                
                #if os(tvOS)
                    
                    if (self.paused == false){
                        
                        if ( gamepad.buttonY.pressed == false){
                            
                            self.pressedJump ( playerBeingControlled! )
                            
                        }
                    } else {
                        
                        self.menuSelectionMade()
                        
                    }
                    
                #endif
                
                
            }
            
            
            
            
        }
        
        
    }
    
    #if os(tvOS)
    func setUpMicroController(controller:GCController){
    
    
    controller.microGamepad?.valueChangedHandler = {
    (gamepad: GCMicroGamepad, element:GCControllerElement) in
    
    
    gamepad.reportsAbsoluteDpadValues = true
    gamepad.allowsRotation = true
    
    var playerBeingControlled:Player?
    
    if ( gamepad.controller?.playerIndex == .Index1){
    
    playerBeingControlled = self.thePlayer
    
    } else if ( gamepad.controller?.playerIndex == .Index2) {
    
    playerBeingControlled = self.thePlayer2
    
    }
    
    if (gamepad.dpad == element){
    
    
    
    if (gamepad.dpad.right.value > 0.2){
    
    
    //v1.2
    if ( self.paused == true && self.justStartedNewTrack == false){
    
    
    self.nextTrackByGoingRight()
    
    } else {
    
    self.gcRightWithPlayer(playerBeingControlled!)
    
    }
    
    
    
    
    } else if (gamepad.dpad.left.value > 0.2){
    
    //v1.2
    if ( self.paused == true){
    
    self.stopMusicByGoingLeft()
    
    } else {
    
    self.gcLeftWithPlayer(playerBeingControlled!)
    }
    
    
    
    }
    
    
    if (gamepad.dpad.up.value > 0.2){
    
    if (self.paused == false){
    
    if (playerBeingControlled?.onPole == true) {
    
    self.gcUpWithPlayer(playerBeingControlled!)
    }
    
    else if (playerBeingControlled?.isJumping == false) {
    
    self.pressedJump (playerBeingControlled!)
    
    }
    
    } else {
    
    self.selectResumeGame()
    
    }
    
    }
    
    else if (gamepad.dpad.down.value > 0.2){
    
    if (self.paused == false){
    
    self.gcDownWithPlayer(playerBeingControlled!)
    
    } else {
    
    self.selectMainMenu()
    }
    
    }
    
    if (gamepad.dpad.left.value == 0 && gamepad.dpad.right.value == 0 && gamepad.dpad.up.value == 0 && gamepad.dpad.down.value == 0){
    
    
    self.gcLiftUpDPadWithPlayer(playerBeingControlled!)
    self.justStartedNewTrack = false
    
    }
    
    
    }
    
    if (gamepad.buttonA == element ){
    
    if (self.paused == false){
    
    if ( gamepad.buttonA.pressed == false){
    
    self.pressedJump ( playerBeingControlled! )
    
    }
    
    } else {
    
    self.menuSelectionMade()
    
    }
    
    }
    
    if (gamepad.buttonX == element){
    
    if (self.paused == false){
    
    if ( gamepad.buttonX.pressed == true){
    
    playerBeingControlled!.xHeldDown = true
    playerBeingControlled?.run()
    self.pressedShoot ( playerBeingControlled! )
    
    } else if ( gamepad.buttonX.pressed == false){
    
    playerBeingControlled!.xHeldDown = false
    playerBeingControlled?.releaseRun()
    
    
    }
    
    } else {
    
    self.menuSelectionMade()
    
    }
    
    }
    
    
    
    
    }
    
    
    
    }
    #endif
    
    func checkWhoIsPlayingInOnePlayerMode(){
        
        
        
        for controller in GCController.controllers(){
            
            if (controller.playerIndex == .Index1){
                
                if ( onePlayerModeBasedOnControllers == true){
                    
                    activePlayerInOnePlayerMode = thePlayer
                    enemyPlayerInOnePlayerMode = thePlayer2
                    thePlayerCameraFollows = thePlayer
                    
                    
                    
                    self.cameraIcon2?.hidden = true
                    self.cameraIcon1?.hidden = false
                    
                    print("player 1 must still be playing")
                    
                }
                
            }
            else if (controller.playerIndex == .Index2){
                
                if ( onePlayerModeBasedOnControllers == true){
                    
                    thePlayerCameraFollows = thePlayer2
                    activePlayerInOnePlayerMode = thePlayer2
                    enemyPlayerInOnePlayerMode = thePlayer
                    
                    
                    
                    self.cameraIcon2?.hidden = false
                    self.cameraIcon1?.hidden = true
                    
                    print("player 2 must still be playing")
                    
                }
                
            }
            
        }
        
        //v1.2 was missing in tvOS but was iOS...
        
        if ( enemyPlayerInOnePlayerMode == nil){
            
            activePlayerInOnePlayerMode = thePlayer
            enemyPlayerInOnePlayerMode = thePlayer2
            thePlayerCameraFollows = thePlayer
            
            
            
            self.cameraIcon2?.hidden = true
            self.cameraIcon1?.hidden = false
            
        }
        
        
        
    }
    
    
    func controllerDisconnected(){
        
        print("disconnected")
        
        if ( GCController.controllers().count > 1) {
            
            onePlayerModeBasedOnControllers = false
            hideControllerLabel()
            
        } else {
            
            onePlayerModeBasedOnControllers = true
            showControllerLabel()
            
            print("putting game in one player mode")
            
            checkWhoIsPlayingInOnePlayerMode()
            setUpLoopsForOnePlayerMode()
        }
        
        
        
        
        
        
        
        checkPlayerIndexes()
        
        pauseScene()
        
        #if os(iOS)
            
            self.button1.alpha = 0.2
            self.button2.alpha = 0.2
            self.ball.alpha = 0.4
            self.base.alpha = 0.4
            
            
        #endif
        
        
    }
    
    
    
    
    func gcDownWithPlayer(playerBeingControlled:Player){
        
        if ( playerBeingControlled.playerIsDead == false) {
            
            if ( playerBeingControlled.onPole == true){
                
                playerBeingControlled.goDownPole()
                
                
            }
            
        }
        
        
    }
    
    func gcUpWithPlayer(playerBeingControlled:Player){
        
        if ( playerBeingControlled.playerIsDead == false) {
            
            if (playerBeingControlled.onPole == true ){
                
                
                playerBeingControlled.goUpPole()
                
                
            }
            
        }
        
        
    }
    
    func gcRightWithPlayer(playerBeingControlled:Player){
        
        if ( playerBeingControlled.playerIsDead == false) {
            
            playerBeingControlled.goRight()
            
        }
        
        
    }
    
    func gcLeftWithPlayer(playerBeingControlled:Player){
        
        if ( playerBeingControlled.playerIsDead == false) {
            
            playerBeingControlled.goLeft()
            
        }
        
    }
    
    func gcLiftUpDPadWithPlayer(playerBeingControlled:Player){
        
        
        if ( playerBeingControlled.playerIsDead == false) {
            
            if ( playerBeingControlled.onPole == true && playerBeingControlled.isClimbing == true){
                
                
            }
                
            else{
                
                playerBeingControlled.stopWalk()
                
            }
            
        }
        
    }
    
    //v1.2
    
    func stopMusicByGoingLeft(){
        
        if ( bgSoundPlaying == true){
            
            NSNotificationCenter.defaultCenter().postNotificationName("StopBackgroundSound", object: self)
            
            bgSoundPlaying = false
            
            trackCreditLabel.text = "Music Stopped"
            
        }
        
        
        
    }
    
    //v1.2
    
    func nextTrackByGoingRight(){
        
        
        
        
        
        if ( justStartedNewTrack == false && mp3List.count > 0) {
            
            print("next track")
            
            justStartedNewTrack = true
            
            trackNum++
            
            if ( trackNum >= mp3List.count){
                
                trackNum = 0
            }
            
            lastChosenTrack = trackNum
            
            
            let theFileName:String  = mp3List[trackNum]
            let theFileNameWithNoMp3:String  = theFileName.stringByReplacingOccurrencesOfString(".mp3", withString: "", options:NSStringCompareOptions.CaseInsensitiveSearch , range: nil)
            
            
            
            let dictToSend: [String: String] = ["fileToPlay":theFileNameWithNoMp3 ]
            
            NSNotificationCenter.defaultCenter().postNotificationName("PlayBackgroundSound", object: self, userInfo:dictToSend)
            
            bgSoundPlaying = true
            
            trackCreditLabel.text = "Now Playing: " + theFileNameWithNoMp3
            
            
        }
        
        
    }
    
    
    
    
    
}