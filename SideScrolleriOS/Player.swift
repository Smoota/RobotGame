//
//  Player.swift
//  SideScroller
//
//  Created by Justin Dike 2 on 10/20/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
//

import Foundation
import SpriteKit






class Player: SKSpriteNode {
    
    
    var cantBeHurt:Bool = false 
    
    var atlasName:String = ""
    
    var weaponOffset:CGPoint = CGPointZero
    
    var xHeldDown:Bool = false
    var bodyType:String = "Circle"
    var bodyOffset:CGPoint = CGPointZero
    var radiusDivider:CGFloat = 2
    var bodySize:CGSize = CGSizeMake(20, 20)
    
    var walkArray = [String]()
    var runArray = [String]()
    var climbArray = [String]()
    var jumpArray = [String]()
    var deadArray = [String]()
    var idleArray = [String]()
    var shootArray = [String]()
    
    
    var runAction:SKAction?
    var walkAction:SKAction?
    var idleAction:SKAction?
    var deadAction:SKAction?
    var jumpAction:SKAction?
    var climbAction:SKAction?
    var shootAction:SKAction?
    
    
    var runFPS:NSTimeInterval = 60
    var walkFPS:NSTimeInterval = 30
    
    var deadFPS:NSTimeInterval = 10
    var shootFPS:NSTimeInterval = 10
    var climbFPS:NSTimeInterval = 10
    var idleFPS:NSTimeInterval = 10
    var jumpFPS:NSTimeInterval = 10
    
    var currentDirection:Direction = .None
    var currentSpeed:CGFloat = 4
    var maxSpeed:CGFloat = 4
    var speedBoost:CGFloat = 0
    var climbSpeed:CGFloat = 2
    
    var timeBetweenFiring:NSTimeInterval = 0.2
    var reviveTime:NSTimeInterval = 1
    
    var weaponSpeed:Int = 10
    var weaponRotationSpeed:Float = 0
    var weaponImage:String = "bullet"
    
    var weaponDelay:Float = 0
    
    var jumpAmount:Int = 500
    var doubleJumpAmount:Int = 0
    
    
    
    var isJumping:Bool = false
    
    var isClimbing:Bool = false
    var onPole:Bool = false
    
    var playerIsDead = false
    
    var physicsOffset:CGPoint = CGPointMake(0, -13)
    
    var canFireAgain:Bool = true
    var canJumpAgain:Bool = true
    var canDoubleJumpAgain:Bool = true
    
    var soundJump:String = ""
    var soundLand:String = ""
    var soundLoseHeart:String = ""
    var soundDead:String = ""
    var soundBounce:String = ""
    var soundShoot:String = ""
    var soundBulletImpact:String = ""
    var soundNoAmmo:String = ""
    
    var preloadedSoundJump:SKAction?
    var preloadedSoundLand:SKAction?
    var preloadedSoundLoseHeart:SKAction?
    var preloadedSoundBounce:SKAction?
    var preloadedSoundShoot:SKAction?
    var preloadedSoundBulletImpact:SKAction?
    var preloadedSoundNoAmmo:SKAction?
    var preloadedSoundDead:SKAction?
    
    var currentLevel:Int = 1
    var levelsName:String = "Levels"  //the array of levels 
    var isDoubleJumpingAllowed:Bool = false
    
    
    var isRunning:Bool = false
    
