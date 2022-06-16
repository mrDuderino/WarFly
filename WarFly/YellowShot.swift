//
//  YellowShot.swift
//  WarFly
//
//  Created by Vladimir Strepitov on 16.06.2022.
//

import SpriteKit

class YellowShot: Shot {
    init() {
        let textureAtlas = SKTextureAtlas(named: "YellowAmmo")
        super.init(textureAtlas: textureAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
