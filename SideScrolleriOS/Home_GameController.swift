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

extension Home {
    
   
    func setUpControllerObservers(){
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "connectControllers", name: GCControllerDidConnectNotification, object: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "controllerDisconnected", name: GCControllerDidDisconnectNotification, object: nil)
        
        
    }
    
    func connectControllers(){
        
        
        

        //prioritize extended controllers 
        
        for controller in GCController.controllers(){
            

            if (controller.extendedGamepad != nil ){
                
                controller.extendedGamepad?.valueChangedHandler = nil
                setUpExtendedControlsWithIndexing(controller)

            } else if (controller.gamepad != nil){
                

                controller.gamepad?.valueChangedHandler = nil
                setUpStandardControlsWithIndexing(controller)
                
            }
            
        }
        
        
        
        
        
        
   
    }
    
    func setUpExtendedControlsWithIndexing(controller:GCController){
        
       

        controller.extendedGamepad?.valueChangedHandler = {
            (gamepad: GCExtendedGamepad, element:GCControllerElement) in
            
            
            
            
            if (gamepad.leftThumbstick == element){
                
                
                
                if (gamepad.leftThumbstick.down.pressed == true && self.canSelect == true){
                    
                    self.canSelect = false
                    self.selectDown()
                    
                } else if (gamepad.leftThumbstick.up.pressed == true && self.canSelect == true){
                    
                    self.canSelect = false
                   self.selectUp()
                    
                }
                    
                else if (gamepad.leftThumbstick.right.pressed == true && self.canSelect == true){
                    
                    self.canSelect = false
                     self.selectRight()
                    
                } else if (gamepad.leftThumbstick.left.pressed == true  && self.canSelect == true ){
                    
                    self.canSelect = false
                    self.selectLeft()
                    
                } else if (gamepad.leftThumbstick.left.pressed == false && gamepad.leftThumbstick.right.pressed == false && gamepad.leftThumbstick.up.pressed == false && gamepad.leftThumbstick.down.pressed == false){
                    
                     self.canSelect = true
                    
                } 
                
                
                
                
            }  else if (gamepad.dpad == element){
                
                if (gamepad.dpad.down.pressed == true && self.canSelect == true){
                     self.canSelect = false
                    self.selectDown()
                    
                    
                } else if (gamepad.dpad.up.pressed == true && self.canSelect == true){
                     self.canSelect = false
                     self.selectUp()
                    
                } else if (gamepad.dpad.right.pressed == true && self.canSelect == true){
                     self.canSelect = false
                    self.selectRight()
                    
                } else if (gamepad.dpad.left.pressed == true && self.canSelect == true){
                     self.canSelect = false
                     self.selectLeft()
                    
                } else if (gamepad.dpad.left.pressed == false && gamepad.dpad.right.pressed == false && gamepad.dpad.up.pressed == false && gamepad.dpad.down.pressed == false){
                    self.canSelect = true
                  
                    
                }
                
                
            } // ends if (gamepad.dpad == element){
            
            

            
             if (gamepad.buttonA == element ){
                
                if ( gamepad.buttonA.pressed == false){
                
   
                    self.pressedSelect()
                    
                }
                
                
            }
            else if (gamepad.buttonX == element){
                
                 self.pressedSelect()
            }
            
           
            else if (gamepad.buttonY == element){
                
                 self.pressedSelect()
            }
            
            
            
            

        }
        

    }
    
    func setUpStandardControlsWithIndexing(controller:GCController){
        
        
        
        controller.gamepad?.valueChangedHandler = {
            (gamepad: GCGamepad, element:GCControllerElement) in
            
           
            if (gamepad.dpad == element){
                
                if (gamepad.dpad.down.pressed == true && self.canSelect == true){
                    self.canSelect = false
                    self.selectDown()
                    
                    
                } else if (gamepad.dpad.up.pressed == true && self.canSelect == true){
                    self.canSelect = false
                    self.selectUp()
                    
                } else if (gamepad.dpad.right.pressed == true && self.canSelect == true){
                    self.canSelect = false
                    self.selectRight()
                    
                } else if (gamepad.dpad.left.pressed == true && self.canSelect == true){
                    self.canSelect = false
                    self.selectLeft()
                    
                } else if (gamepad.dpad.left.pressed == false && gamepad.dpad.right.pressed == false && gamepad.dpad.up.pressed == false && gamepad.dpad.down.pressed == false){
                    self.canSelect = true
                    
                    
                }
                
                
            } // ends if (gamepad.dpad == element){
            
            
             if (gamepad.buttonA == element ){
                
              
                 self.pressedSelect()
                
            }
            else if (gamepad.buttonX == element){
                
               
                     self.pressedSelect()
                    
            }
                
                
            else if (gamepad.buttonY == element){
                    
                 self.pressedSelect()

                    
            }
                
          
            
            
        }
        

    }
    
    
    
    func controllerDisconnected(){
        
        print("disconnected")
        
        
    }
    
    

    
    
    
}