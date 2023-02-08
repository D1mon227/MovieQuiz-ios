//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Dmitry Medvedev on 03.02.2023.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private let statisticService: StatisticService!
    private weak var viewController: MovieQuizViewControllerProtocol?
    var questionFactory: QuestionFactoryProtocol?
    
    private var cancelIndicatorTask: DispatchWorkItem?
    private var currentQuestion: QuizQuestion?
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        statisticService = StatisticServiceImplementation()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        proceedWithAnswer(isCorrect: currentQuestion.correctAnswer == isYes)
        if currentQuestion.correctAnswer == isYes {
            correctAnswers += 1
        }
        
    }
    
    func makeResultsMessage() -> String {
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        
        let totalAccuracyPercentage = String(format: "%.2f", statisticService.totalAccuracy * 100) + "%"
        let bestGameDate = statisticService.bestGame.date.dateTimeString
        let bestGameStats = "\(statisticService.bestGame.correct)/\(statisticService.bestGame.total)"
        
        let resultMessage = "Ваш результат: \(correctAnswers)/\(questionsAmount)\n Кол-во сыгранных квизов: \(statisticService.gamesCount)\n Рекорд: \(bestGameStats) \(bestGameDate)\n Средняя точность: \(totalAccuracyPercentage)"
        
        return resultMessage
    }
    
    private func proceedToNextQuestionOrResults() {
        if self.isLastQuestion() {
            viewController?.showEndGameResults()
        } else {
            cancelIndicatorTask = DispatchWorkItem {
                self.viewController?.activityIndicator.startAnimating()
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: cancelIndicatorTask!)
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
            viewController?.switchButton()
            }
    }
    
    private func proceedWithAnswer(isCorrect: Bool) {
        viewController?.switchButton()
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
        }
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        cancelIndicatorTask?.cancel()
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.hideLoadingIndicator()
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Errors) {
        viewController?.showNetworkError(message: error.errorText)
    }
}
