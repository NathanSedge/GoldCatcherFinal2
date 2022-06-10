//
//  Collectiible.swift
//  GoldCatcherFinal
//
//  Created by Nathan on 04/05/2022.
//

import Foundation
import SpriteKit


enum CollectibleType: String {
  case none
  case coin
  case gold

}

class Collectible: SKSpriteNode {
 
  private var collectibleType: CollectibleType = .none

  init(collectibleType: CollectibleType) {
    var texture: SKTexture!
    self.collectibleType = collectibleType

 
    switch self.collectibleType {
    case .coin:
      texture = SKTexture(imageNamed: "coin")
    case .gold:
        texture = SKTexture(imageNamed: "gold")
    
    case .none:
      break
    }


    super.init(texture: texture, color: SKColor.clear, size: texture.size())


    self.name = "co_\(collectibleType)"
    self.anchorPoint = CGPoint(x: 0.5, y: 1.0)
    self.zPosition = Layer.collectible.rawValue
    

    self.physicsBody = SKPhysicsBody(rectangleOf: self.size, center: CGPoint(x: 0.0, y: -self.size.height/2))
    self.physicsBody?.affectedByGravity = false
    

    self.physicsBody?.categoryBitMask = PhysicsCategory.collectible
    self.physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.foreground
    self.physicsBody?.collisionBitMask = PhysicsCategory.none
  }


  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  

  func drop(dropSpeed: TimeInterval, floorLevel: CGFloat) {
    let pos = CGPoint(x: position.x, y: floorLevel)

    let scaleX = SKAction.scaleX(to: 1.0, duration: 1.0)
    let scaleY = SKAction.scaleY(to: 1.0, duration: 1.0)
    let scale = SKAction.group([scaleX, scaleY])

    let appear = SKAction.fadeAlpha(to: 1.0, duration: 0.05)
    let moveAction = SKAction.move(to: pos, duration: dropSpeed)
    let actionSequence = SKAction.sequence([appear, scale, moveAction])

  
    self.scale(to: CGSize(width: 0.25, height: 1.0))
    self.run(actionSequence, withKey: "drop")
  }
  

  func collected() {
    let removeFromParent = SKAction.removeFromParent()
    self.run(removeFromParent)
  }

  func missed() {
    let removeFromParent = SKAction.removeFromParent()
    self.run(removeFromParent)
  }
}

