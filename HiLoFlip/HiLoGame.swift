//
//  HiLoGame.swift
//  HiLoFlip
//
//  Created by Jude Burdick on 9/28/26.
//

import Foundation

struct HiLoGame {
    private(set) var deck: [Card] = []
    private(set) var players: [Player] = []
    private(set) var isTokenHi: Bool = false
    
    
    struct Card {
        let value: Int
        fileprivate(set) var isFaceUp: Bool = true
        var isSpecialCard: Bool { isTenPointCard || isSkipCard || isMustPlaySecondCard }
        var isTenPointCard: Bool { value % 10 == 0 }
        var isSkipCard: Bool { value % 10 == 1 }
        var isMustPlaySecondCard: Bool { value % 10 == 2 }
        init(value: Int) {
            self.value = value
        }
    }
    
    struct Player {
        private(set) var name: String
        fileprivate(set) var hand: [Card] = []
        private(set) var score: Int = 0
        init(name: String) {
            self.name = name
        }
    }
    
    init(playerNames: [String]) {
        deck = (1...100).map { Card(value: $0) }
        players = playerNames.map { Player(name: $0) }
        isTokenHi = Bool.random()
    }
    
    mutating func dealCards() {
        for playerIndex in players.indices {
            if let card = deck.popLast() {
                players[playerIndex].hand.append(card)
            }
        }
    }
    
    mutating func resetGame() {
        isTokenHi = Bool.random()
        deck = []
        for playerIndex in players.indices {
            players[playerIndex].hand = []
        }
        for _ in 1...7 {
            dealCards()
        }
    }
    
}
