//
//  HiLoGame.swift
//  HiLoFlip
//
//  Created by Jude Burdick on 9/28/26.
//

import Foundation

struct HiLoGame: Codable {
    private(set) var deck: [Card] = []
    private(set) var players: [Player] = []
    private(set) var discardPile: [Card] = []
    private(set) var isTokenHi: Bool = false
    private(set) var currentPlayerIndex: Int = 0
    private(set) var recoveryStep: RecoveryStep = .playing
    
    var opponentIndex: Int {
        if currentPlayerIndex == 0 {
            return 1
        } else {
            return 0
        }
    }
    
    var winnerIndex: Int? {
        players.firstIndex { player in
            if player.hand.isEmpty {
                return true
            }
            return false
        }
    }
    
   var isRoundOver: Bool {
       if winnerIndex == nil {
           return false
       } else {
           return true
       }
    }
    
    var hasPlayableCard: Bool {
        players[currentPlayerIndex].hand.contains { card in
            canPlay(card)
        }
    }
    
    var canTossToken: Bool {
        !isRoundOver
        && recoveryStep == .playing
        && !hasPlayableCard
    }
    
    var canDrawCard: Bool {
        !isRoundOver && recoveryStep == .draw
    }
    
    var canResetDiscardPile: Bool {
        !isRoundOver && recoveryStep == .reset
    }
    
    mutating func resetDiscardPile() {
        guard canResetDiscardPile else { return }
        players[opponentIndex].collectedCards.append(contentsOf: discardPile)
        discardPile = []
        recoveryStep = .playing
    }
    
    private mutating func clearPlayerCards() {
        for playerIndex in players.indices {
            players[playerIndex].hand = []
            players[playerIndex].collectedCards = []
            players[playerIndex].score = 0
        }
    }
    
    mutating func tossToken() {
        guard canTossToken else { return }
        let previousSide = isTokenHi
        isTokenHi = Bool.random()
        recoveryStep = isTokenHi == previousSide ? .draw : .playing
    }
    
    struct Card: Codable {
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
    
    struct Player: Codable {
        fileprivate(set) var name: String
        fileprivate(set) var hand: [Card] = []
        fileprivate(set) var collectedCards: [Card] = []
        fileprivate(set) var score: Int = 0
        init(name: String) {
            self.name = name
        }
    }
    
    private mutating func scoreRound() {
        guard let winnerIndex = winnerIndex else { return }
        players[winnerIndex].collectedCards.append(contentsOf: discardPile)
        discardPile = []
        for playerIndex in players.indices {
            players[playerIndex].score = players[playerIndex].collectedCards.reduce(0) { total, card in
                total + (card.isTenPointCard ? 10 : 1)
            }
        }
        players[winnerIndex].score += 10
    }
    
    enum RecoveryStep: Codable {
        case playing
        case draw
        case reset
    }
    
    mutating func renamePlayer(at index: Int, to name: String) {
        players[index].name = name
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
        recoveryStep = .playing
        currentPlayerIndex = 0
        isTokenHi = Bool.random()
        deck = (1...100).map { Card(value: $0) }.shuffled()
        clearPlayerCards()
        discardPile = []
        for _ in 1...7 { dealCards() }
        updateHandVisibility()
    }
    
    private mutating func updateHandVisibility() {
        for playerIndex in players.indices {
            let isCurrentPlayer = playerIndex == currentPlayerIndex
            for cardIndex in players[playerIndex].hand.indices {
                players[playerIndex].hand[cardIndex].isFaceUp
                = isCurrentPlayer
            }
        }
    }
    
    func canPlay(_ card: Card) -> Bool {
        let hand = players[currentPlayerIndex].hand
        guard hand.contains(where: { $0.value == card.value }), !isRoundOver else {
            return false
        }
        guard let topCard = discardPile.last else {
            return true
        }
        return isTokenHi
        ? card.value > topCard.value
        : card.value < topCard.value
    }
    
    mutating func play(_ card: Card) -> Bool {
        guard canPlay(card) else {
            return false
        }
        guard let cardIndex = players[currentPlayerIndex].hand.firstIndex(where: { $0.value == card.value }) else {
            return false
        }
        let playedCard = players[currentPlayerIndex].hand.remove(at: cardIndex)
        discardPile.append(playedCard)
        finishTurn(after: playedCard)
        return true
    }
    
    mutating func switchTurns() {
        recoveryStep = .playing
        currentPlayerIndex = opponentIndex
        updateHandVisibility()
    }
    
    private mutating func finishTurn(after card: Card) {
        guard !isRoundOver else {
            scoreRound()
            return
        }
        if card.isSkipCard {
            _ = drawCard(for: opponentIndex)
        }
        if card.isSkipCard || card.isMustPlaySecondCard {
            recoveryStep = hasPlayableCard ? .playing : .reset
            return
        }
        switchTurns()
    }
    private mutating func refillDeckIfNeeded() {
        guard deck.isEmpty, discardPile.count > 1 else { return }
        let topCard = discardPile.removeLast()
        deck = discardPile.shuffled()
        discardPile = [topCard]
    }
    
    private mutating func drawCard(for playerIndex: Int) -> Bool {
        refillDeckIfNeeded()
        guard let card = deck.popLast() else { return false }
        players[playerIndex].hand.append(card)
        updateHandVisibility()
        return true
    }
    
    mutating func drawRequiredCard() {
        guard canDrawCard else { return }
        _ = drawCard(for: currentPlayerIndex)
        recoveryStep = .playing
        if !hasPlayableCard {
            recoveryStep = .reset
        }
    }
    
}
