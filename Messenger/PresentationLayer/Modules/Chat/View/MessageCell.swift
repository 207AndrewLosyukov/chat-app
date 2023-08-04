//
//  MessageCell.swift
//  Messenger
//
//  Created by Андрей Лосюков on 08.03.2023.
//

import UIKit

final class MessageCell: UITableViewCell, ConfigurableViewProtocol {

    enum Constants {
        static var reuseIdentifier = "messageCell"
    }

    typealias ConfigurationModel = MessageCellModel

    var theme: Theme?

    func configure(with model: MessageCellModel) {
        text = model.text
        date = model.date
        isIncoming = model.isIncoming
        messageLabel.text = model.text
        self.theme = model.theme
        setupTheme()
        guard let image = UIImage(named: isIncoming ? "received" : "sent") else {
            return
        }
        messageImageView.image = image
            .resizableImage(withCapInsets:
                                UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20),
                            resizingMode: .stretch)
            .withRenderingMode(.alwaysTemplate)
        setupVariativeMessagesConstraints()
        setDate()
    }

    private var isIncoming: Bool = false

    private var isIncomingFirstConstraint: NSLayoutConstraint?

    private var isIncomingSecondConstraint: NSLayoutConstraint?

    private var isNotIncomingFirstConstraint: NSLayoutConstraint?

    private var isNotIncomingSecondConstraint: NSLayoutConstraint?

    private var text: String = ""

    private var date: Date = Date()

    private var incomingBackgroundColor: UIColor?

    private var outgoingBackgroundColor: UIColor?

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.text = text
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11)
        if isIncoming {
            label.textColor = .systemGray
        } else {
            label.textColor = .systemGray3
        }
        return label
    }()

    private var messageImageView = UIImageView()

    private func setDate() {
        let intHour = date.get(.hour)
        let intMinute = date.get(.minute)
        var hour: String
        var minute: String
        if intHour < 10 {
            hour = "0\(intHour)"
        } else {
            hour = "\(intHour)"
        }
        if intMinute < 10 {
            minute = "0\(intMinute)"
        } else {
            minute = "\(intMinute)"
        }
        dateLabel.text = "\(hour):\(minute)"
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
        super.prepareForReuse()
    }

    // MARK: - Setup UI
    func setupTheme() {
        contentView.backgroundColor = (theme ?? .day).mainColors.backgroundColor
        incomingBackgroundColor = (theme ?? .day).mainColors.conversationView.receivedBackground
        outgoingBackgroundColor = (theme ?? .day).mainColors.conversationView.sendBackground
        if isIncoming {
            messageLabel.textColor = theme?.mainColors.conversationView.receivedTextColor
            messageImageView.tintColor = theme?.mainColors.conversationView.receivedBackground
            dateLabel.textColor = .systemGray
        } else {
            messageLabel.textColor = theme?.mainColors.conversationView.sendTextColor
            messageImageView.tintColor = theme?.mainColors.conversationView.sendBackground
            dateLabel.textColor = .systemGray3
        }
    }

    private func setupUI() {
        contentView.addSubview(messageLabel)
        setupTheme()
        guard let image = UIImage(named: isIncoming ? "received" : "sent") else { return }
        messageImageView.addSubview(messageLabel)
        messageImageView.image = image
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(messageImageView)
        contentView.addSubview(messageLabel)
        contentView.addSubview(dateLabel)
        isIncomingFirstConstraint = messageImageView
        .leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15)
        isIncomingSecondConstraint = messageImageView
        .trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -85)
        isNotIncomingFirstConstraint = messageImageView
        .trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        isNotIncomingSecondConstraint = messageImageView
        .leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 85)
        setupImageView()
        setupDateLabel()
    }

    private func setupDateLabel() {
        setDate()
        NSLayoutConstraint.activate([
            dateLabel.bottomAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: -6),
            dateLabel.trailingAnchor.constraint(equalTo: messageImageView.trailingAnchor, constant: -15)
        ])
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

    private func setupImageView() {
        NSLayoutConstraint.activate([
            messageImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            messageImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            messageImageView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -6),
            messageImageView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -12),
            messageImageView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 60),
            messageImageView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 6)
        ])
        setupVariativeMessagesConstraints()
    }
}
