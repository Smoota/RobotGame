//
//  Portal.swift
//  SideScroller
//
//  Created by Justin Dike 2 on 10/21/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
//

import Foundation
import SpriteKit


class Enemy: SKSpriteNode {
    
    
    
    var hasProperties:Bool = false
    var spawnNode:String = ""
    var reviveTime:NSTimeInterval = 0
    var reviveCount:Int = 0
    
    var timesRevived:Int = 0
    
    var speedAfterRevive:CGFloat = 0
    
    var treatLikeBullet:Bool = false
    
    var theSpeed:CGFloat = 0
    
    var atlasName:String = ""
    
    var walkFrames = [String]()
    var angryWalkFrames = [String]()
    var deadFrames = [String]()
    var hurtFrames = [String]()
    var shootFrames = [String]()
    var angryShootFrames = [String]()
    var attackFrames = [String]()
    var angryAttackFrames = [String]()
    
    var angryWalkAction:SKAction?
    var walkAction:SKAction?
    var deadAction:SKAction?
    var hurtAction:SKAction?
    var shootAction:SKAction?
    var angryShootAction:SKAction?
    var attackAction:SKAction?
    var angryAttackAction:SKAction?
    
    var angryWalkFPS:NSTimeInterval = 30
    var walkFPS:NSTimeInterval = 10
    var hurtFPS:NSTimeInterval = 10
    var deadFPS:NSTimeInterval = 10
    var shootFPS:NSTimeInterval = 10
    var angryShootFPS:NSTimeInterval = 20
    var attackFPS:NSTimeInterval = 10
    var angryAttackFPS:NSTimeInterval = 20
    
    var jumpOnToKill:Bool = false
    var jumpThreshold:CGFloat = 0
    var jumpOnBounceBack:CGFloat = 500
    
    var isDown:Bool = false
    var isDead:Bool = false
    var blinkToDeath:Bool = false
    var score:Int = 0
    var enemyKillCount:Int = 1
    
    var bodyOffset:CGPoint = CGPointZero
    
    var soundEnemyEnter:String = ""
    var soundEnemyHurt:String = ""
    var soundEnemyDie:String = ""
    var soundEnemyAttack:String = ""
    
    var preloadedSoundEnemyEnter:SKAction?
    var preloadedSoundEnemyHurt:SKAction?
    var preloadedSoundEnemyDie:SKAction?
    var preloadedSoundEnemyAttack:SKAction?
    
    var moveUpAndDown:Bool = false
    var moveUpAndDownAmount:CGFloat = 20
    var moveUpAndDownTime:NSTimeInterval = 0.5
    
