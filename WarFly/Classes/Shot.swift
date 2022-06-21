//
//  Shot.swift
//  WarFly
//
//  Created by Vladimir Strepitov on 16.06.2022.
//

import SpriteKit

class Shot: SKSpriteNode {
    
    let screenSize = UIScreen.main.bounds
    let initialSize = CGSize(width: 187, height: 237)
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
        self.name = "shotSprite"
        self.zPosition = 30
        self.setScale(0.16)
        
        // Physics
        self.physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.5, size: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = BitMaskCategory.shot.rawValue
        self.physicsBody?.collisionBitMask = BitMaskCategory.enemy.rawValue
        self.physicsBody?.contactTestBitMask = BitMaskCategory.enemy.rawValue
    }
    
    func startMovement() {
        performRotation()
        let moveForward = SKAction.moveTo(y: screenSize.height + 100, duration: 2)
        self.run(moveForward)
    }
    
    fileprivate func performRotation()  {
        for i in 1...32 {
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
