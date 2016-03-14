//
//  Button.swift
//  SideScroller
//
//  Created by Justin Dike 2 on 11/24/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
//

import Foundation
import SpriteKit


class Button: SKSpriteNode {

    var currentTextureName:String?
    var selectedTexture:SKTexture?
    var initialTexture:SKTexture?
    var isSelected:Bool = false
    var selectedImage:String = "SomeImage"
    
    var playerVersusPlayer:Bool = false
    var levelToLoad:Int = 1
    var continueLastLevel:Bool = false
    var singlePlayerGame:Bool = false
    var secondPlayerIsCPU:Bool = false
    var levelsName:String = "Levels"
    var reportHighScore:Bool = false
    var showGameCenter:Bool = false
    var loadHomeScene:String = ""//don't give this a default value. Home class will check to see if this equals "" (nothing)
    var disableIfNotReached:Bool = false
     var isDisabled:Bool = false
    
    var soundButtonSelect:String = ""
    var soundButtonPress:String = ""
    
    
    var defaults:NSUserDefaults =  NSUserDefaults.standardUserDefaults()
    
    func createButton(){
        
        
        initialTexture = self.texture
        
        selectedTexture = SKTexture(imageNamed: selectedImage)
        
        
        if ( disableIfNotReached == true && levelToLoad > 1) {
            
            if (defaults.integerForKey("LastLevel") < levelToLoad) {
                
                self.alpha = 0.4
                levelToLoad = defaults.integerForKey("LastLevel")
                isDisabled = true
                
                print ("Button is set to be disabled if the player hasn't reached this level. The last level passed is \(levelToLoad)")
                
            }
            
            
        }
        
    }
    
    func select(){
    
        self.texture = selectedTexture
        
        playSound(soundButtonSelect)
        
        
    }
    
    func deselect(){
        
        self.texture = initialTexture
        
    }
    
    func playSound(theSound:String ){
        
        if (theSound != ""){
        
        let sound:SKAction = SKAction.playSoundFileNamed(theSound, waitForCompletion: true)
        self.runAction(sound)
            
        }
        
    }

}