    func setUpPlayer() {
        
        
        
        
        parsePlayersDictionaryInLevel() // will check for Players dictionary in the current level. If none found, will fall back to checking the root
        
        
        maxSpeed = currentSpeed
        
        
       if ( bodyType == "Circle"){
            
           let body:SKPhysicsBody = SKPhysicsBody(circleOfRadius: self.frame.size.width / radiusDivider, center:bodyOffset )
        
            self.physicsBody = body
        
            body.dynamic = true
            body.affectedByGravity = true
            body.allowsRotation = false
        
            body.restitution = 0
            body.friction = 1
        
        } else if ( bodyType == "Rectangle"){
            
            let body:SKPhysicsBody = SKPhysicsBody(rectangleOfSize: bodySize, center: bodyOffset)
        
            self.physicsBody = body
        
            body.dynamic = true
            body.affectedByGravity = true
            body.allowsRotation = false
        
            body.restitution = 0
            body.friction = 1
            
        }

      
        
        
        
        self.physicsBody?.categoryBitMask = BodyType.player.rawValue
        self.physicsBody?.collisionBitMask = BodyType.platform.rawValue | BodyType.player.rawValue |  BodyType.deadZone.rawValue | BodyType.bumper.rawValue
        self.physicsBody?.contactTestBitMask = BodyType.platform.rawValue | BodyType.pole.rawValue |  BodyType.portal.rawValue |  BodyType.deadZone.rawValue |  BodyType.coin.rawValue | BodyType.player.rawValue
        
        self.physicsBody?.usesPreciseCollisionDetection = false
        self.xScale = 1
        
        
       if ( idleArray.count != 0){
        
            setUpIdleAnimation()
            self.runAction(idleAction!, withKey: "Idle")
        
        }
        
        if ( jumpArray.count != 0){
            
            setUpJumpAnimation()
        }
        
        if ( walkArray.count != 0){
            setUpWalkAnimation()
            
        }
        if ( runArray.count != 0){
            setUpRunAnimation()
            
        }
        
        if ( deadArray.count != 0){
            
            setUpDeadAnimation()
        }
        
        if (shootArray.count != 0) {
            
            setUpShootAnimation()
            
        }
        

        if ( climbArray.count != 0){
            
            setUpClimbAnimation()
            
        }
        
        
       
        
        self.currentDirection = .None
        
    }
    
     func parsePlayersDictionaryInLevel(){
        
         var playersDictionaryInLevelFound:Bool = false
        
        let path = NSBundle.mainBundle().pathForResource("LevelData", ofType: "plist")
        
        let dict:NSDictionary = NSDictionary(contentsOfFile: path!)!
        
        
        if (dict.objectForKey(levelsName) != nil) {
            
           
            
            if let levelData = dict.objectForKey(levelsName) as? [AnyObject] {
                
                var counter:Int = 1
                
                for theDictionary in levelData {
                    
                    if (currentLevel == counter) {
                        
                        // this is the current level we are interested in
                        
                        if (theDictionary is [String : AnyObject]) {
                            
                            if let currentDictionary:[String : AnyObject] = theDictionary as? [String : AnyObject] {
                                
                                for (theKey, theValue) in currentDictionary {
                                    
                                    if (theKey == "Players") {
                                        
                                         if let playersDictionary = theValue as? [String : AnyObject ] {
                                            
                                            print("found Players dictionary for this particular level")
                                            
                                            playersDictionaryInLevelFound = true
                                            
                                            parsePropertiesInDictionary(playersDictionary)
                                            
                                        }
                                        
                                        
                                    }
                                    
                                }
                                
                                
                                
                            }
                            
                            
                        }
                        
                    }
                    
                    counter++
                    
                }
                
            }
            
        }
        
        
        if ( playersDictionaryInLevelFound == false){
            
             print("will look in the root for Players dictionary ")
            
            parsePropertiesInRoot()
            
        }
        
        
    }
    
