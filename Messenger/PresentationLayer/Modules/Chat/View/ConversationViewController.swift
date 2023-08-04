//
//  ConversationViewController.swift
//  Messenger
//
//  Created by Андрей Лосюков on 08.03.2023.
//

import UIKit
import Combine
import TFSChatTransport

struct MessageSection: Hashable {
    let label: String
    let isDate: Bool
    let id = UUID()
}

struct MessageItem: Hashable {
    let id = UUID()
    var model: MessageCellModel
}

class ConversationViewController: UIViewController {

    private var output: ConversationViewOutput

    private var theme: Theme?

    private var cancellables = Set<AnyCancellable>()

    private lazy var toolBar: UIView = {
        let toolBar = UIView()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        return toolBar
    }()

    private var model: DBChannelModel?

    private var sections = [MessageSection]()

    private var toolbarBottomConstraint: NSLayoutConstraint = NSLayoutConstraint()

    private lazy var tableView = UITableView(frame: .zero, style: .grouped)

    private lazy var dataSource: UITableViewDiffableDataSource<MessageSection, MessageItem> = {
        UITableViewDiffableDataSource<MessageSection, MessageItem>(tableView: tableView,
            cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier:
            MessageCell.Constants.reuseIdentifier, for: indexPath)
            (cell as? MessageCell)?.configure(with: itemIdentifier.model)
            cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            return cell
        })
    }()

    private lazy var avatarImageView: UIImageView = {
        let logo = Resources.Images.noNameImage
        let imageView = UIImageView(image: logo)
        imageView.layer.cornerRadius = 25
        imageView.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 25, y: 49, width: 50, height: 50)
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let name =  UILabel(frame: CGRect(x: 0, y: 104, width: UIScreen.main.bounds.width, height: 13.0))
        name.text = "Anna"
        name.font = UIFont.systemFont(ofSize: 11)
        name.textAlignment = .center
        return name
    }()

    private lazy var leftButton: UIButton = {
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: "chevron.left", withConfiguration: configuration)
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(backHandler), for: .touchUpInside)
        return button
    }()

    private lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 18
        textField.layer.borderWidth = 2.0
        textField.layer.borderColor = UIColor.systemGray3.cgColor
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.placeholder = "Type message"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 13, height: textField.frame.size.height))
        textField.leftViewMode = .always
        textField.textColor = .systemGray3
        textField.backgroundColor = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var navBar: UINavigationBar = {
        let navBar = UINavigationBar(frame: CGRect(x: -0.5, y: 0, width: UIScreen.main.bounds.width + 1, height: 137))
        navBar.layer.borderColor = UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 0.75).cgColor
        navBar.layer.borderWidth = 0.5
        return navBar
    }()

    private lazy var sendMessageButton: UIButton = {
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: "arrow.up.circle.fill", withConfiguration: configuration)
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        return button
    }()

    @objc func sendTapped() {
        output.sendTapped(text: inputTextField.text)
    }

    private var toolBarConstraint: NSLayoutConstraint = NSLayoutConstraint()

    init(output: ConversationViewOutput, model: DBChannelModel) {
        self.output = output
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        output.loadTheme()
        output.loadImage(with: model?.logoURL)
        output.setupCache()
        output.loadMessages()
        output.handlingSSE()
        setupUI()
    }

    private func setupUI() {
        nameLabel.text = model?.name
        tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        toolbarBottomConstraint = view.bottomAnchor.constraint(equalTo: toolBar.bottomAnchor, constant: 30)
        view.addSubview(navBar)
        view.addSubview(avatarImageView)
        view.addSubview(leftButton)
        view.addSubview(toolBar)
        navBar.addSubview(nameLabel)
        toolBar.addSubview(inputTextField)
        toolBar.addSubview(sendMessageButton)
        setupToolBar()
        setupInputTextField()
        setupSendMessageButton()
        setupLeftButton()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        output.loadTheme()
    }

    func setupToolBar() {
        toolbarBottomConstraint.isActive = true
        NSLayoutConstraint.activate([
            toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolBar.heightAnchor.constraint(equalToConstant: 52)
        ])
        NotificationCenter.default.addObserver(self,
        selector: #selector(keyboardShowing(notification:)), name:
        UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
        selector: #selector(keyboardHiding(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func setupInputTextField() {
        NSLayoutConstraint.activate([
            inputTextField.heightAnchor.constraint(equalToConstant: 36),
            inputTextField.topAnchor.constraint(equalTo: toolBar.topAnchor, constant: 8),
            inputTextField.leadingAnchor.constraint(equalTo: toolBar.leadingAnchor, constant: 8),
            inputTextField.trailingAnchor.constraint(equalTo: toolBar.trailingAnchor, constant: -8)
        ])
    }

    func setupSendMessageButton() {
        NSLayoutConstraint.activate([
            sendMessageButton.heightAnchor.constraint(equalToConstant: 32),
            sendMessageButton.widthAnchor.constraint(equalToConstant: 32),
            sendMessageButton.trailingAnchor.constraint(equalTo: inputTextField.trailingAnchor, constant: -4),
            sendMessageButton.centerYAnchor.constraint(equalTo: inputTextField.centerYAnchor)
        ])
    }

    func setupLeftButton() {
        NSLayoutConstraint.activate([
            leftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            leftButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 73)
        ])
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: toolBar.topAnchor),
            view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor)
        ])
        tableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.Constants.reuseIdentifier)
