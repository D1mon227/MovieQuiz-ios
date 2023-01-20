//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Dmitry Medvedev on 14.01.2023.
//

import Foundation

struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let imageURL: URL
    
    var resizedImageURL: URL {
        // создаем строку из адреса
        let urlString = imageURL.absoluteString
        // обрезаем лишнюю часть и добавялем модификатор желаемого качества
        let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0UX600_.jpg"
        // пытаемся создать новый адрес, если не получается возвращаем старый
        guard let newUrl = URL(string: imageUrlString) else {
            return imageURL
        }
        return newUrl
    }
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}
