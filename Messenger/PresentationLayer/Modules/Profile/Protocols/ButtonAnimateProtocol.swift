//
//  ButtonAnimateProtocol.swift
//  Messenger
//
//  Created by Андрей Лосюков on 04.05.2023.
//

import UIKit

protocol ButtonPressedAnimateProtocol {
    func animateButton(with duration: Double)
    func onPressed(_ sender: UILongPressGestureRecognizer)
}
