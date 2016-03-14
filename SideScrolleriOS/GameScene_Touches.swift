//
//  GameScene_Touches.swift
//  SideScrolleriOS
//
//  Created by Justin Dike 2 on 12/4/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
//

import Foundation
import SpriteKit


extension GameScene {

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        
        
        
        for touch in (touches ) {
            let location = touch.locationInNode(self)
            
            let convertedLocation:CGPoint = self.convertPoint(location, toNode: theCamera)
            
            
            if ( self.paused == true){
                
                if (CGRectContainsPoint(resumeGame!.frame,  convertedLocation)) {
                    
                   
                        unpauseScene()
                    
                    
                } else if (CGRectContainsPoint(mainMenu!.frame,  convertedLocation)) {
                    
                    
                    goBackToMainMenu()
                    
                    
                } else if (CGRectContainsPoint(pauseButton.frame,  convertedLocation)) {
                    
                   
                        
                        unpauseScene()
                    
                    
                }
                
                
                
            } else {
            
            //scene is not paused
            
            if (CGRectContainsPoint(pauseButton.frame,  convertedLocation)) {
                
                if ( self.paused == false){
                    
                    pauseScene()
                    
                } else {
                    
                    unpauseScene()
                }
                
            }
            
            else if (CGRectContainsPoint(button1.frame,  convertedLocation)) {
                
                thePlayer.xHeldDown = true
                
                self.pressedShoot(thePlayer)
                
                button1.alpha = 0.3
                
            } else if (CGRectContainsPoint(button2.frame, convertedLocation)) {
                
                button2.alpha = 0.3
                
                self.pressedJump ( thePlayer )
                
            } else if (convertedLocation.x < 0 ) {
                
                //location is left of camera
                
                stickActive = true
                
               
                
                ball.alpha = 0.4
                base.alpha = 0.4
                
                base.position = convertedLocation
                ball.position = convertedLocation
                
            } else {
                
                stickActive = false
                
                
            }
                
            }
            
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in (touches ) {
            let location = touch.locationInNode(self)
            
            let convertedLocation:CGPoint = self.convertPoint(location, toNode: theCamera)
            
            //v1.3
            if ( self.paused == true && convertedLocation.x < 0) {
                
                stopMusicByGoingLeft()
                
                
                
            } else if ( self.paused == true && convertedLocation.x > 0) {
                
                nextTrackByGoingRight()
                
                
                
            }
            else if (convertedLocation.x < 0 && self.paused == false) {
                //checks that x was on the left side of the screen
                
                
                let v = CGVector(dx: convertedLocation.x - base.position.x, dy:  convertedLocation.y - base.position.y)
                let angle = atan2(v.dy, v.dx)
                
               
                //println( deg + 180 )
                
                
                
                
                let length:CGFloat = base.frame.size.height / 2
                
                //let length:CGFloat = 40
                
                let xDist:CGFloat = sin(angle - 1.57079633) * length
                let yDist:CGFloat = cos(angle - 1.57079633) * length
                
                
                if (CGRectContainsPoint(base.frame, convertedLocation)) {
                    
                    ball.position = convertedLocation
                    
                } else {
                    
                    ball.position = CGPointMake( base.position.x - xDist, base.position.y + yDist)
                    
                }
                
                
                
                if ( thePlayer.onPole == false ){
                
                    if ( xDist < 0) {
                        
                        
                            
                            gcRightWithPlayer(thePlayer)
                      
                        
                        
                    } else {
                        
                       
                        
                            gcLeftWithPlayer(thePlayer)
                      
                    }
                    
                } else {
                    
                    
                    if ( abs(yDist) > abs(xDist) ){
                        
                        //go up or down
                        if ( yDist > 0) {
                            
                            gcUpWithPlayer(thePlayer)
                            
                        } else {
                            
                            gcDownWithPlayer(thePlayer)
                        }
                        
                        
                    } else {
                        
                        if ( xDist < 0) {
                            
                           
                                
                                gcRightWithPlayer(thePlayer)
                                
                           
                            
                        } else {
                            
                            
                                
                                gcLeftWithPlayer(thePlayer)
                                
                            
                        }
                        
                    }
                    
                   
                
                
                }
               
                
                
            } // ends stickActive test
            
            
            
        }
        
        
    }
    
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        thePlayer.xHeldDown = false
        
         justStartedNewTrack = false
        
        resetJoyStick()
        
         button1.alpha = 0.1
         button2.alpha = 0.1
        
        if (stickActive == true) {
            
            // let go for joystick
            
           self.gcLiftUpDPadWithPlayer(thePlayer)
            
        } else if (stickActive == false) {
            
            //assumes let go of a button
            
            
            
        }
        
    }
    
    
    
    
    
    func resetJoyStick(){
        
        
        
        let move:SKAction = SKAction.moveTo(base.position, duration: 0.2)
        move.timingMode = .EaseOut
        
        ball.runAction(move)
        
        
        let fade:SKAction = SKAction.fadeAlphaTo(0, duration: 0.3)
        
        ball.runAction(fade)
        base.runAction(fade)
        
        
        
        
    }




}