    func parsePropertiesInDictionary(playersDictionary:[String : AnyObject ]){
        
        
        for (theKey, theValue) in playersDictionary{
            
            if (theKey == self.name ) {
                
                if let thePlayerDictionary:Dictionary = theValue as? [String : AnyObject ] {
                    
                    
                    
                    for (theKey2, theValue2) in thePlayerDictionary{
                        
                        if (theKey2 == "Atlas"){
                            
                            if (theValue2 is String){
                                
                                atlasName = theValue2 as! String
                                
                            }
                            
                        }
                        else  if (theKey2 == "BodyType"){
                            
                            if (theValue2 is String){
                                
                                bodyType = theValue2 as! String
                                
                            }
                            
                        }
                        else  if (theKey2 == "BodySize"){
                            
                            if (theValue2 is String){
                                
                                bodySize = CGSizeFromString(  theValue2 as! String )
                                
                            }
                            
                        }
                            
                        else if (theKey2 == "WeaponImage"){
                            
                            if (theValue2 is String){
                                
                                weaponImage = theValue2 as! String
                                
                            }
                            
                        }
                        else if (theKey2 == "IdleFrames"){
                            
                            if let theArray = theValue2 as? Array<String> {
                                
                                for name in theArray {
                                    
                                    idleArray.append(name)
                                }
                                
                            }
                            
                            
                        }
                        else if (theKey2 == "ShootFrames"){
                            
                            if let theArray = theValue2 as? Array<String> {
                                
                                for name in theArray {
                                    
                                    shootArray.append(name)
                                }
                                
                            }
                            
                            
                        }
                        else if (theKey2 == "WalkFrames"){
                            
                            if let theArray = theValue2 as? Array<String> {
                                
                                for name in theArray {
                                    
                                    walkArray.append(name)
                                }
                                
                            }
                            
                        }
                        else if (theKey2 == "RunFrames"){
                            
                            if let theArray = theValue2 as? Array<String> {
                                
                                for name in theArray {
                                    
                                    runArray.append(name)
                                }
                                
                            }
                            
                        }
                        else if (theKey2 == "JumpFrames"){
                            
                            if let theArray = theValue2 as? Array<String> {
                                
                                for name in theArray {
                                    
                                    jumpArray.append(name)
                                }
                                
                            }
                            
                        }
                        else if (theKey2 == "DeadFrames"){
                            
                            if let theArray = theValue2 as? Array<String> {
                                
                                for name in theArray {
                                    
                                    deadArray.append(name)
                                }
                                
                            }
                            
                        }
                        else if (theKey2 == "ClimbFrames"){
                            
                            if let theArray = theValue2 as? Array<String> {
                                
                                for name in theArray {
                                    
                                    climbArray.append(name)
                                }
                                
                            }
                            
                            
                        }
                            
                        else if (theKey2 == "BodyOffset"){
                            
                            if (theValue2 is String){
                                
                                bodyOffset = CGPointFromString( theValue2 as! String)
                                
                            }
                            
                        }
                            
                        else if (theKey2 == "JumpAmount"){
                            
                            if (theValue2 is Int){
                                
                                jumpAmount = theValue2 as! Int
                                
                            }
                            
                            
                        }
                        else if (theKey2 == "RadiusDivider"){
                            
                            if (theValue2 is CGFloat){
                                
                                radiusDivider = theValue2 as! CGFloat
                                
                            }
                            
                            
                        }
                        else if (theKey2 == "TimeBetweenFiring"){
                            
                            if (theValue2 is NSTimeInterval){
                                
                                timeBetweenFiring = theValue2 as! NSTimeInterval
                                
                            }
                            
                            
                        }else if (theKey2 == "WalkFPS"){
                            
                            if (theValue2 is NSTimeInterval){
                                
                                walkFPS = theValue2 as! NSTimeInterval
                                
                            }
                            
                            
                        }
                        else if (theKey2 == "RunFPS"){
                            
                            if (theValue2 is NSTimeInterval){
                                
                                runFPS = theValue2 as! NSTimeInterval
                                
                            }
                            
                            
                        }
                        else if (theKey2 == "ShootFPS"){
                            
                            if (theValue2 is NSTimeInterval){
                                
                                shootFPS = theValue2 as! NSTimeInterval
                                
                            }
                            
                            
                        }
                        else if (theKey2 == "ClimbFPS"){
                            
                            if (theValue2 is NSTimeInterval){
                                
                                climbFPS = theValue2 as! NSTimeInterval
                                
                            }
                            
                            
                        }
                        else if (theKey2 == "IdleFPS"){
                            
                            if (theValue2 is NSTimeInterval){
                                
                                idleFPS = theValue2 as! NSTimeInterval
                                
                            }
                            
                            
                        }
                        else if (theKey2 == "JumpFPS"){
                            
                            if (theValue2 is NSTimeInterval){
                                
                                jumpFPS = theValue2 as! NSTimeInterval
                                
                            }
                            
                            
                        }
                        else if (theKey2 == "DeadFPS"){
                            
                            if (theValue2 is NSTimeInterval){
                                
                                deadFPS = theValue2 as! NSTimeInterval
                                
                            }
                            
                            
                        }
                        else if (theKey2 == "ReviveTime"){
                            
                            if (theValue2 is NSTimeInterval){
                                
                                reviveTime = theValue2 as! NSTimeInterval
                                
                            }
                            
                            
                        }
                        else if (theKey2 == "DoubleJumpAmount"){
                            
                            
                            if (theValue2 is Int){
                                
                                doubleJumpAmount = theValue2 as! Int
                                
                                if (doubleJumpAmount > 0) {
                                    
                                    isDoubleJumpingAllowed = true
                                }
                                
                            }
                            
                            
                            
                        }
                        else if (theKey2 == "Speed"){
                            
                            if (theValue2 is CGFloat){
                                
                                currentSpeed = theValue2 as! CGFloat
                                
                            }
                            
                            
                        }
                        else if (theKey2 == "SpeedBoost"){
                            
                            if (theValue2 is CGFloat){
                                
                                speedBoost = theValue2 as! CGFloat
                                
                            }
                            
                            
                        }
                        else if (theKey2 == "ClimbSpeed"){
                            
                            if (theValue2 is CGFloat){
                                
                                climbSpeed = theValue2 as! CGFloat
                                
                            }
                            
                            
                        }
                            
                        else if (theKey2 == "WeaponSpeed"){
                            
                            if (theValue2 is Int){
                                
                                weaponSpeed = theValue2 as! Int
                                
                            }
                            
                            
                        }
                        else if (theKey2 == "WeaponRotationSpeed"){
                            
                            if (theValue2 is Float){
                                
                                weaponRotationSpeed = theValue2 as! Float
                                
                            }
                            
                            
                        }
                        else if (theKey2 == "WeaponDelay"){
                            
                            if (theValue2 is Float){
                                
                                weaponDelay = theValue2 as! Float
                                
                            }
                            
                            
                        }else if (theKey2 == "WeaponOffset"){
                            
                            if (theValue2 is String){
                                
                                weaponOffset =  CGPointFromString ( theValue2 as! String )
                                
                            }
                            
                        }else if (theKey2 == "SoundJump"){
                            
                            if (theValue2 is String){
                                
                                soundJump = theValue2 as! String
                                
                                preloadedSoundJump = SKAction.playSoundFileNamed(soundJump, waitForCompletion: false)
                                
                                
                            }
                            
                        } else if (theKey2 == "SoundLand"){
                            
                            if (theValue2 is String){
                                
                                soundLand = theValue2 as! String
                                preloadedSoundLand = SKAction.playSoundFileNamed(soundLand, waitForCompletion: false)
                                
                            }
                            
                        } else if (theKey2 == "SoundLoseHeart"){
                            
                            if (theValue2 is String){
                                
                                soundLoseHeart = theValue2 as! String
                                preloadedSoundLoseHeart = SKAction.playSoundFileNamed(soundLoseHeart, waitForCompletion: false)
                                
                            }
                            
                        } else if (theKey2 == "SoundDead"){
                            
                            if (theValue2 is String){
                                
                                soundDead = theValue2 as! String
                                preloadedSoundDead = SKAction.playSoundFileNamed(soundDead, waitForCompletion: false)
                                
                            }
                            
                        } else if (theKey2 == "SoundBounce"){
                            
                            if (theValue2 is String){
                                
                                soundBounce = theValue2 as! String
                                preloadedSoundBounce = SKAction.playSoundFileNamed(soundBounce, waitForCompletion: false)
                                
                            }
                            
                        } else if (theKey2 == "SoundShoot"){
                            
                            if (theValue2 is String){
                                
                                soundShoot = theValue2 as! String
                                preloadedSoundShoot = SKAction.playSoundFileNamed(soundShoot, waitForCompletion: false)
                                
                            }
                            
                        } else if (theKey2 == "SoundBulletImpact"){
                            
                            if (theValue2 is String){
                                
                                soundBulletImpact = theValue2 as! String
                                preloadedSoundBulletImpact = SKAction.playSoundFileNamed(soundBulletImpact, waitForCompletion: false)
                                
                            }
                            
                        } else if (theKey2 == "SoundNoAmmo"){
                            
                            if (theValue2 is String){
                                
                                soundNoAmmo = theValue2 as! String
                                preloadedSoundNoAmmo = SKAction.playSoundFileNamed(soundNoAmmo, waitForCompletion: false)
                                
                            }
                            
                        }
                        
                        
                    }
                    
                }
                
            }
            
        }

        
    }
    
    
    func parsePropertiesInRoot(){
        
        
        let path = NSBundle.mainBundle().pathForResource("LevelData", ofType: "plist")
        
        let dict:NSDictionary = NSDictionary(contentsOfFile: path!)!
        
        if (dict.objectForKey("Players") != nil) {
            
             if let playersDictionary = dict.objectForKey("Players") as? [String : AnyObject ] {
                
                
                parsePropertiesInDictionary(playersDictionary)
                
                
            }
         
        }
        
        
        
    }
    
    
    
