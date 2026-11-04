//
//  InstructionsView.swift
//  HiLoFlip
//
//  Created by Jude Burdick on 11/3/26.
//

import SwiftUI

struct InstructionsView: View {
    var body: some View {
        ScrollView {
            rules
                .padding()
        }
        .navigationTitle("Instructions")
    }
    
    private var rules: some View {
        VStack(alignment: .leading, spacing: 20) {
            rule("Goal", detail: "Start with seven cards. Empty your hand to win the round.")
            rule("HI and LO", detail: "HI requires a higher card than the top discard. LO requires a lower card. Any card may start an empty pile.")
            rule("Your Turn", detail: "Drag a card from the active hand onto the discard pile. Invalid drops return to your hand.")
            rule("Cannot Play?", detail: "Toss the token. If it changes sides, try the new direction. If it stays the same, draw one card and try again.")
            rule("Reset Play", detail: "If you still cannot play, the previous player collects the discard pile. Play any card to start a new pile. Special-card reset exceptions apply.")
            rule("Skip: Ending in 1", detail: "Your opponent draws one card and loses their turn. With two players, you play again.")
            rule("Play Again: Ending in 2", detail: "Immediately play another legal card, unless this was your final card.")
        }
    }
    
    private func rule(_ title: String, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
            Text(detail)
                .font(.body)
        }
    }
    
}

#Preview {
    InstructionsView()
}
