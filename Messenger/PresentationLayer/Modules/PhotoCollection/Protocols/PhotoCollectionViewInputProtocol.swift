//
//  PhotoCollectionViewInputProtocol.swift
//  Messenger
//
//  Created by Андрей Лосюков on 11.05.2023.
//

import Foundation

protocol PhotoCollectionViewInputProtocol: ViewSetupThemeProtocol, AnyObject {

    func animatingIndicator(enabled: Bool)

    func reloadItem(at index: Int)

    func reloadData()

    func showErrorAlert(_ message: String)
}