    func setUpIdleAnimation() {
        
       
        
        let atlas:SKTextureAtlas  = SKTextureAtlas(named:atlasName)
        
       
        
        var atlasTextures = [SKTexture]()
        
        
        
        for name in idleArray {
            
            
            
            let texture:SKTexture = atlas.textureNamed( name )
            atlasTextures.append(texture)
            
        }

       
        
        let atlasAnimation = SKAction.animateWithTextures(atlasTextures, timePerFrame: 1 / idleFPS, resize:true, restore:false )
        idleAction = SKAction.repeatActionForever(atlasAnimation)
        
        
    }
    
    
    func setUpClimbAnimation() {
        
        let atlas  = SKTextureAtlas(named:atlasName)
        
        var atlasTextures = [SKTexture]()
        
        for name in climbArray {
            
            let texture:SKTexture = atlas.textureNamed( name )
            atlasTextures.append(texture)
            
        }
        
        let atlasAnimation = SKAction.animateWithTextures(atlasTextures, timePerFrame: 1 / climbFPS , resize:true, restore:false )
        climbAction = SKAction.repeatActionForever(atlasAnimation)
        
        
    }
    
    
    func setUpJumpAnimation() {
        
        
        let atlas  = SKTextureAtlas(named:atlasName)
        
        var atlasTextures = [SKTexture]()
        
        for name in jumpArray {
            
            let texture:SKTexture = atlas.textureNamed( name )
            atlasTextures.append(texture)
            
        }
        
        let atlasAnimation = SKAction.animateWithTextures(atlasTextures, timePerFrame:  1 / jumpFPS, resize:true, restore:false )
        let run:SKAction = SKAction.runBlock{
            
            self.whatToDoAfterJump();
        }
        jumpAction = SKAction.sequence( [atlasAnimation, run ] )
        
        
    }
    
