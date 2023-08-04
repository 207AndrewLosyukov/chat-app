//
//  ImageLoaderServiceProtocol.swift
//  Messenger
//
//  Created by Андрей Лосюков on 28.04.2023.
//

import Foundation

protocol ImageLoaderServiceProtocol {

    func loadImageListByAPI(handler: @escaping((Result<[String], Error>) -> Void))

    func loadImageByURL(url: String, handler: @escaping ((Result<Data, Error>) -> Void))
}
