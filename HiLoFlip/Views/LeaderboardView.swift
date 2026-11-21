//
//  LeaderboardView.swift
//  HiLoFlip
//
//  Created by Jude Burdick on 11/21/26.
//

import SwiftUI

struct LeaderboardView: View {
    let leaderboard: LeaderboardService
    @State private var entries: [LeaderboardEntry] = []
    var body: some View {
        List(entries.indices, id: \.self) { index in
            Text("\(entries[index].playerName): \(entries[index].score)")
        }
        .overlay { if entries.isEmpty { Text("No scores yet. Finish a round!")}}
        .navigationTitle("Leaderboard")
        .onAppear { entries = leaderboard.topEntries(limit: 10)}
    }
}