    func setUpWalkAnimation() {
        
        let atlas  = SKTextureAtlas(named:atlasName)
        
        var atlasTextures = [SKTexture]()
        
        for name in walkArray {
            
            let texture:SKTexture = atlas.textureNamed( name )
            atlasTextures.append(texture)
            
        }
        
        let atlasAnimation = SKAction.animateWithTextures(atlasTextures, timePerFrame: 1 / walkFPS, resize:true, restore:false )
        walkAction = SKAction.repeatActionForever(atlasAnimation)
        
        
    }
    func setUpRunAnimation() {
        
        let atlas  = SKTextureAtlas(named:atlasName)
        
        var atlasTextures = [SKTexture]()
        
        for name in runArray {
            
            let texture:SKTexture = atlas.textureNamed( name )
            atlasTextures.append(texture)
            
        }
        
        let atlasAnimation = SKAction.animateWithTextures(atlasTextures, timePerFrame: 1 / runFPS, resize:true, restore:false )
        runAction = SKAction.repeatActionForever(atlasAnimation)
        
        
    }
    
    func setUpDeadAnimation() {
        
        let atlas  = SKTextureAtlas(named:atlasName)
        
        var atlasTextures = [SKTexture]()
        
        for name in deadArray {
            
            let texture:SKTexture = atlas.textureNamed( name )
            atlasTextures.append(texture)
            
        }
        
        deadAction =  SKAction.animateWithTextures(atlasTextures, timePerFrame: 1 / deadFPS, resize:true, restore:false )
        
        
        
    }
    func setUpShootAnimation() {
        
        let atlas  = SKTextureAtlas(named:atlasName)
        
        var atlasTextures = [SKTexture]()
        
        for name in shootArray {
            
            let texture:SKTexture = atlas.textureNamed( name )
            atlasTextures.append(texture)
            
        }
        
       
        
        
        let atlasAnimation = SKAction.animateWithTextures(atlasTextures, timePerFrame: 1 / shootFPS, resize:true, restore:false )
        let run:SKAction = SKAction.runBlock{
            
            if ( self.currentDirection == .Up || self.currentDirection == .Down || self.currentDirection == .None){
                
                if ( self.idleAction != nil) {
                
                    self.runAction(self.idleAction!, withKey:"Idle")
                    
                }
                
                
            } else {
                
                if (self.runAction != nil && self.isRunning == true) {
                    
                    self.runAction(self.runAction!, withKey:"Walk")
                    
                }
                    
                else if (self.walkAction != nil) {
                    
                    self.runAction(self.walkAction!, withKey:"Walk")
                    
                }
            }
        }
        shootAction = SKAction.sequence( [atlasAnimation, run ] )
        
    }
    
    
    
