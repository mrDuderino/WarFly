//
//  BitMaskCategory.swift
//  WarFly
//
//  Created by Vladimir Strepitov on 18.06.2022.
//

import Foundation


struct BitMaskCategory {
    
    static let player: UInt32 = 0x1 << 0      // 0000...00001   1
    static let enemy: UInt32 = 0x1 << 1       // 0000...00010   2
    static let powerUp: UInt32 = 0x1 << 2     // 0000...00100   4
    static let shot: UInt32 = 0x1 << 3        // 0000...01000   8
    
}
