//
//  Background.swift
//  WarFly
//
//  Created by Vladimir Strepitov on 31.05.2022.
//

import SpriteKit

class Background: SKSpriteNode {

    static func populateBackground(at point: CGPoint) -> Background {
        let background = Background(imageNamed: "background")
        background.position = point
        background.zPosition = 0
        return background
    }
}