    func whatToDoAfterJump() {
        
        if (playerIsDead == false) {
        
        
        if (currentDirection == .Right || currentDirection == .Left) {
        
            if (self.runAction != nil && self.isRunning == true) {
                
                self.runAction(self.runAction!, withKey:"Walk")
                
            }
                
            else if (self.walkAction != nil) {
                
                self.runAction(self.walkAction!, withKey:"Walk")
                
            }
           
        } else {
            
            removeAllAnimationActions()
            
            if (self.idleAction != nil) {
            
                self.runAction(idleAction!, withKey: "Idle")
                
            }
        }
        
        }
        
        
    }
    
    func stopWalk(){
        
        
        
        currentDirection = .None
        
        
        
        
        if ( self.actionForKey("Shoot" ) == nil ) {
            
            removeAllAnimationActions()
            
            if (self.idleAction != nil) {
                
                self.runAction(idleAction!, withKey:"Idle")
                
            }
            
        } else {
            
            listenForShootingAnimationFinished()
            
        }
        
        
    }
    
    func listenForShootingAnimationFinished () {
        
        let wait:SKAction = SKAction.waitForDuration(1/60)
        let run:SKAction = SKAction.runBlock{
            
            if ( self.actionForKey("Shoot" ) == nil ) {
                
                //shoot over, go idle
                
                if (self.idleAction != nil) {
                    
                    self.runAction(self.idleAction!, withKey:"Idle")
                    
                }
                
            } else {
                
                // wait for shooting to be over
                
                self.listenForShootingAnimationFinished()
                
            }
            
            
            
        }
        
        self.runAction( SKAction.sequence( [wait, run]))
        
        
        
    }

    
    
    func goRight(){
        
        
        self.xScale = 1
        currentDirection = .Right
        
        
        if (self.actionForKey("Walk") == nil) {
            
            if ( canFireAgain == true){
                // canFireAgain means the player isn't doing their shoot animation
                
                if (self.runAction != nil && isRunning == true ) {
                    
                    self.runAction(runAction!, withKey:"Walk")
                    
                }
                    
                else if (self.walkAction != nil) {
                    
                    self.runAction(walkAction!, withKey:"Walk")
                    
                }
                
            }
            
        }
        
        
        
    }
    
