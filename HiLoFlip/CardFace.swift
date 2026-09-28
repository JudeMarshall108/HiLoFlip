//
//  CardFace.swift
//  HiLoFlip
//
//  Created by Jude Burdick on 9/14/26.
//

import Foundation

enum CardFace {
    case faceUp, faceDown
    
    var flipped: CardFace {
        switch self {
        case .faceUp: return .faceDown
        case .faceDown: return .faceUp
        }
    }
}
