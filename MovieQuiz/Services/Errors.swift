//
//  Errors.swift
//  MovieQuiz
//
//  Created by Dmitry Medvedev on 20.01.2023.
//

import Foundation

enum Errors: String, Error {
    case errorLoadImage = "Failed to load image. Try again."
    case codeError = "Failed to process request."
    case errorDataLoad = "Failed to load data. Try again."
}
