//
//  GameScene.swift
//  WarFly
//
//  Created by Vladimir Strepitov on 03.06.2022.
//

import SpriteKit
import GameplayKit


class GameScene: ParentScene {
    
    var backgroundMusic: SKAudioNode!
    
    fileprivate var player: PlayerPlane!
    fileprivate let hud = HUD()
    fileprivate let screenSize = UIScreen.main.bounds.size
    fileprivate var lives = 3 {
        didSet {
            switch lives {
            case 3:
                hud.life1.isHidden = false
                hud.life2.isHidden = false
                hud.life3.isHidden = false
            case 2:
                hud.life1.isHidden = false
                hud.life2.isHidden = false
                hud.life3.isHidden = true
            case 1:
                hud.life1.isHidden = false
                hud.life2.isHidden = true
                hud.life3.isHidden = true
            default:
                break
            }
        }
    }

    
    override func didMove(to view: SKView) {
        gameSettings.loadGameSettings()
        
        if gameSettings.isMusic && backgroundMusic == nil {
            if let musicURL = Bundle.main.url(forResource: "backgroundMusic", withExtension: "m4a") {
                backgroundMusic = SKAudioNode(url: musicURL)
                addChild(backgroundMusic)
            }
        } else if gameSettings.isMusic == false && backgroundMusic != nil {
            backgroundMusic.removeFromParent()
        }
        self.scene?.isPaused = false
        guard sceneManager.gameScene == nil else { return }
        sceneManager.gameScene = self
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zero
        
        configureStartScene()
        spawnClouds()
        spawnIslands()
        self.player.performFly()
        spawnPowerUp()
        spawnEnemies()
        createHUD()
        
    }
    
    fileprivate func createHUD() {
        addChild(hud)
        hud.configureUI(screenSize: screenSize)
        
    }
    
    fileprivate func spawnEnemies() {
        let actionWait = SKAction.wait(forDuration: 3.0)
        let spawnSpiralAction = SKAction.run { [unowned self] in
            self.spawnSpiralOfEnemies()
        }
        self.run(SKAction.repeatForever(SKAction.sequence([actionWait, spawnSpiralAction])))
    }
    
    fileprivate func spawnPowerUp() {
        let spawnAction = SKAction.run {
            let randomNumer = Int(arc4random_uniform(2))
            let powerUp = randomNumer == 1 ? BluePowerUp() : GreenPowerUp()
            let randomPositionX = Int(arc4random_uniform(UInt32(self.size.width - 30)))
            powerUp.position = CGPoint(x: CGFloat(randomPositionX), y: self.size.height + 100)
            powerUp.startMovement()
            self.addChild(powerUp)
        }
        
        let randomTimeSpawn = Double(arc4random_uniform(11) + 10)
        let waitAction = SKAction.wait(forDuration: randomTimeSpawn)
        
        self.run(SKAction.repeatForever(SKAction.sequence([spawnAction, waitAction])))
    }
    
    fileprivate func spawnSpiralOfEnemies() {
        let enemyTextureAtlas1 = Assets.shared.enemy_1Atlas
        let enemyTextureAtlas2 = Assets.shared.enemy_2Atlas
        SKTextureAtlas.preloadTextureAtlases([enemyTextureAtlas1, enemyTextureAtlas2]) { [unowned self] in
            
            let randomNumber = Int(arc4random_uniform(2))
            let arrayOfAtlases = [enemyTextureAtlas1, enemyTextureAtlas2]
            let textureAtlas = arrayOfAtlases[randomNumber]
            
            let waitAction = SKAction.wait(forDuration: 1.0)
            let spawnEnemy = SKAction.run { [unowned self] in
                let textureNames = textureAtlas.textureNames.sorted()
                let texture = textureAtlas.textureNamed(textureNames[12])
                let enemy = Enemy(enemyTexture: texture)
                enemy.position = CGPoint(x: self.size.width / 2,
                                         y: self.size.height + 110)
                self.addChild(enemy)
                enemy.flySpiral()
            }
            let spawnAction = SKAction.sequence([waitAction, spawnEnemy])
            let repeatAction = SKAction.repeat(spawnAction, count: 3)
            self.run(repeatAction)
        }
    }
    
    fileprivate func spawnClouds() {
        let spawnCloudWait = SKAction.wait(forDuration: 1)
        let spawnCloudAction = SKAction.run {
            let cloud = Cloud.populate(at: nil)
            self.addChild(cloud)
        }
        
        let spawnCloudSequence = SKAction.sequence([spawnCloudWait, spawnCloudAction])
        let spawnCloudForever = SKAction.repeatForever(spawnCloudSequence)
        run(spawnCloudForever)
    }
    
    fileprivate func spawnIslands() {
        let spawnIslandWait = SKAction.wait(forDuration: 2)
        let spawnIslandAction = SKAction.run {
            let island = Island.populate(at: nil)
            self.addChild(island)
        }
        
        let spawnIslandSequence = SKAction.sequence([spawnIslandWait, spawnIslandAction])
        let spawnIslandForever = SKAction.repeatForever(spawnIslandSequence)
        run(spawnIslandForever)
    }
    
