//
//  Bullet.swift
//  SideScroller
//
//  Created by Justin Dike 2 on 10/28/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
//

import Foundation
import SpriteKit

class Bullet:SKSpriteNode {
    
    var explodeAction:SKAction?
    var isExploding:Bool = false
    
    var soundBulletImpact:String = ""
    
    var theSpeed:CGFloat = 10
    
    var weaponRotationSpeed:Float = 0
    
    var image:String = "bullet"
    
    var whoFired:String = "Player1"
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
   
    init () {
        
        
        let imageTexture = SKTexture(imageNamed: image)
        super.init(texture: imageTexture, color:SKColor.clearColor(), size: imageTexture.size() )
        
        
    }
    
    func setUpBulletWithName(weaponName:String){
        
        
        let imageTexture = SKTexture(imageNamed: weaponName)
        
       self.size = imageTexture.size()
        
        self.texture = imageTexture
        let body:SKPhysicsBody = SKPhysicsBody(texture: imageTexture, alphaThreshold: 0, size: imageTexture.size() )
        
        self.physicsBody = body
        
        body.dynamic = true
        body.affectedByGravity = false
        body.allowsRotation = true
        
        body.restitution = 0
        
        self.zPosition = 99
        
        body.categoryBitMask = BodyType.bullet.rawValue
        body.collisionBitMask = BodyType.platform.rawValue  | BodyType.player.rawValue |  BodyType.deadZone.rawValue
        body.contactTestBitMask =  BodyType.platform.rawValue  | BodyType.player.rawValue | BodyType.bullet.rawValue 
        
       
        setUpExplodeAnimation()
        
        
        if ( weaponRotationSpeed != 0){
            
            let rotate:SKAction = SKAction.rotateByAngle(360, duration: NSTimeInterval(weaponRotationSpeed) )
            let repeatRotate:SKAction = SKAction.repeatActionForever(rotate)
            self.runAction(repeatRotate, withKey: "Rotate")
            
        }
        
        
        
    }
    

    
   
    func explode(){
        
        if ( isExploding == false) {
            
            self.physicsBody = nil
            self.zPosition = 3000
            self.removeActionForKey("Rotate")
            
            isExploding = true
            
            theSpeed = 0
            
            playSound(soundBulletImpact)
            
            self.runAction(explodeAction!)
            
        }
       
        
    }
    
    
    
    func update() {
        
        
        
            if (self.xScale == 1) {
            
                self.position = CGPointMake(self.position.x + theSpeed, self.position.y )
            
            
            } else {
            
                self.position = CGPointMake(self.position.x - theSpeed, self.position.y )
            }
        
       
        
    }
    
    
    func setUpExplodeAnimation() {
        
        let atlas  = SKTextureAtlas(named:"Explode")
        
        var array = [String]()
        
        
        for (var i = 1; i <= 9; i++ ) {
            
            let nameString = String(format: "Explode%i", i)
            array.append(nameString)
            
        }
        
        var atlasTextures = [SKTexture]()
        
        for (var k = 0; k < array.count; k++ ) {
            
            let texture:SKTexture = atlas.textureNamed( array[k] )
            
            //let texture:SKTexture = SKTexture(imageNamed: array[k])  //if not using the .atlas folder
            atlasTextures.append(texture)
            
        }
        
        let atlasAnimation:SKAction =  SKAction.animateWithTextures(atlasTextures, timePerFrame: 1/20, resize:true, restore:false )
        let run:SKAction = SKAction.runBlock{
            
            self.removeFromParent();
        }
        
        explodeAction = SKAction.sequence( [ atlasAnimation, run] )
        
    }

    func playSound(theSound:String ){
        
        if (theSound != ""){
        
            let sound:SKAction = SKAction.playSoundFileNamed(theSound, waitForCompletion: true)
            self.runAction(sound)
            
        }
        
    }
    
}







