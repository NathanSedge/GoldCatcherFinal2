//
//  Player.swift
//  GoldCatcherFinal
//
//  Created by Nathan on 04/05/2022.
//





import Foundation
import SpriteKit
import GameplayKit

enum PlayerAnimationType: String {
    case walk
}


class Player: SKSpriteNode {
    
    // skeleton properties
    
    private var walkTextures: [SKTexture]?
    public var playerSpeed: CGFloat = 2.5
    
  
    
    init() {
        let texture = SKTexture(imageNamed: "skeletonMove_0")
        super.init(texture: texture, color: .clear, size: texture.size())
        self.walkTextures = self.loadTextures(atlas: "Skeleton", prefix: "skeletonMove_", startsAt: 0, stopsAt: 2)
        self.name = "player"
        self.setScale(1.0)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        self.zPosition = Layer.player.rawValue
   
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size, center: CGPoint(x: 0.0, y: self.size.height/2))
        self.physicsBody?.affectedByGravity = false
        
    
        self.physicsBody?.categoryBitMask = PhysicsCategory.player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.collectible
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func walk() {
        guard let walkTextures = walkTextures else {
            preconditionFailure("Could not find textures")
        }
        startAnimation(textures: walkTextures, speed: 0.25, name: PlayerAnimationType.walk.rawValue, count: 0, resize: true, restore: true)

    }
    
    func moveToPosition(pos: CGPoint, direction: String, speed: TimeInterval) {
        switch direction {
        case "L" :
            xScale = -abs(xScale)
        default :
            xScale = abs(xScale)
        }
        let moveAction = SKAction.move(to: pos, duration: speed)
        run(moveAction)
    }
    
    func setupConstraints(floor: CGFloat) {
        let range = SKRange(lowerLimit: floor, upperLimit: floor)
        let lockToPlatform = SKConstraint.positionY(range)
        constraints = [ lockToPlatform ]
    }
    
}