    func goLeft(){
        
        self.xScale = -1
        currentDirection = .Left
        
        if (self.actionForKey("Walk") == nil) {
            
            if ( canFireAgain == true){
                // canFireAgain means the player isn't doing their shoot animation
                
                if (self.runAction != nil && isRunning == true ) {
                    
                    self.runAction(runAction!, withKey:"Walk")
                    
                }
                    
                else if (self.walkAction != nil) {
                    
                    self.runAction(walkAction!, withKey:"Walk")
                    
                }
                
            }
            
        }
        
    }
    
    
   
    
    func jump(){
        
        if ( playerIsDead == false) {
        
        if ( isJumping == false && canJumpAgain == true) {
            
            canDoubleJumpAgain = true
            canJumpAgain = false
            isJumping = true
        
            removeAllAnimationActions()
            
            if (self.jumpAction != nil) {
            
                self.runAction(jumpAction!, withKey: "Jump")
                
            }
        
            let move:SKAction = SKAction.moveByX(0, y:  CGFloat( jumpAmount ), duration: 1)
            self.runAction(move, withKey: "JumpMove")
            
            playSound(soundJump)
            
            
            // prevents some weirdness with super jumping via controllers
            let wait:SKAction = SKAction.waitForDuration(0.2)
            let jumpAgain:SKAction = SKAction.runBlock{
                self.canJumpAgain = true;
                
            }
            let seq:SKAction = SKAction.sequence( [ wait, jumpAgain] )
            self.runAction(seq )
     
            
        }
            
        }
    }
    
    
    func doubleJump(){
        
        if ( playerIsDead == false) {
        
        if ( isDoubleJumpingAllowed == true && isJumping == true &&  canJumpAgain == true && canDoubleJumpAgain == true) {
        
            canDoubleJumpAgain = false
            
            removeAllAnimationActions()
            
             if (self.jumpAction != nil) {
            
                self.runAction(jumpAction!, withKey: "Jump")
                
            }
            
            let move:SKAction = SKAction.moveByX(0, y: CGFloat( doubleJumpAmount ) , duration: 1)
            self.runAction(move, withKey: "DoubleJumpMove")
            
            
            // prevents some weirdness with super jumping via controllers
            let wait:SKAction = SKAction.waitForDuration(0.5)
            let jumpAgain:SKAction = SKAction.runBlock{
                self.canDoubleJumpAgain = true;
                
            }
            let seq:SKAction = SKAction.sequence( [ wait, jumpAgain] )
            self.runAction(seq )
            
            
            playSound(soundJump)
            
            
        }
        
        }
        
    }
    
   
    func stopJump(){
        
        // gets called from swiping down
        
       if (playerIsDead == false) {

            isJumping = false
        
        
            currentDirection = .None
            self.removeActionForKey("JumpMove")
            self.removeActionForKey("DoubleJumpMove")
        
            removeAllAnimationActions()
        
             if (self.idleAction != nil) {
        
                self.runAction(idleAction!, withKey:"Idle")
                
            }
        
        }
        
        
    }
    func stopJumpFromPlatformContact(){
        
        if ( isClimbing == false) {
        
            isJumping = false
            
             removeAllAnimationActions()
        
            self.removeActionForKey("JumpMove")
            self.removeActionForKey("DoubleJumpMove")
            whatToDoAfterJump()
            
        }
      
        
        
    }
    
    
    func goUpPole(){
        
        isClimbing = true
        
        currentDirection = .Up
        self.removeActionForKey("JumpMove")
        self.removeActionForKey("DoubleJumpMove")
       
        
        removeAllAnimationActions()
        
        if ( self.climbAction != nil) {
        
            self.runAction(climbAction!, withKey: "Climb")
            
        }
        
        self.physicsBody?.velocity = CGVectorMake(0, 0)
        self.physicsBody?.affectedByGravity = false
        
        
    }

    
    
    func goDownPole(){
        
         isClimbing = true
        
        currentDirection = .Down
        self.removeActionForKey("JumpMove")
        self.removeActionForKey("DoubleJumpMove")
        
        removeAllAnimationActions()
        
        if ( self.climbAction != nil) {
        
            self.runAction(climbAction!, withKey: "Climb")
            
        }
        
        self.physicsBody?.velocity = CGVectorMake(0, 0)
        self.physicsBody?.affectedByGravity = false
        
    }
    
    func offPole(){
        
        
        self.physicsBody?.affectedByGravity = true
        
        removeAllAnimationActions()
        
        isClimbing = false
        
         if ( self.idleAction != nil) {
        
            self.runAction(idleAction!, withKey: "Idle")
            
        }
    }
    
    
    func run(){
        
            isRunning = true
         
        
    }
    
