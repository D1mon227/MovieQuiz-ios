//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Dmitry Medvedev on 08.01.2023.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}
