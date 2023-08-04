//
//  ConfigurableViewProtocol.swift
//  Messenger
//
//  Created by Андрей Лосюков on 05.03.2023.
//

import Foundation

protocol ConfigurableViewProtocol {

    associatedtype ConfigurationModel
    func configure(with model: ConfigurationModel)
}
