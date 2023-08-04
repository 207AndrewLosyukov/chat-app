//
//  RequestProtocols.swift
//  Messenger
//
//  Created by Андрей Лосюков on 28.04.2023.
//

import Foundation

protocol RequestProtocol {
    var urlRequest: URLRequest? { get }
}

struct ImageAPISearchResponse: Decodable {
    let total: Int?
    let hits: [ImageAPI]?
}

struct ImageAPI: Decodable {
    let imageUrl: String?

    enum CodingKeys: String, CodingKey {
        case imageUrl = "webformatURL"
    }
}

class ImageRequest: RequestProtocol {

    var urlRequest: URLRequest? {
        guard let url = URL(string: url) else {
            return nil
        }
        return URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
    }

    let url: String

    init(url: String) {
        self.url = url
    }
}

class ImageAPIListRequest: RequestProtocol {

    var urlRequest: URLRequest? {
        var urlComponents = URLComponents(string: host)
        urlComponents?.queryItems = []
        urlComponents?.queryItems?.append(.init(name: "key", value: apiKey))
        urlComponents?.queryItems?.append(.init(name: "q", value: query))
        urlComponents?.queryItems?.append(.init(name: "image_type", value: imageType))
        urlComponents?.queryItems?.append(.init(name: "per_page", value: "100"))
        guard let url = urlComponents?.url else {
            return nil
        }
        return URLRequest(url: url)
    }

    private let apiKey: String

    private let query = "countries"

    private let host = "https://pixabay.com/api/"

    private let imageType = "photo"

    init(apiKey: String) {
        self.apiKey = apiKey
    }
}
