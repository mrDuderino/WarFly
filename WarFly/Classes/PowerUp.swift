//
//  PowerUp.swift
//  WarFly
//
//  Created by Vladimir Strepitov on 15.06.2022.
//

import SpriteKit

class PowerUp: SKSpriteNode {
    
    let initialSize = CGSize(width: 52, height: 52)
    let textureAtlas: SKTextureAtlas!
    var textureNameBeginWith = ""
    var animationSpriteArray = [SKTexture]()
    
    init(textureAtlas: SKTextureAtlas) {
        self.textureAtlas = textureAtlas
        let textureNameArray = textureAtlas.textureNames.sorted()
        let textureName = textureNameArray[0]
        textureNameBeginWith = String(textureName.dropLast(6)) // 01.png
        let texture = textureAtlas.textureNamed(textureName)
        super.init(texture: texture, color: .clear, size: initialSize)
        self.name = "sprite"
        self.zPosition = 20
        self.setScale(0.5)
        
        // Physics
        self.physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.5, size: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = BitMaskCategory.powerUp.rawValue
        self.physicsBody?.collisionBitMask = BitMaskCategory.player.rawValue
        self.physicsBody?.contactTestBitMask = BitMaskCategory.player.rawValue
    }
    
    func startMovement() {
        performRotation()
        let moveForward = SKAction.moveTo(y: -100, duration: 5)
        self.run(moveForward)
    }
    
    fileprivate func performRotation() {
        for i in 1...15 {
            let number = String(format: "%02d", i)
            let texture = SKTexture(imageNamed: textureNameBeginWith + String(number))
            animationSpriteArray.append(texture)
        }
        SKTexture.preload(animationSpriteArray) {
            let rotation = SKAction.animate(with: self.animationSpriteArray,
                                            timePerFrame: 0.05,
                                            resize: true,
                                            restore: false)
            let rotationForever = SKAction.repeatForever(rotation)
            self.run(rotationForever)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
