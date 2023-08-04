//
//  CALayerExtension.swift
//  Messenger
//
//  Created by Андрей Лосюков on 20.03.2023.
//

import UIKit

extension CALayer {
    func addBorder(rectEdge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        switch rectEdge {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .bottom:
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
            border.backgroundColor = color.cgColor
            addSublayer(border)
        default:
            break
        }
    }
}