    func releaseRun(){
        
        
        
        isRunning = false
        
        
        
    }
    
    
    func update(){
        
        if (playerIsDead == false){
        
        
        if (currentDirection == .Left) {
        
            self.position = CGPointMake(self.position.x - currentSpeed, self.position.y)
            
            if (xHeldDown == true){
                
                self.position = CGPointMake(self.position.x - speedBoost, self.position.y)
                
            }
            
            
        } else if (currentDirection == .Right) {
            
            self.position = CGPointMake(self.position.x + currentSpeed, self.position.y)
            
            if (xHeldDown == true){
                
                self.position = CGPointMake(self.position.x + speedBoost, self.position.y)
                
            }
        }
        
        if ( onPole == true && currentDirection == .Up) {
            
            self.position = CGPointMake(self.position.x, self.position.y + climbSpeed)
            
            
        } else if ( onPole == true && currentDirection == .Down) {
            
            self.position = CGPointMake(self.position.x, self.position.y - climbSpeed)
            
            
        }
            
        }
        
        
        
    }
    
    func shoot(){
        
        if ( canFireAgain == true && playerIsDead == false) {
            
            canFireAgain = false
        
            removeAllAnimationActions()
            
            if (shootAction != nil){
            
                self.runAction(shootAction!, withKey:"Shoot")
                
            }
            
            let wait:SKAction = SKAction.waitForDuration(timeBetweenFiring )
            let fireAgain:SKAction = SKAction.runBlock{
                self.canFireAgain = true;
            
            }
            let seq:SKAction = SKAction.sequence( [ wait, fireAgain] )
            self.runAction(seq )
        }
    }
    
    
    func removeAllAnimationActions(){
        
        //these are only ANIMATION actions
        
        self.removeActionForKey("Idle")
        self.removeActionForKey("Jump")
        self.removeActionForKey("Walk")
        self.removeActionForKey("Climb")
        self.removeActionForKey("Death")
        self.removeActionForKey("Shoot")
        
    }
    
    func die(){
        
        removeAllAnimationActions()
        
        if (deadAction != nil){
        
            self.runAction(deadAction!, withKey:"Death" )
            
        }
        
        
        
    }
    
   
    
    func revive(){
        
        isClimbing = false
        isJumping = false
        
        onPole = false
        
        canFireAgain = true
        canJumpAgain = true
        
        currentDirection = .None
        playerIsDead = false
        canFireAgain = true 
        
        
        
        self.removeActionForKey("Idle")
        self.removeActionForKey("Jump")
        self.removeActionForKey("Walk")
        self.removeActionForKey("Climb")
        self.removeActionForKey("Shoot")
        
        
        self.physicsBody?.affectedByGravity = true
        
         if (idleAction != nil){
        
            self.runAction(idleAction!, withKey:"Idle" )
            
        }
        

    }
    
    
    func playSound(theSound:String ){
        
        if (theSound != ""){
            
            if (theSound == soundJump){
                
                self.runAction(preloadedSoundJump!)
                
            } else if (theSound == soundBounce){
                
                self.runAction(preloadedSoundBounce!)
                
            } else if (theSound == soundBulletImpact){
                
                self.runAction(preloadedSoundBulletImpact!)
                
            } else if (theSound == soundDead){
                
                self.runAction(preloadedSoundDead!)
                
            } else if (theSound == soundLand){
                
                self.runAction(preloadedSoundLand!)
                
            } else if (theSound == soundLoseHeart){
                
                self.runAction(preloadedSoundLoseHeart!)
                
            }  else if (theSound == soundNoAmmo){
                
                self.runAction(preloadedSoundNoAmmo!)
                
            }  else if (theSound == soundShoot){
                
                self.runAction(preloadedSoundShoot!)
                
            }  else {
            
            
            let sound:SKAction = SKAction.playSoundFileNamed(theSound, waitForCompletion: true)
            self.runAction(sound)
            
            }
            
            
            
        }
        
    }
    
    
    
    func adjustXSpeedAndScale () {
        
        if (currentSpeed > maxSpeed) {
            
            currentSpeed = maxSpeed
        } else if (currentSpeed < -maxSpeed) {
            
            currentSpeed = -maxSpeed
        }
        
        

        
        if ( currentSpeed > 0 ){
            
            self.xScale = 1
            
            
        } else {
            
            self.xScale = -1
        }

        
    }
    
    
}














