//
//  Platform.swift
//  SideScroller
//
//  Created by Justin Dike 2 on 10/20/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
//

import Foundation
import SpriteKit


class Platform: SKSpriteNode {
    
    var initialPosition:CGPoint = CGPointZero
    
    func setUpPlatform() {

        self.physicsBody?.categoryBitMask = BodyType.platform.rawValue
        self.physicsBody?.collisionBitMask = BodyType.player.rawValue | BodyType.platform.rawValue
        self.physicsBody?.contactTestBitMask = BodyType.player.rawValue
        
        initialPosition = self.position
        
    }

    
    //v 1.42
    
    func resetPlatform(time:NSTimeInterval){
        
        self.physicsBody?.velocity = CGVectorMake(0, 0)
        self.physicsBody?.angularVelocity = 0
        
        let move:SKAction = SKAction.moveTo(initialPosition, duration: time)
        self.runAction(move)
        
    }
    
}