    var removeOutsideBoundary:Bool = false
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    init (image:String, theBodyType:String, theBodyOffset:CGPoint, radiusDivider:CGFloat, bodySize:CGSize ) {
        
        
        let imageTexture = SKTexture(imageNamed: image)
        super.init(texture: imageTexture, color:SKColor.clearColor(), size: imageTexture.size() )
        
        self.texture = imageTexture
        
        var body:SKPhysicsBody = SKPhysicsBody()
        
       
        
        if ( theBodyType == "Alpha"){
        
            body = SKPhysicsBody(texture: imageTexture, alphaThreshold: 0, size: imageTexture.size() )
            
        } else if ( theBodyType == "Circle"){
           
            body = SKPhysicsBody(circleOfRadius: imageTexture.size().width / radiusDivider, center:theBodyOffset )
            
        } else if ( theBodyType == "Rectangle"){
            
            body = SKPhysicsBody(rectangleOfSize: bodySize, center: theBodyOffset)
            
        }
        
        self.physicsBody = body
        
        self.physicsBody?.categoryBitMask = BodyType.enemy.rawValue
        self.physicsBody?.collisionBitMask = BodyType.player.rawValue | BodyType.platform.rawValue | BodyType.bullet.rawValue  |  BodyType.coin.rawValue | BodyType.enemybumper.rawValue
        
        
      
            
            self.physicsBody?.contactTestBitMask = BodyType.player.rawValue  | BodyType.bullet.rawValue | BodyType.enemybumper.rawValue
            
        
        
        self.physicsBody?.dynamic = true
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.allowsRotation = false
        
        self.physicsBody?.restitution = 0
        self.physicsBody?.friction = 1
        
        
        
        
        
        
    }
    
    
    func makeAdjustments(){
        
        if ( treatLikeBullet == true){
            
            //adding in platform if treated like bullet
            
            
            
            self.physicsBody?.contactTestBitMask = BodyType.player.rawValue  | BodyType.bullet.rawValue | BodyType.platform.rawValue
            
        }
        
        
    }
    
    
   
    
    func setUpAnimations(){
        
        
       
        
        if (walkFrames.count > 0){
            
            setUpWalkAnimation()
            self.runAction(walkAction!, withKey: "Walk")
            
        }
        if (deadFrames.count > 0){
            
            setUpDeadAnimation()
            
        }
        if (hurtFrames.count > 0){
            
            setUpHurtAnimation()
            
        }
        if (angryWalkFrames.count > 0){
            
            setUpAngryWalkAnimation()
            
        }
        
        if (shootFrames.count > 0){
            
            setUpShootAnimation()
            
        }
        if (angryShootFrames.count > 0){
            
            setUpAngryShootAnimation()
            
        }
        
        if (attackFrames.count > 0){
            
            setUpAttackAnimation()
            
        }
        if (angryAttackFrames.count > 0){
            
            setUpAngryAttackAnimation()
            
        }
        
        
        if ( moveUpAndDown == true){
            
          
            self.physicsBody?.affectedByGravity = false
            startToMoveUpAndDown()
        }
        
    }
    
    func preloadSounds(){
        
        
        if (soundEnemyAttack != ""){
            
            preloadedSoundEnemyAttack = SKAction.playSoundFileNamed(soundEnemyAttack, waitForCompletion: false)
            
        }
        if (soundEnemyEnter != ""){
            
            preloadedSoundEnemyEnter = SKAction.playSoundFileNamed(soundEnemyEnter, waitForCompletion: false)
            
        }
        if (soundEnemyHurt != ""){
            
            preloadedSoundEnemyHurt = SKAction.playSoundFileNamed(soundEnemyHurt, waitForCompletion: false)
            
        }
        if (soundEnemyDie != ""){
            
            preloadedSoundEnemyDie = SKAction.playSoundFileNamed(soundEnemyDie, waitForCompletion: false)
            
        }
        
        
    }
    
    
    func reverse(){
        
        
        
        if ( self.xScale == 1){
            
            self.xScale = -1
            self.position = CGPointMake(self.position.x + 2, self.position.y )
            
        } else {
            
            self.xScale = 1
            self.position = CGPointMake(self.position.x - 2, self.position.y )
        }
        
        
    }
    
    func update(){
        
        if (self.xScale == 1) {
            
            self.position = CGPointMake(self.position.x + theSpeed, self.position.y )
            
            
        } else {
            
            self.position = CGPointMake(self.position.x - theSpeed, self.position.y )
        }
        

    }
    
