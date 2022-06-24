//
//  GameSettings.swift
//  WarFly
//
//  Created by Vladimir Strepitov on 23.06.2022.
//

import SpriteKit

class GameSettings: NSObject {

    let ud = UserDefaults.standard
    var isMusic = true
    var isSound = true
    let musicKey = "music"
    let soundKey = "sound"
    
    override init() {
        super.init()
        
        
    }
    
    func saveGameSettings() {
        ud.set(isMusic, forKey: musicKey)
        ud.set(isSound, forKey: soundKey)
        print("Music: ", ud.bool(forKey: musicKey))
        print("Sound: ", ud.bool(forKey: soundKey))
    }
    
    func loadGameSettings() {
        guard ud.value(forKey: musicKey) != nil && ud.value(forKey: soundKey) != nil else { return }
        isMusic = ud.bool(forKey: musicKey)
        isSound = ud.bool(forKey: soundKey)
    }
}
