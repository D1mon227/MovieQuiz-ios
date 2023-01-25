//
//  Errors.swift
//  MovieQuiz
//
//  Created by Dmitry Medvedev on 20.01.2023.
//

import Foundation

enum Errors: Error {
    case errorLoadImage, codeError, errorDataLoad
    
    var errorText: String {
        switch self {
        case .errorLoadImage:
            return "Failed to load image. Try again."
        case .codeError:
            return "Failed to process request. Try again."
        case .errorDataLoad:
            return "No Internet connection. Try again."
        }
    }
}