    func setUpWalkAnimation() {
        
        let atlas  = SKTextureAtlas(named:atlasName)
        
        var atlasTextures = [SKTexture]()
        
        for name in walkFrames {
            
            let texture:SKTexture = atlas.textureNamed( name )
            atlasTextures.append(texture)
            
        }
        
        let atlasAnimation = SKAction.animateWithTextures(atlasTextures, timePerFrame: 1 / walkFPS, resize:true, restore:false )
        walkAction = SKAction.repeatActionForever(atlasAnimation)
        
       
        
        
    }
    func setUpAngryWalkAnimation() {
        
        let atlas  = SKTextureAtlas(named:atlasName)
        
        var atlasTextures = [SKTexture]()
        
        for name in angryWalkFrames {
            
            let texture:SKTexture = atlas.textureNamed( name )
            atlasTextures.append(texture)
            
        }
        
        let atlasAnimation = SKAction.animateWithTextures(atlasTextures, timePerFrame: 1 / angryWalkFPS, resize:true, restore:false )
        angryWalkAction = SKAction.repeatActionForever(atlasAnimation)
        
        
        
        
    }
    
    
    func setUpDeadAnimation() {
        
        let atlas  = SKTextureAtlas(named:atlasName)
        
        var atlasTextures = [SKTexture]()
        
        for name in deadFrames {
            
            let texture:SKTexture = atlas.textureNamed( name )
            atlasTextures.append(texture)
            
        }
        
        deadAction =  SKAction.animateWithTextures(atlasTextures, timePerFrame: 1 / deadFPS, resize:true, restore:false )
        

    }
    
    func setUpHurtAnimation() {
        
        let atlas  = SKTextureAtlas(named:atlasName)
        
        var atlasTextures = [SKTexture]()
        
        for name in hurtFrames {
            
            let texture:SKTexture = atlas.textureNamed( name )
            atlasTextures.append(texture)
            
        }
        
        hurtAction =  SKAction.animateWithTextures(atlasTextures, timePerFrame: 1 / hurtFPS , resize:true, restore:false )
        
        
    }
    
    func setUpShootAnimation() {
        
        let atlas  = SKTextureAtlas(named:atlasName)
        
        var atlasTextures = [SKTexture]()
        
        for name in shootFrames {
            
            let texture:SKTexture = atlas.textureNamed( name )
            atlasTextures.append(texture)
            
        }
        
        
        
        let atlasAnimation = SKAction.animateWithTextures(atlasTextures, timePerFrame: 1 / shootFPS, resize:true, restore:false )
        let run:SKAction = SKAction.runBlock{
            
            if (self.walkAction != nil) {
                    
                    self.runAction(self.walkAction!, withKey:"Walk")
                    
            }
            
        }
        shootAction = SKAction.sequence( [atlasAnimation, run ] )
        
    }
    func setUpAngryShootAnimation() {
        
        let atlas  = SKTextureAtlas(named:atlasName)
        
        var atlasTextures = [SKTexture]()
        
        for name in angryShootFrames {
            
            let texture:SKTexture = atlas.textureNamed( name )
            atlasTextures.append(texture)
            
        }
        
        
        
        let atlasAnimation = SKAction.animateWithTextures(atlasTextures, timePerFrame: 1 / angryShootFPS, resize:true, restore:false )
        let run:SKAction = SKAction.runBlock{
            
            if (self.angryWalkAction != nil) {
                
                self.runAction(self.angryWalkAction!, withKey:"Walk")
                
            } else if (self.walkAction != nil) {
                
                self.runAction(self.walkAction!, withKey:"Walk")
                
            }

            
        }
        angryShootAction = SKAction.sequence( [atlasAnimation, run ] )
        
    }
    
    func setUpAttackAnimation() {
        
        let atlas  = SKTextureAtlas(named:atlasName)
        
        var atlasTextures = [SKTexture]()
        
        for name in attackFrames {
            
            let texture:SKTexture = atlas.textureNamed( name )
            atlasTextures.append(texture)
            
        }
        
        
        
        let atlasAnimation = SKAction.animateWithTextures(atlasTextures, timePerFrame: 1 / attackFPS, resize:true, restore:false )
        let run:SKAction = SKAction.runBlock{
            
            if (self.walkAction != nil) {
                
                self.runAction(self.walkAction!, withKey:"Walk")
                
            }
            
        }
        attackAction = SKAction.sequence( [atlasAnimation, run ] )
        
    }
    func setUpAngryAttackAnimation() {
        
        let atlas  = SKTextureAtlas(named:atlasName)
        
        var atlasTextures = [SKTexture]()
        
        for name in angryAttackFrames {
            
            let texture:SKTexture = atlas.textureNamed( name )
            atlasTextures.append(texture)
            
        }
        
        
        
        let atlasAnimation = SKAction.animateWithTextures(atlasTextures, timePerFrame: 1 / angryAttackFPS, resize:true, restore:false )
        let run:SKAction = SKAction.runBlock{
            
            if (self.angryWalkAction != nil) {
                
                self.runAction(self.angryWalkAction!, withKey:"Walk")
                
            } else if (self.walkAction != nil) {
                
                self.runAction(self.walkAction!, withKey:"Walk")
                
            }
            
            
        }
        angryAttackAction = SKAction.sequence( [atlasAnimation, run ] )
        
    }
    
    
    
