//
//  Assets.swift
//  WarFly
//
//  Created by Vladimir Strepitov on 17.06.2022.
//

import SpriteKit

class Assets {
    static let shared = Assets()
    let yellowShotAtlas = SKTextureAtlas(named: "YellowAmmo")
    let enemy_1Atlas = SKTextureAtlas(named: "Enemy_1")
    let enemy_2Atlas = SKTextureAtlas(named: "Enemy_2")
    let greenPowerUpAtlas = SKTextureAtlas(named: "GreenPowerUp")
    let bluePowerUpAtlas = SKTextureAtlas(named: "BluePowerUp")
    let playerPlaneAtlas = SKTextureAtlas(named: "PlayerPlane")
    
    func preloadAssets() {
        yellowShotAtlas.preload { print("YellowAmmo atlas preloaded") }
        enemy_1Atlas.preload { print("Enemy_1 atlas preloaded") }
        enemy_2Atlas.preload { print("Enemy_2 atlas preloaded") }
        greenPowerUpAtlas.preload { print("GreenPowerUp atlas preloaded") }
        bluePowerUpAtlas.preload { print("BluePowerUp atlas preloaded") }
        playerPlaneAtlas.preload { print("PlayerPlane atlas preloaded") }
    }
}
