//
//  Leaderboard.swift
//  HiLoFlip
//
//  Created by Jude Burdick on 11/21/26.
//

import Foundation

struct LeaderboardEntry: Codable {
    let playerName: String
    let score: Int
    let createdAt: String
}

protocol LeaderboardService {
    func record(_ entry: LeaderboardEntry)
    func topEntries(limit: Int) -> [LeaderboardEntry]
}

class LocalLeaderboardService: LeaderboardService {
    private var entries: [LeaderboardEntry] = []
    private static let saveURL = URL.documentsDirectory
        .appending(path: "leaderboard.json")
    init() {
        if let data = try? Data(contentsOf: Self.saveURL),
           let savedEntries = try? JSONDecoder().decode([LeaderboardEntry].self, from: data) {
            entries = savedEntries
        }
    }
    func record(_ entry: LeaderboardEntry) {
        entries.append(entry)
        _ = try? JSONEncoder().encode(entries).write(to: Self.saveURL)
    }
    func topEntries(limit: Int) -> [LeaderboardEntry] {
        Array(entries.sorted { $0.score > $1.score}.prefix(limit))
    }
}
