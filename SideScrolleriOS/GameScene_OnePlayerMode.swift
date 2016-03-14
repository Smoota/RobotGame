//
//  GameScene_OnePlayerMode.swift
//  SideScroller
//
//  Created by Justin Dike 2 on 11/11/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
//

import Foundation
import SpriteKit
import GameController

extension GameScene {

    
    func cancelOnePlayerLoops(){
        
        self.removeActionForKey("EnemyPlayerShoot")
        self.removeActionForKey("EnemyPlayerJump")
        self.removeActionForKey("EnemyPlayerWalk")
        self.removeActionForKey("EnemyPlayerStop")
    }
    

    func setUpLoopsForOnePlayerMode(){
        
       
            
            shootLoopOnePlayerMode()
            jumpLoopOnePlayerMode()
            walkLoopOnePlayerMode()
            stopLoopOnePlayerMode()
        
    }
    
    func stopLoopOnePlayerMode(){
        
        
        
        let randTime:UInt32 = arc4random_uniform(4) + 1
        
        let wait:SKAction = SKAction.waitForDuration( NSTimeInterval( randTime ) )
        let run:SKAction = SKAction.runBlock{
            
                
            self.gcLiftUpDPadWithPlayer(self.enemyPlayerInOnePlayerMode!);
            self.stopLoopOnePlayerMode();
            
        }
        let seq:SKAction = SKAction.sequence([wait, run])
        
        self.runAction(seq, withKey:"EnemyPlayerStop" )
        
        
        
    }
    func walkLoopOnePlayerMode(){
        
        
        
        let randTime:UInt32 = arc4random_uniform(4) + 1
        
        let wait:SKAction = SKAction.waitForDuration( NSTimeInterval( randTime ) )
        let run:SKAction = SKAction.runBlock{
            
            if ( self.playerVersusPlayer == true) {
            
                //opposing player is always facing the opponent in player versus player
            
                if ( self.enemyPlayerInOnePlayerMode?.xScale == 1 ){
                
                    self.enemyPlayerInOnePlayerMode?.goRight()
                
                } else {
                
                    self.enemyPlayerInOnePlayerMode?.goLeft()
                }
            
                
            } else {
                
                let dice:UInt32 = arc4random_uniform(2)
                
                if ( dice == 0 ){
                    
                    self.enemyPlayerInOnePlayerMode?.xScale = 1
                    self.enemyPlayerInOnePlayerMode?.goRight()
                    
                    
                } else {
                    
                    self.enemyPlayerInOnePlayerMode?.xScale = -1
                    self.enemyPlayerInOnePlayerMode?.goLeft()
                }
                
            }
            
            
            
            self.walkLoopOnePlayerMode();
            
        }
        let seq:SKAction = SKAction.sequence([wait, run])
        
        self.runAction(seq, withKey:"EnemyPlayerWalk" )
        
        
        
    }
    
    
    func jumpLoopOnePlayerMode(){
        
        
        
        let randTime:UInt32 = arc4random_uniform(4) + 1
        
        let wait:SKAction = SKAction.waitForDuration( NSTimeInterval( randTime ) )
        let run:SKAction = SKAction.runBlock{
            
            self.enemyPlayerInOnePlayerMode?.jump()
            self.jumpLoopOnePlayerMode();
            
        }
        let seq:SKAction = SKAction.sequence([wait, run])
        
        self.runAction(seq, withKey:"EnemyPlayerJump" )
        
        
        
    }
    
    
    func shootLoopOnePlayerMode(){
        
        
        
        let randTime:UInt32 = arc4random_uniform(2) + 1
        
        let wait:SKAction = SKAction.waitForDuration( NSTimeInterval( randTime ) )
        let run:SKAction = SKAction.runBlock{
            
            self.shootInOnePlayerMode();
            self.shootLoopOnePlayerMode();
            
        }
        let seq:SKAction = SKAction.sequence([wait, run])
        
        self.runAction(seq, withKey:"EnemyPlayerShoot" )
        
        
        
    }
    
    
    func shootInOnePlayerMode() {
        
        if ( enemyPlayerInOnePlayerMode != nil) {
            
            shoot(enemyPlayerInOnePlayerMode!)
            
        }
        
        
    }
   
    
    
    
    
    
    func showControllerLabel(){
        
        self.connectController.position = self.controllerLocation
        self.connectController.hidden = false
       
    }
    func hideControllerLabel(){
        
        self.connectController.hidden = true
        
    }
    
   
    

}