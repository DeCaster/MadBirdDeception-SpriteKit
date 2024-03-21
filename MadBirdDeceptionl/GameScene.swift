//
//  GameScene.swift
//  MadBirdDeceptionl
//
//  Created by Murad on 18.03.2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode() // Kuş düğümü
    var boxes = [SKSpriteNode]() // Kutular dizisi
    
    var gameStarted = false // Oyun başladı mı?
    var originalPosition: CGPoint = .zero // Kuşun başlangıç pozisyonu
    var boxOriginalPositions = [CGPoint]() // Kutuların başlangıç pozisyonları
    var score = 0 // Skor
    var scoreLabel = SKLabelNode() // Skor etiketi
    
    enum ColliderType: UInt32 {
        case Bird = 1
        case Box = 2
    }
    
    override func didMove(to view: SKView) {
        // Fizik bedenlerini oluştur
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: frame.origin.x, y: frame.origin.y + 80, width: frame.size.width, height: frame.size.height - 80))
        self.scene?.scaleMode = .aspectFit
        self.physicsWorld.contactDelegate = self
        
        // Kuş
        if let birdNode = childNode(withName: "bird") as? SKSpriteNode {
            bird = birdNode
            bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2.9)
            bird.physicsBody?.affectedByGravity = false
            bird.physicsBody?.isDynamic = true
            bird.physicsBody?.mass = 0.13
            originalPosition = bird.position
            
            bird.physicsBody?.contactTestBitMask = ColliderType.Bird.rawValue
            bird.physicsBody?.categoryBitMask = ColliderType.Bird.rawValue
            bird.physicsBody?.collisionBitMask = ColliderType.Box.rawValue
        }
        
        // Kutular
        for i in 1...5 {
            let boxTexture = SKTexture(imageNamed: "brick")
            let size = CGSize(width: boxTexture.size().width / 8.1, height: boxTexture.size().height / 8.5)
            if let boxNode = childNode(withName: "box\(i)") as? SKSpriteNode {
                boxes.append(boxNode)
                boxNode.physicsBody = SKPhysicsBody(rectangleOf: size)
                boxNode.physicsBody?.isDynamic = true
                boxNode.physicsBody?.affectedByGravity = true
                boxNode.physicsBody?.allowsRotation = true
                boxNode.physicsBody?.mass = 0.2
                boxNode.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue
                
                // Kutunun başlangıç pozisyonunu kaydet
                boxOriginalPositions.append(boxNode.position)
            }
        }
        
        // Skor etiketi
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: 0, y: self.frame.height / 4)
        scoreLabel.zPosition = 2
        self.addChild(scoreLabel)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // İletişim başladığında
        
        if contact.bodyA.collisionBitMask == ColliderType.Bird.rawValue || contact.bodyB.collisionBitMask == ColliderType.Bird.rawValue {
            score += 1
            scoreLabel.text = String(score)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Dokunma algılandığında
        
        if gameStarted == false, let touch = touches.first {
            let touchLocation = touch.location(in: self)
            let touchedNodes = nodes(at: touchLocation)
            
            if let touchedSprite = touchedNodes.first as? SKSpriteNode, touchedSprite == bird {
                bird.position = touchLocation
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Dokunmayı taşıma
        
        touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Dokunma sona erdiğinde
        
        if gameStarted == false, let touch = touches.first {
            let touchLocation = touch.location(in: self)
            let touchedNodes = nodes(at: touchLocation)
            
            if let touchedSprite = touchedNodes.first as? SKSpriteNode, touchedSprite == bird {
                let dx = -(touchLocation.x - originalPosition.x)
                let dy = -(touchLocation.y - originalPosition.y)
                let impulse = CGVector(dx: dx, dy: dy)
                bird.physicsBody?.applyImpulse(impulse)
                bird.physicsBody?.affectedByGravity = true
                gameStarted = true
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Dokunma iptal edildiğinde
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Her kare öncesi çağrılır
        
        if let birdPhysicsBody = bird.physicsBody {
            if birdPhysicsBody.velocity.dx <= 0.1 && birdPhysicsBody.velocity.dy <= 0.1 && birdPhysicsBody.angularVelocity <= 0.1 && gameStarted == true {
                
                // Kuşun pozisyonunu sıfırla
                bird.physicsBody?.affectedByGravity = false
                bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                bird.physicsBody?.angularVelocity = 0
                bird.zPosition = 1
                bird.position = originalPosition
                gameStarted = false
                score = 0
                scoreLabel.text = String(score)
                
                // Kutuları başlangıç pozisyonlarına geri döndür
                for (index, box) in boxes.enumerated() {
                    box.position = boxOriginalPositions[index]
                    box.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    box.physicsBody?.angularVelocity = 0
                }
            }
        }
    }
}
