//
//  TokenSide.swift
//  HiLoFlip
//
//  Created by Jude Burdick on 9/14/26.
//

import Foundation

enum TokenSide {
    case hi, lo
    
    var label: String {
        switch self {
        case .hi: return "HI"
        case .lo: return "LO"
        }
    }
    
    var flipped: TokenSide {
        switch self {
        case .hi: return .lo
        case .lo: return .hi
        }
    }
}
