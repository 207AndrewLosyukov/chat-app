//
//  PhotoCollectionCell.swift
//  Messenger
//
//  Created by Андрей Лосюков on 27.04.2023.
//

import UIKit

class PhotoCollectionCell: UICollectionViewCell, ConfigurableViewProtocol {

    enum Constants {
        static var reuseIdentifier = "itemCollectionViewCell"
    }

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    typealias ConfigurationModel = PhotoCollectionCellModel

    func configure(with model: PhotoCollectionCellModel) {
        imageView.image = model.image ?? Resources.Images.placeholder
        contentView.addSubview(imageView)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
