//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Dmitry Medvedev on 07.01.2023.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
}

extension GameRecord: Comparable {
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        if lhs.total == 0 {
            return true
        }
        let lhsValue: Double = Double(lhs.correct) / Double(lhs.total)
        let rhsValue: Double = Double(rhs.correct) / Double(rhs.total)
        
        return lhsValue < rhsValue
    }
}
