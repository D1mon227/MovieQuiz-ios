//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Dmitry Medvedev on 14.01.2023.
//

import Foundation

// Отвечает за загрузку данных по URL
struct NetworkClient {
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        let myError: Error = Errors.codeError
        
        let task = URLSession.shared.dataTask(with: request) { data, responce, error in
            if error != nil {
                // Проверяем, пришла ли ошибка
                handler(.failure(myError))
                return
            }
            // Проверяем, что нам пришёл успешный код ответа
            if let responce = responce as? HTTPURLResponse,
               responce.statusCode < 200 || responce.statusCode >= 300 {
                handler(.failure(myError))
                return
            }
            // Возвращаем данные
            guard let data = data else { return }
            handler(.success(data))
        }
        task.resume()
    }
}
