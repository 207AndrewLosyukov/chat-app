//
//  TinkoffEmitter.swift
//  Messenger
//
//  Created by Андрей Лосюков on 04.05.2023.
//

import UIKit

class TinkoffEmitter {

    private let layer = CAEmitterLayer()

    private lazy var emitterCell: CAEmitterCell = {
        let cell = CAEmitterCell()
        cell.contents = UIImage(named: "tinkoff")?.cgImage
        cell.birthRate = 7
        cell.lifetime = 1
        cell.emissionLongitude = 1
        cell.emissionRange = 0.1
        cell.scaleRange = 0.05
        cell.alphaSpeed = 0.15
        cell.scale = 0.05
        cell.velocity = 5
        cell.velocityRange = 10
        return cell
    }()

    init(in view: UIView) {
        layer.emitterShape = .point
        layer.birthRate = 0
        layer.emitterSize = CGSize(width: 3, height: 3)
        layer.emitterPosition = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        layer.emitterCells = [emitterCell]
        view.layer.addSublayer(layer)
    }

    func start(at location: CGPoint) {
        if let height = layer.superlayer?.frame.height {
            if location.y < height {
                layer.emitterPosition = location
                layer.birthRate = 7
            }
        }
    }

    func move(to location: CGPoint) {
        if let height = layer.superlayer?.frame.height {
            if location.y < height {
                layer.emitterPosition = location
            }
        }
    }

    func stop() {
        layer.birthRate = 0
    }
}
