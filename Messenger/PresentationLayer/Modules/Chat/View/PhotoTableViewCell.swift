//
//  PhotoCell.swift
//  Messenger
//
//  Created by Андрей Лосюков on 28.04.2023.
//

import UIKit

class PhotoTableViewCell: UITableViewCell, ConfigurableViewProtocol {

    enum Constants {
        static var reuseIdentifier = "chatCollectionViewCell"
    }

    private var isIncomingFirstConstraint: NSLayoutConstraint?

    private var isIncomingSecondConstraint: NSLayoutConstraint?

    private var isNotIncomingFirstConstraint: NSLayoutConstraint?

    private var isNotIncomingSecondConstraint: NSLayoutConstraint?

    private var contentHeightConstraint: NSLayoutConstraint?

    private var contentHeightSecondConstraint: NSLayoutConstraint?

    private var imageMessageHeightConstraint: NSLayoutConstraint?

    private var imageMessage: UIImageView = UIImageView(image: Resources.Images.placeholder)

    private var isIncoming = false

    private var theme: Theme?

    typealias ConfigurationModel = PhotoTableCellModel

    func configure(with model: PhotoTableCellModel) {
        if let image = model.image {
            setupImageSize(with: image)
        }
        isIncoming = model.isIncoming
        theme = model.theme
        setupTheme()
        setupConstraints()
        setupVariativeMessagesConstraints()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        setupTheme()
        if let image = imageMessage.image {
            setupImageSize(with: image)
        }
        super.prepareForReuse()
    }

    private func setupUI() {
        setupTheme()
        isIncomingFirstConstraint = imageMessage
        .leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15)
        isIncomingSecondConstraint = imageMessage
        .trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -85)
        isNotIncomingFirstConstraint = imageMessage
        .trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        isNotIncomingSecondConstraint = imageMessage
        .leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 85)
        imageMessage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageMessage)
        if let image = imageMessage.image {
            setupImageSize(with: image)
        }
        setupConstraints()
    }

    private func setupImageSize(with image: UIImage) {
        let aspectRatio = image.size.width / image.size.height
        imageMessage.image = image
        imageMessage.contentMode = .scaleAspectFit

        contentHeightConstraint?.isActive = false
        contentHeightConstraint = nil
        contentHeightConstraint = imageMessage.heightAnchor.constraint(equalTo:
        imageMessage.widthAnchor, multiplier: 1 / aspectRatio)
        contentHeightConstraint?.isActive = true

        contentHeightSecondConstraint?.isActive = false
        contentHeightSecondConstraint = nil
        contentHeightSecondConstraint =
        contentView.heightAnchor.constraint(equalTo: imageMessage.heightAnchor, constant: 20)
        contentHeightSecondConstraint?.isActive = true
    }

    private func setupConstraints() {
        setupVariativeMessagesConstraints()
    }

    func setupTheme() {
        contentView.backgroundColor = (theme ?? .day).mainColors.backgroundColor
    }

    private func setupVariativeMessagesConstraints () {
        if isIncoming {
            isNotIncomingFirstConstraint?.isActive = false
            isNotIncomingSecondConstraint?.isActive = false
            isIncomingFirstConstraint?.isActive = true
            isIncomingSecondConstraint?.isActive = true
        } else {
            isIncomingFirstConstraint?.isActive = false
            isIncomingSecondConstraint?.isActive = false
            isNotIncomingFirstConstraint?.isActive = true
            isNotIncomingSecondConstraint?.isActive = true
        }
    }
}
