import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    // MARK: - Lifecycle
    
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenter(delegate: self)
        statisticService = StatisticServiceImplementation()
    }
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        switchButton()
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        switchButton()
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private func switchButton() {
        yesButton.isEnabled.toggle()
        noButton.isEnabled.toggle()
    }
    
    private func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.image = step.image
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            guard let statisticService = statisticService else { return }
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let totalAccuracyPercentage = String(format: "%.2f", statisticService.totalAccuracy * 100) + "%"
            let bestGameDate = statisticService.bestGame.date.dateTimeString
            let bestGameStats = "\(statisticService.bestGame.correct)/\(statisticService.bestGame.total)"
            let text = "Ваш результат: \(correctAnswers)/\(questionsAmount)\n Кол-во сыгранных квизов: \(statisticService.gamesCount)\n Рекорд: \(bestGameStats) \(bestGameDate)\n Средняя точность: \(totalAccuracyPercentage)"
            let alert = AlertModel(title: "Этот раунд окончен!",
                                   message: text,
                                   buttonText: "Сыграть еще раз",
                                   completion: { [weak self] in
                guard let self = self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
                self.imageView.layer.borderWidth = 0
            })
            alertPresenter?.showAlert(model: alert)
            switchButton()
        } else {
            imageView.layer.borderWidth = 0
            currentQuestionIndex += 1
            self.questionFactory?.requestNextQuestion()
            switchButton()
        }
    }
}
