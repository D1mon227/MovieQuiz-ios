//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Dmitry Medvedev on 03.01.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)
}
