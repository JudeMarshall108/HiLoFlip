//
//  SpecialSymbol.swift
//  HiLoFlip
//
//  Created by Jude Burdick on 9/14/26.
//

import Foundation

enum SpecialSymbol {
    case tenPoint, skip, mustPlaySecond
    
    var sfSymbolName: String {
        switch self {
        case .tenPoint: return "star.fill"
        case .skip: return "circle.slash"
        case .mustPlaySecond: return "doc.on.doc.fill"
        }
    }
}
