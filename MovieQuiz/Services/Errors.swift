//
//  Errors.swift
//  MovieQuiz
//
//  Created by Dmitry Medvedev on 20.01.2023.
//

import Foundation

enum Errors: Error {
    case errorLoadImage// = "Failed to load image. Try again."
    case codeError// = "Failed to process request."
    case errorDataLoad// = "Failed to load data. Try again."
}

extension Errors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .errorLoadImage:
            return NSLocalizedString("Failed to load image. Try again.", comment: "")
        case .codeError:
            return NSLocalizedString("Failed to process request. Try again.", comment: "")
        case .errorDataLoad:
            return NSLocalizedString("Failed to load data. Try again.", comment: "")
        }
    }
}