    fileprivate func configureStartScene() {
        let screenCenterPoint = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        let background = Background.populateBackground(at: screenCenterPoint)
        background.size = self.size
        self.addChild(background)
        
        let screen = UIScreen.main.bounds
        
        let island1 = Island.populate(at: CGPoint(x: 100, y: 200))
        self.addChild(island1)
        
        let island2 = Island.populate(at: CGPoint(x: self.size.width - 100, y: self.size.height - 200))
        self.addChild(island2)
        
        player = PlayerPlane.populate(at: CGPoint(x: screen.size.width / 2, y: 120))
        self.addChild(player)
        
    }
    
    fileprivate func playerFire() {
        let shot = YellowShot()
        shot.position = self.player.position
        shot.startMovement()
        self.addChild(shot)
    }
    
    override func didSimulatePhysics() {
        
        player.checkPosition()
        
        enumerateChildNodes(withName: "sprite") { (node, stop) in
            if node.position.y <= -100 {
                node.removeFromParent()
            }
        }
        enumerateChildNodes(withName: "bluePowerUp") { (node, stop) in
            if node.position.y <= -100 {
                node.removeFromParent()
            }
        }
        enumerateChildNodes(withName: "greenPowerUp") { (node, stop) in
            if node.position.y <= -100 {
                node.removeFromParent()
            }
        }
        enumerateChildNodes(withName: "shotSprite") { (node, stop) in
            if node.position.y >= self.size.height + 100 {
                node.removeFromParent()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "pause" {
            let transition = SKTransition.doorway(withDuration: 1.0)
            let pauseScene = PauseScene(size: self.size)
            pauseScene.scaleMode = .aspectFill
            sceneManager.gameScene = self
            self.scene?.isPaused = true
            self.scene!.view?.presentScene(pauseScene, transition: transition)
        } else {
            playerFire()
        }
    }
}


extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactCaregory: BitMaskCategory = [contact.bodyA.category, contact.bodyB.category]
        let explosion = SKEmitterNode(fileNamed: "EnemyExplosion")
        let contactPoint = contact.contactPoint
        explosion?.position = contactPoint
        explosion?.zPosition = 25
        let waitForExplosionAction = SKAction.wait(forDuration: 1.0)
        
        switch contactCaregory {
        case [.enemy, .player]:
            if contact.bodyA.node?.name == "sprite" {
                if contact.bodyA.node?.parent != nil {
                    contact.bodyA.node?.removeFromParent()
                    lives -= 1
                }
            } else {
                if contact.bodyB.node?.parent != nil {
                    contact.bodyB.node?.removeFromParent()
                    lives -= 1
                }
            }
            addChild(explosion!)
            self.run(waitForExplosionAction) { explosion?.removeFromParent() }
            if lives == 0 {
                gameSettings.currentScore = hud.score
                gameSettings.saveScores()
                let gameOverScene = GameOverScene(size: self.size)
                let transition = SKTransition.doorsCloseVertical(withDuration: 1.0)
                gameOverScene.scaleMode = .aspectFill
                self.scene!.view?.presentScene(gameOverScene, transition: transition)
            }
        case [.player, .powerUp]:
            if contact.bodyA.node?.parent != nil && contact.bodyB.node?.parent != nil {
                if contact.bodyA.node?.name == "greenPowerUp" {
                    contact.bodyA.node?.removeFromParent()
                    if lives < 3 {
                        lives += 1
                    }
                    player.colorPowerUp(withColor: .green)
                } else if contact.bodyB.node?.name == "greenPowerUp" {
                    contact.bodyB.node?.removeFromParent()
                    if lives < 3 {
                        lives += 1
                    }
                    player.colorPowerUp(withColor: .green)
                } else if contact.bodyA.node?.name == "bluePowerUp" {
                    contact.bodyA.node?.removeFromParent()
                    hud.score += 25
                    player.colorPowerUp(withColor: .blue)
                } else if contact.bodyB.node?.name == "bluePowerUp" {
                    contact.bodyB.node?.removeFromParent()
                    hud.score += 25
                    player.colorPowerUp(withColor: .blue)
                }
            }
            
        case [.enemy, .shot]:
            if contact.bodyA.node?.parent != nil && contact.bodyB.node?.parent != nil {
                contact.bodyA.node?.removeFromParent()
                contact.bodyB.node?.removeFromParent()
                if gameSettings.isSound {
                    self.run(SKAction.playSoundFileNamed("hitSound", waitForCompletion: false))
                }
                hud.score += 5
                addChild(explosion!)
                self.run(waitForExplosionAction) { explosion?.removeFromParent() }
            }
        default:
            preconditionFailure("Unable to detect collision category")
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
}














