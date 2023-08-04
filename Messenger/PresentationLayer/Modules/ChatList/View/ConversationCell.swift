//
//  ConversationCell.swift
//  Messenger
//
//  Created by Андрей Лосюков on 05.03.2023.
//

import UIKit
import TFSChatTransport

final class ConversationCell: UITableViewCell, ConfigurableViewProtocol {

    typealias ConfigurationModel = DBChannelModel

    enum Constants {
        static var reuseIdentifier = "conversationCell"
    }

    func configure(with model: DBChannelModel) {
        name = model.name
        message = model.lastMessage
        date = model.lastActivity
        setupConfiguration()
        logoURL = model.logoURL
        setupTheme()
    }

    private var theme: Theme = .day

    func configureTheme(with theme: Theme) {
        self.theme = theme
    }

    private var logoURL: String?

    private var name: String = ""

    private var message: String?

    private var date: Date?

    private var isOnline: Bool = false

    private var hasUnreadMessages: Bool?

    lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView(image: Resources.Images.noNameImage)
        avatarImageView.layer.cornerRadius = 22.5
        avatarImageView.backgroundColor = .systemYellow
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.clipsToBounds = true
        return avatarImageView
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()

    private lazy var greenCircle: UIView = {
        let greenCircle = UIView()
        greenCircle.layer.cornerRadius = 6
        greenCircle.backgroundColor = UIColor(hexString: "#30D158")
        greenCircle.translatesAutoresizingMaskIntoConstraints = false
        return greenCircle
    }()

    private lazy var circle: UIView = {
        let circle = UIView()
        circle.layer.cornerRadius = 8
        circle.backgroundColor = .white
        circle.translatesAutoresizingMaskIntoConstraints = false
        return circle
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()

    private lazy var chevronImage: UIImageView = UIImageView(image: UIImage(systemName: "chevron.right"))

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        avatarImageView.image = Resources.Images.noNameImage
        setupTheme()
        super.prepareForReuse()
    }

    private func setupUI() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(chevronImage)
        contentView.addSubview(dateLabel)
        separatorInset = UIEdgeInsets(top: 0, left: 65, bottom: 0, right: 0)
        avatarImageView.addSubview(circle)
        circle.addSubview(greenCircle)
        setupAvatarImageView()
        setupNameLabel()
        setupMessageLabel()
        setupOnlineCircle()
        setupDateLabel()
        setupChevronImage()
    }

    private func setupOnlineStatus() {
        if isOnline {
            greenCircle.isHidden = false
            circle.isHidden = false
        } else {
            greenCircle.isHidden = true
            circle.isHidden = true
        }
    }

    private func setupTheme() {
        contentView.backgroundColor = (theme ).mainColors.conversationListView.cellBackground
        setupOnlineStatus()
        if hasUnreadMessages ?? false {
            messageLabel.font = UIFont.boldSystemFont(ofSize: 15)
            messageLabel.textColor = (theme ).mainColors.conversationListView.textColor
        } else {
            messageLabel.font = UIFont.systemFont(ofSize: 15)
            messageLabel.textColor = (theme ).mainColors.conversationListView.secondaryTextColor
        }
        nameLabel.text = name
        nameLabel.textColor = theme.mainColors.titleColor
        dateLabel.textColor = theme.mainColors.conversationListView.secondaryTextColor
        chevronImage.tintColor = theme.mainColors.conversationListView.secondaryTextColor
    }

    private func setupConfiguration() {
        setupTheme()
        if let message = message {
            messageLabel.text = message
            chevronImage.isHidden = false
            dateLabel.isHidden = false
        } else {
            messageLabel.text = "No messages yet"
            chevronImage.isHidden = true
            dateLabel.isHidden = true
        }
        // этой логики не должно быть в ячейке
        if let date = date {
            if Date().daysBetween(date: date) == 0 {
                if message != nil {
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
            } else {
                dateLabel.text = "\(DateFormatter().monthSymbols[date.get(.month) - 1].prefix(3)), \(date.get(.day))"
                dateLabel.text = "\(dateLabel.text?.prefix(1).uppercased() ?? "")\(dateLabel.text?.dropFirst() ?? "")"
            }
        }
        chevronImage.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupAvatarImageView() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.5),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.heightAnchor.constraint(equalToConstant: 45),
            avatarImageView.widthAnchor.constraint(equalToConstant: 45)
        ])
    }

    private func setupDateLabel() {
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            dateLabel.trailingAnchor.constraint(equalTo: chevronImage.trailingAnchor, constant: -19)
        ])
    }

    private func setupOnlineCircle() {
        NSLayoutConstraint.activate([
            circle.topAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: 0.5),
            circle.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor),
            circle.heightAnchor.constraint(equalToConstant: 16),
            circle.widthAnchor.constraint(equalToConstant: 16),
            greenCircle.heightAnchor.constraint(equalToConstant: 12),
            greenCircle.widthAnchor.constraint(equalToConstant: 12),
            greenCircle.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
            greenCircle.centerYAnchor.constraint(equalTo: circle.centerYAnchor)
        ])
    }

    private func setupNameLabel() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(lessThanOrEqualTo: contentView.topAnchor, constant: 18),
            nameLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            nameLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func setupMessageLabel() {
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }

    private func setupChevronImage() {
        NSLayoutConstraint.activate([
            chevronImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 17),
            chevronImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
