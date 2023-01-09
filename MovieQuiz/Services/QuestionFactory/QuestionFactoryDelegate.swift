//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Dmitry Medvedev on 03.01.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
