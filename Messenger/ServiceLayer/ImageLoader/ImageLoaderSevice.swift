//
//  ImageLoaderSevice.swift
//  Messenger
//
//  Created by Андрей Лосюков on 26.04.2023.
//

import Foundation

class ImageLoaderService: ImageLoaderServiceProtocol {

    let networkService: NetworkServiceProtocol
    let apiKey: String

    init(networkService: NetworkServiceProtocol, apiKey: String) {
        self.networkService = networkService
        self.apiKey = apiKey
    }

    func loadImageListByAPI(handler: @escaping((Result<[String], Error>) -> Void)) {
        networkService.fetch(request: ImageAPIListRequest(apiKey: apiKey),
                            parser: AdditionalDecoder<ImageAPISearchResponse>()) { (result) in
            switch result {
            case .success(let searchResponse):
                let imageUrls = searchResponse.hits?.compactMap { $0.imageUrl } ?? []
                handler(.success(imageUrls))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }

    func loadImageByURL(url: String, handler: @escaping ((Result<Data, Error>) -> Void)) {
        networkService.fetch(request: ImageRequest(url: url),
                            parser: DefaultDecoder()) { (result) in
            switch result {
            case .success(let data):
                handler(.success(data))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
