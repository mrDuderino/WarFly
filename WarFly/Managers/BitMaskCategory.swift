//
//  BitMaskCategory.swift
//  WarFly
//
//  Created by Vladimir Strepitov on 18.06.2022.
//

import SpriteKit

extension SKPhysicsBody {
    var category: BitMaskCategory {
        get {
            return BitMaskCategory(rawValue: self.categoryBitMask)
        }
        set {
            self.categoryBitMask = newValue.rawValue
        }
    }
}

struct BitMaskCategory: OptionSet {
    
    let rawValue: UInt32
    
    static let none =    BitMaskCategory(rawValue: 0 << 0)     // 0000...00000   0
    static let player =  BitMaskCategory(rawValue: 1 << 0)     // 0000...00001   1
    static let enemy =   BitMaskCategory(rawValue: 1 << 1)     // 0000...00010   2
    static let powerUp = BitMaskCategory(rawValue: 1 << 2)     // 0000...00100   4
    static let shot =    BitMaskCategory(rawValue: 1 << 3)     // 0000...01000   8
    static let all =     BitMaskCategory(rawValue: UInt32.max) // 1111...11111
    
}
