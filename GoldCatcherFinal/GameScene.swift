//
//  GameScene.swift
//  GoldCatcherFinal
//
//  Created by Nathan on 04/05/2022.
//




import SpriteKit
import GameplayKit


class GameScene: SKScene {
    
    let player = Player()
    let playerSpeed: CGFloat = 1.5
    
  
    var movingPlayer = false
    var lastPosition: CGPoint?
    
    var level: Int = 1
    var numberOfDrops: Int = 10
    
    var dropSpeed: CGFloat = 1.0
    var minDropSpeed: CGFloat = 0.12
    var maxDropSpeed: CGFloat = 1.0
    
    let scoreLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-Bold")
    let highScoreLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-Bold")
    let scoreKey = "scoreKey"

    


    
    var score = 0 {
      didSet {
        scoreLabel.text = "SCORE: \(score)"
      }
    }

  override func didMove(to view: SKView) {
    
      physicsWorld.contactDelegate = self
      let background = SKSpriteNode(imageNamed: "background_1")
      background.anchorPoint = CGPoint(x: 0, y: 0)
      background.zPosition = Layer.background.rawValue
      background.position = CGPoint(x: 0, y: 0)
      addChild(background)
      
      let foreground = SKSpriteNode(imageNamed: "foreground_1")
      foreground.anchorPoint = CGPoint(x: 0, y: 0)
      foreground.zPosition = Layer.foreground.rawValue
      foreground.position = CGPoint(x: 0, y: 0)
      
      foreground.physicsBody = SKPhysicsBody(edgeLoopFrom: foreground.frame)
      foreground.physicsBody?.affectedByGravity = false
      
      foreground.physicsBody?.categoryBitMask = PhysicsCategory.foreground
      foreground.physicsBody?.contactTestBitMask = PhysicsCategory.collectible
      foreground.physicsBody?.contactTestBitMask = PhysicsCategory.obstacle
      foreground.physicsBody?.collisionBitMask = PhysicsCategory.none
      
      addChild(foreground)
      scoreLabel.zPosition = 2
      scoreLabel.position.y = (self.frame.size.height - 100)
      scoreLabel.position.x = (self.frame.size.width - 180)
      addChild(scoreLabel)
      score = 0
      highScoreLabel.zPosition = 2
      highScoreLabel.position.y = (self.frame.size.height - 100)
      highScoreLabel.position.x = (self.frame.size.width - 580)
      let defaults = UserDefaults.standard
      let highestScore = defaults.integer(forKey: "scoreKey")
      highScoreLabel.text = "HIGH SCORE: \(highestScore)"
      addChild(highScoreLabel)
      
   

      player.position = CGPoint(x: size.width/2, y: foreground.frame.maxY)
     
      player.setupConstraints(floor: foreground.frame.maxY)
      addChild(player)
      player.walk()
      
      spawnSomeCoins()
      spawnSomeGold()
      spawnSomeBombs()
  }
    func spawnSomeCoins() {
      
      numberOfDrops = 10000
      
      // setting drop speed (same for all spawners)
      dropSpeed = 1 / (CGFloat(level) + (CGFloat(level) / CGFloat(numberOfDrops)))
      if dropSpeed < minDropSpeed {
        dropSpeed = minDropSpeed
      } else if dropSpeed > maxDropSpeed {
        dropSpeed = maxDropSpeed
      }
      
      // setting the coins to drop repeatedly (same for all spawners)
      let wait = SKAction.wait(forDuration: TimeInterval(dropSpeed))
      let spawn = SKAction.run { [unowned self] in self.spawnCoin() }
      let sequence = SKAction.sequence([wait, spawn])
      let repeatAction = SKAction.repeat(sequence, count: numberOfDrops)
      
      
      run(repeatAction, withKey: "coin")
    }
    func spawnCoin() {
      let collectible = Collectible(collectibleType: CollectibleType.coin)
      
    
      let margin = collectible.size.width * 2
      let dropRange = SKRange(lowerLimit: frame.minX + margin, upperLimit: frame.maxX - margin)
      let randomX = CGFloat.random(in: dropRange.lowerLimit...dropRange.upperLimit)
      
      collectible.position = CGPoint(x: randomX, y: player.position.y * 2.5)
      addChild(collectible)
      
      collectible.drop(dropSpeed: TimeInterval(1.0), floorLevel: player.frame.minY)
    }
    