//        tableView.register(PhotoTableViewCell.self,
//        forCellReuseIdentifier: PhotoTableViewCell.Constants.reuseIdentifier)
        tableView.delegate = self
    }
}

extension ConversationViewController: ConversationViewInput {

    func setupTheme(theme: Theme) {
        self.theme = theme
        navBar.barStyle = theme.mainColors.barStyle
        tableView.sectionIndexBackgroundColor = theme.mainColors.backgroundColor
        tableView.backgroundColor = theme.mainColors.backgroundColor
        view.backgroundColor = theme.mainColors.backgroundColor
        navBar.backgroundColor = theme.mainColors.conversationView.navBarColor
        toolBar.tintColor = .darkGray
        nameLabel.textColor = theme.mainColors.titleColor
    }

    func setImage(data: Data) {
        if let image = UIImage(data: data) {
            self.avatarImageView.image = image
        }
    }

    func eraseText() {
        inputTextField.text = ""
    }

    func showNilTextAlert(title: String, message: String) {
        let nilTextAlert = UIAlertController(title: "",
                                             message: "Can't load messages", preferredStyle: .alert)
        nilTextAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
        }))
        self.present(nilTextAlert, animated: true)
    }

    func showData(dataMessages: [[MessageItem]], sections: [MessageSection]) {
        var snapshot = NSDiffableDataSourceSnapshot<MessageSection, MessageItem>()
        snapshot.appendSections(sections)
        for iter in 0..<(sections.count) {
            snapshot.appendItems(dataMessages[iter].reversed(), toSection: sections[iter])
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func showErrorAlert(title: String, message: String) {
        let errorTextAlert = UIAlertController(title: title,
        message: message, preferredStyle: .alert)
        errorTextAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
        }))
        present(errorTextAlert, animated: true)
    }

    func setSections(sections: [MessageSection]) {
        self.sections = sections
    }
}

// MARK: - UITableViewDelegate
extension ConversationViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .systemGray
        label.backgroundColor = .black
        label.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        label.backgroundColor = (theme ?? .day).mainColors.backgroundColor
        if sections.count > 0 && section < sections.count {
            if sections[section].isDate {
                label.textAlignment = .center
                label.text = sections[section].label
            } else {
                label.textAlignment = .left
                label.text = "        \(sections[section].label)"
            }
        } else {
            return nil
        }
        return label
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

@objc extension ConversationViewController {

    func backHandler() {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
        navigationController?.popViewController(animated: true)
    }

    func keyboardShowing(notification: NSNotification) {
        inputTextField.text = ""
        inputTextField.textColor = .black
        if let keyboardSize = (notification
            .userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            toolbarBottomConstraint.constant = keyboardSize.height
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
    }

    func keyboardHiding(notification: Notification) {
        UIView.animate(withDuration: 0.2) {
            self.toolbarBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}
