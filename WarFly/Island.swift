//
//  Island.swift
//  WarFly
//
//  Created by Vladimir Strepitov on 31.05.2022.
//

import SpriteKit
import GameplayKit

final class Island: SKSpriteNode, GameBackgroundSpriteable {

    static func populate() -> Island {
        let islandImageName = configureName()
        let island = Island(imageNamed: islandImageName)
        island.setScale(randomScaleFactor)
        island.position = randomPoint()
        island.zPosition = 1
        island.run(rotateForRandomAngle())
        island.run(move(from: island.position))
        
        return island
    }
    
    static func populate(at point: CGPoint) -> Island {
        let islandImageName = configureName()
        let island = Island(imageNamed: islandImageName)
        island.setScale(randomScaleFactor)
        island.position = point
        island.zPosition = 1
        island.run(rotateForRandomAngle())
        island.run(move(from: island.position))
        
        return island
    }
    
    private static func configureName() -> String {
        let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 4)
        let randomNumber = distribution.nextInt()
        let imageName = "is\(randomNumber)"
        
        return imageName
    }
    
    private static var randomScaleFactor: CGFloat {
        let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 10)
        let randomNumber = CGFloat(distribution.nextInt()) / 10
        
        return randomNumber
    }
    
    private static func rotateForRandomAngle() -> SKAction {
        let distribution = GKRandomDistribution(lowestValue: 0, highestValue: 360)
        let randomNumber = CGFloat(distribution.nextInt())
        
        return SKAction.rotate(toAngle: randomNumber * CGFloat(Double.pi / 180), duration: 0)
    }
    
    private static func move(from point: CGPoint) -> SKAction {
        let movePoint = CGPoint(x: point.x, y: -200)
        let moveDistance = point.y + 200
        let movementSpeed: CGFloat = 100.0
        let duration = moveDistance / movementSpeed
        
        return SKAction.move(to: movePoint, duration: duration)
    }
}