    func spawnSomeGold() {
      
      numberOfDrops = 10000
      
      
      dropSpeed = 1 / (CGFloat(level) + (CGFloat(level) / CGFloat(numberOfDrops)))
      if dropSpeed < minDropSpeed {
        dropSpeed = minDropSpeed
      } else if dropSpeed > maxDropSpeed {
        dropSpeed = maxDropSpeed
      }
      

      let wait = SKAction.wait(forDuration: TimeInterval(dropSpeed))
      let spawn = SKAction.run { [unowned self] in self.spawnGold() }
      let sequence = SKAction.sequence([wait, spawn])
      let repeatAction = SKAction.repeat(sequence, count: numberOfDrops)
      

      run(repeatAction, withKey: "gold")
    }
    func spawnGold() {
      let collectible = Collectible(collectibleType: CollectibleType.gold)
      
    
      let margin = collectible.size.width * 2
      let dropRange = SKRange(lowerLimit: frame.minX + margin, upperLimit: frame.maxX - margin)
      let randomX = CGFloat.random(in: dropRange.lowerLimit...dropRange.upperLimit)
      
      collectible.position = CGPoint(x: randomX, y: player.position.y * 2.5)
      addChild(collectible)
      
      collectible.drop(dropSpeed: TimeInterval(1.0), floorLevel: player.frame.minY)
    }
    func spawnSomeBombs() {
      
      numberOfDrops = 10000
      
    
      dropSpeed = 1 / (CGFloat(level) + (CGFloat(level) / CGFloat(numberOfDrops)))
      if dropSpeed < minDropSpeed {
        dropSpeed = minDropSpeed
      } else if dropSpeed > maxDropSpeed {
        dropSpeed = maxDropSpeed
      }

      let wait = SKAction.wait(forDuration: TimeInterval(dropSpeed))
      let spawn = SKAction.run { [unowned self] in self.spawnBomb() }
      let sequence = SKAction.sequence([wait, spawn])
      let repeatAction = SKAction.repeat(sequence, count: numberOfDrops)
      
      run(repeatAction, withKey: "bomb")
    }
    func spawnBomb() {
      let obstacle = Obstacle(obstacleType: ObstacleType.bomb)
      
    
      let margin = obstacle.size.width * 2
      let dropRange = SKRange(lowerLimit: frame.minX + margin, upperLimit: frame.maxX - margin)
      let randomX = CGFloat.random(in: dropRange.lowerLimit...dropRange.upperLimit)
      
      obstacle.position = CGPoint(x: randomX, y: player.position.y * 2.5)
      addChild(obstacle)
      
      obstacle.drop(dropSpeed: TimeInterval(1.0), floorLevel: player.frame.minY)
    }

  override func update(_ currentTime: TimeInterval) {

  }

    func touchDown(atPoint pos : CGPoint) {
        let distance = hypot(pos.x - player.position.x, pos.y - player.position.y)
        let calculatedSpeed = TimeInterval(distance / player.playerSpeed) / 255
        
        if pos.x < player.position.x {
            player.moveToPosition(pos: pos, direction: "L", speed: calculatedSpeed)
        } else {
            player.moveToPosition(pos: pos, direction: "R", speed: calculatedSpeed)
        }
    }
    
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      for t in touches { self.touchDown(atPoint: t.location(in: self)) }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

  }
}

extension GameScene: SKPhysicsContactDelegate {
  func didBegin(_ contact: SKPhysicsContact) {
    // checking the collision bodies
    let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
    
    //checking for player collision with any collectible
    if collision == PhysicsCategory.player | PhysicsCategory.collectible {
      print("player hit collectible")
      score = score + 1
      
      
      let body = contact.bodyA.categoryBitMask == PhysicsCategory.collectible ?
        contact.bodyA.node :
        contact.bodyB.node

      // check that object is a collectible
      if let sprite = body as? Collectible {
        sprite.collected()
      }
    }

      //checking for foreground collision with any collectible
    if collision == PhysicsCategory.foreground | PhysicsCategory.collectible {
      print("collectible hit foreground")
      
     
      let body = contact.bodyA.categoryBitMask == PhysicsCategory.collectible ?
        contact.bodyA.node :
        contact.bodyB.node

  
      if let sprite = body as? Collectible {
        sprite.missed()
      }
    }
      //same as collectible
      if collision == PhysicsCategory.player | PhysicsCategory.obstacle {
        print("player hit bomb")
        score = score - 1
   
        let body = contact.bodyA.categoryBitMask == PhysicsCategory.obstacle ?
          contact.bodyA.node :
          contact.bodyB.node

        if let sprite = body as? Obstacle {
          sprite.hit()
        }
          if let particles = SKEmitterNode(fileNamed: "fire.sks") { //create an explosion at the player position
            particles.position = player.position
            particles.zPosition = 3
            addChild(particles)
          }
          player.removeFromParent() // remove skeleton cos hes dead

          let gameOver = SKSpriteNode(imageNamed: "gameOver") //show grave stone on screen rip
          gameOver.zPosition = 10
          gameOver.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
          addChild(gameOver)
          
         let defaults = UserDefaults.standard
       
          
          let highestScore = defaults.integer(forKey: "scoreKey")
          
          if highestScore < score {
              let defaults = UserDefaults.standard                 //if score is new highscore change the stored value
              defaults.set(score, forKey: "scoreKey")
             
          }
          DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let newScene = MenuScene(size: self.size)
            newScene.scaleMode = self.scaleMode
            let animation = SKTransition.fade(withDuration: 2.0)
            self.view?.presentScene(newScene, transition: animation)
          }
          print(highestScore)
      }


      if collision == PhysicsCategory.foreground | PhysicsCategory.obstacle {
        print("bomb hit foreground")
        
        let body = contact.bodyA.categoryBitMask == PhysicsCategory.obstacle ?
          contact.bodyA.node :
          contact.bodyB.node

        if let sprite = body as? Obstacle {
          sprite.miss()
        }
      }
  }
}