    func shot(){
        
        if ( isDown == false && isDead == false) {
        
            isDown = true
            
             self.removeAllActions()
            
            if ( self.moveUpAndDown == true){
                
                self.physicsBody?.affectedByGravity = true
                
            }
            
        
            self.theSpeed = 0
            
            self.physicsBody?.collisionBitMask =  BodyType.platform.rawValue
            self.physicsBody?.contactTestBitMask = 0
        
            if ( reviveCount > 0){
                
                if (timesRevived >= reviveCount){
                
                    //don't revive
                    
                   
                    playSound(soundEnemyDie)
                    
                    isDead = true
                    
                    if ( blinkToDeath == true) {
                        
                        if ( deadAction != nil) {
                        
                            let run:SKAction = SKAction.runBlock {
                                
                                self.blinkOut()
                            }
                            
                            self.runAction( SKAction.sequence( [deadAction!, run  ] ))
                            
                            
                        } else {
                            
                            blinkOut()
                            
                        }
                        
                       
                        
                    } else {
                        
                        
                        if ( deadAction != nil) {
                            
                            let remove:SKAction = SKAction.removeFromParent()
                            self.runAction( SKAction.sequence( [deadAction!, remove  ] ))
                            
                        } else {
                            
                            self.removeFromParent()
                        }
                        
                        
                    }
                
                } else {
                    
                    //Not dead, just hurt
                    
                    playSound(soundEnemyHurt)
                    //
                    if ( hurtAction != nil) {
                    
                    self.runAction(hurtAction!, withKey: "Hurt")
                        
                    }
                    
                    
                    
                    
                    let wait:SKAction = SKAction.waitForDuration(reviveTime - 1)
                    let wiggleRight:SKAction = SKAction.moveByX(-2, y: 0, duration: 1 / 10)
                    let wiggleLeft:SKAction = SKAction.moveByX(2, y: 0, duration: 1 / 10)
                    let seq:SKAction = SKAction.sequence([wiggleRight, wiggleLeft])
                    let repeatSeq:SKAction = SKAction.repeatAction(seq, count: 5)
                    
                    let run:SKAction = SKAction.runBlock{
                        
                        self.timesRevived++
                        self.removeActionForKey("Hurt")
                        
                        if ( self.angryWalkAction != nil){
                            
                            self.runAction(self.angryWalkAction!, withKey:"WalK")
                            
                        }
                        
                        else if ( self.walkAction != nil){
                        
                            self.runAction(self.walkAction!, withKey:"WalK")
                        
                        }
                        
                        
                        if ( self.moveUpAndDown == true){
                            self.physicsBody?.affectedByGravity = false
                            self.startToMoveUpAndDown()
                        }
                        
                        self.isDown = false
                        self.theSpeed = self.speedAfterRevive
                        self.physicsBody?.collisionBitMask =  BodyType.platform.rawValue | BodyType.player.rawValue | BodyType.bullet.rawValue
                        self.physicsBody?.contactTestBitMask = BodyType.player.rawValue | BodyType.bullet.rawValue
                        
                    }
                    let seq2:SKAction = SKAction.sequence([wait,repeatSeq, run ])
                    
                    self.runAction(seq2)
                    
                    
                    
                    
                }
            
                
            } else {
                
                
                
                
                isDead = true
                
                playSound(soundEnemyDie)
               
                if ( blinkToDeath == true) {
                    
                    if ( deadAction != nil) {
                    
                        let run:SKAction = SKAction.runBlock {
                            
                            self.blinkOut()
                        }
                        
                        self.runAction( SKAction.sequence( [deadAction!, run  ] ))
                        
                    } else {
                   
                        blinkOut()
                        
                    }
                    
                } else {
                    
                    if ( deadAction != nil) {
                        
                        let remove:SKAction = SKAction.removeFromParent()
                        self.runAction( SKAction.sequence( [deadAction!, remove  ] ))
                        
                    } else {
                        
                        self.removeFromParent()
                    }
                    
                }
                
                
            }
        
            
        }
        
    }
    
    
    func blinkOut(){
        
        let hide:SKAction = SKAction.hide()
        let wait:SKAction = SKAction.waitForDuration(0.05)
        let unhide:SKAction = SKAction.unhide()
        
        let seq:SKAction = SKAction.sequence( [hide, wait,unhide, wait])
        let repeatAction:SKAction = SKAction.repeatAction(seq, count: 6)
        let remove:SKAction = SKAction.removeFromParent()
        let seq2:SKAction = SKAction.sequence( [repeatAction, remove] )
        
        self.runAction(seq2)
        
        
    }
    
