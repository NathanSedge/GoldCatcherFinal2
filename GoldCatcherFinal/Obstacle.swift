//
//  Obstacle.swift
//  GoldCatcherFinal
//
//  Created by Nathan on 05/06/2022.
//

import Foundation
import SpriteKit


enum ObstacleType: String {
  case none
  case bomb
  

}

class Obstacle: SKSpriteNode {
 
  private var obstacleType: ObstacleType = .none

  init(obstacleType: ObstacleType) {
    var texture: SKTexture!
    self.obstacleType = obstacleType

 
    switch self.obstacleType {
    case .bomb:
      texture = SKTexture(imageNamed: "bomb")

    
    case .none:
      break
    }


    super.init(texture: texture, color: SKColor.clear, size: texture.size())


    self.name = "co_\(obstacleType)"
    self.anchorPoint = CGPoint(x: 0.5, y: 1.0)
    self.zPosition = Layer.obstacle.rawValue
    

    self.physicsBody = SKPhysicsBody(rectangleOf: self.size, center: CGPoint(x: 0.0, y: -self.size.height/2))
    self.physicsBody?.affectedByGravity = false
    

    self.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
    self.physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.foreground
    self.physicsBody?.collisionBitMask = PhysicsCategory.none
  }


  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  

  func drop(dropSpeed: TimeInterval, floorLevel: CGFloat) {
    let pos = CGPoint(x: position.x, y: floorLevel)

    let scaleX = SKAction.scaleX(to: 1.0, duration: 1.0)
    let scaleY = SKAction.scaleY(to: 1.3, duration: 1.0)
    let scale = SKAction.group([scaleX, scaleY])

    let appear = SKAction.fadeAlpha(to: 1.0, duration: 0.25)
    let moveAction = SKAction.move(to: pos, duration: dropSpeed)
    let actionSequence = SKAction.sequence([appear, scale, moveAction])

  
    self.scale(to: CGSize(width: 0.25, height: 1.0))
    self.run(actionSequence, withKey: "drop")
  }
  

  func hit() {
    let removeFromParent = SKAction.removeFromParent()
    self.run(removeFromParent)
  }

  func miss() {
    let removeFromParent = SKAction.removeFromParent()
    self.run(removeFromParent)
  }
}

