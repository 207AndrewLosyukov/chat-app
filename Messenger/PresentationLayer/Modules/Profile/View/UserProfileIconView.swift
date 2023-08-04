//
//  UserProfileView.swift
//  Messenger
//
//  Created by Андрей Лосюков on 05.03.2023.
//

import UIKit

final class UserProfileIconView: UIImageView {

    override init(image: UIImage?) {
        super.init(frame: .zero)
        contentMode = .scaleAspectFill
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        self.image = image
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupCornerRadius()
    }

    func setupCornerRadius() {
        layer.cornerRadius = frame.size.height / 2
    }
}