    func startToMoveUpAndDown(){
        
        let moveUp:SKAction = SKAction.moveByX(0, y: moveUpAndDownAmount, duration: moveUpAndDownTime)
        let moveDown:SKAction = SKAction.moveByX(0, y: -moveUpAndDownAmount, duration: moveUpAndDownTime)
        let seq:SKAction = SKAction.sequence( [moveUp, moveDown])
        let repeatSeq:SKAction = SKAction.repeatActionForever(seq)
        self.runAction(repeatSeq, withKey: "MoveUpAndDown")
        
    }
    
    func playSound(theSound:String ){
        
        if (theSound != ""){
            
            if (soundEnemyAttack == theSound){
                
                if (preloadedSoundEnemyAttack != nil){
                    
                    self.runAction(preloadedSoundEnemyAttack!)
                    
                }
                
                
            }
            else if (soundEnemyEnter == theSound){
                
                if (preloadedSoundEnemyEnter != nil){
                    
                    self.runAction(preloadedSoundEnemyEnter!)
                    
                }
            }
            else if (soundEnemyHurt == theSound){
                
                if (preloadedSoundEnemyHurt != nil){
                    
                    self.runAction(preloadedSoundEnemyHurt!)
                    
                }
            }
            else if (soundEnemyDie == theSound){
                
                if ( preloadedSoundEnemyDie != nil){
                    
                    self.runAction(preloadedSoundEnemyDie!)
                    
                }
                
            } else {
                
                let sound:SKAction = SKAction.playSoundFileNamed(theSound, waitForCompletion: true)
                self.runAction(sound)
                
            }
            
            
            
            
        }
        
    }
    
    
    func enemyShoot(){
        
       
        
        //called when an enemy is spawned from another enemy
        
        if ( timesRevived >= 1){
            
            if ( angryShootAction != nil){
                
                self.runAction(angryShootAction! , withKey:"Shoot")
                
            } else if ( shootAction != nil){
                
                self.runAction(shootAction! , withKey:"Shoot")
                
            }
            
            
        } else {
        
        
            if ( shootAction != nil){
            
                self.runAction(shootAction! , withKey:"Shoot")
            
            }
            
        }
        
        
    }
    
    
    func attack(){
        
        if ( timesRevived >= 1 && angryAttackFrames.count != 0){
            
            self.runAction(angryAttackAction! , withKey:"Attack")
            
            print("running angry attack")
            
        } else if (attackFrames.count != 0 ){
            
             self.runAction(attackAction! , withKey:"Attack")
            
            print(" normal attack")
        }
        
        
    }
    
    
}



