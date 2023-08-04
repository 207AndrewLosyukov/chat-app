//
//  ViewController.swift
//  Messenger
//
//  Created by Андрей Лосюков on 21.02.2023.
//

import UIKit

enum Section: Hashable, CaseIterable {
    case none
}

struct ChatItem: Hashable {
    let id: UUID = UUID()
    let model: DBChannelModel
    let theme: Theme
}

class ConversationsListViewController: UIViewController {

    private var theme: Theme?

    private var output: ConversationListViewOutput

    private let refreshControl = UIRefreshControl()

    private lazy var tableView = UITableView(frame: .zero, style: .plain)

    private lazy var dataSource = makeDataSource()

    init(output: ConversationListViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        overrideUserInterfaceStyle = .light
        tableView.scrollsToTop = true
        tableView.backgroundColor = .white
        setupNavigationBar()
        setupTableView()
        output.setupCachedChannels()
        output.refreshChannels()
        refreshControl.addTarget(self, action: #selector(refreshChannels), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.dataSource = dataSource
        tableView.delegate = self
        dataSource.output = output
        output.handleEvents()
    }

    override func viewWillAppear(_ animated: Bool) {
        output.loadTheme()
    }

    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableView.topAnchor),
            view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor)
        ])
        tableView.register(ConversationCell.self, forCellReuseIdentifier: ConversationCell.Constants.reuseIdentifier)
    }

    func makeDataSource() -> ConversationListDataSource {
        let dataSource = ConversationListDataSource(
            tableView: tableView, cellProvider: { [weak self] tableView, _, model in
                let cell = tableView.dequeueReusableCell(withIdentifier: ConversationCell.Constants.reuseIdentifier)
            (cell as? ConversationCell)?.configure(with: DBChannelModel(id: model.model.id,
                lastActivity: model.model.lastActivity,
                lastMessage: model.model.lastMessage,
                logoURL: model.model.logoURL,
                name: model.model.name))
            (cell as? ConversationCell)?.configureTheme(with: self?.theme ?? .day)
            cell?.selectionStyle = .none

            self?.output.loadImage(logoURL: model.model.logoURL) { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        (cell as? ConversationCell)?.avatarImageView.image = UIImage(data: data)
                    }
                case .failure:
                    break
                }
            }
            return cell
        })
        dataSource.defaultRowAnimation = .fade
        return dataSource
    }

    func setupNavigationBar() {
        let rightButton = UIBarButtonItem()
        rightButton.title = "Add Channel"
        rightButton.action = #selector(showAddChannelAlert)
        rightButton.target = self
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.title = "Channels"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension ConversationsListViewController: ConversationListViewInput {

    func showData(data: [ChatItem]) {
        var shapshot = NSDiffableDataSourceSnapshot<Section, ChatItem>()
        shapshot.appendSections([Section.none])
        shapshot.appendItems(data, toSection: Section.none)
        dataSource.apply(shapshot, animatingDifferences: true)
        tableView.reloadData()
    }

    func setupTheme(theme: Theme) {
        self.theme = theme
        navigationController?.navigationBar.barStyle = theme.mainColors.barStyle
        navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: theme.mainColors.tintColor]
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: theme.mainColors.tintColor
        ]
        view.backgroundColor = theme.mainColors.backgroundColor
        tableView.backgroundColor = theme.mainColors.backgroundColor
        tableView.reloadData()
    }

    func setLoading(enabled: Bool) {
        if enabled {
            refreshControl.beginRefreshing()
        } else {
            refreshControl.endRefreshing()
        }
    }

    @objc func refreshChannels() {
        output.refreshChannels()
    }

    func showErrorAlert(title: String, message: String) {
        let errorTextAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        errorTextAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(errorTextAlert, animated: true)
    }

    @objc func showAddChannelAlert() {
        let alert = UIAlertController(title: "New channel", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Channel Name"
            textField.font = UIFont.systemFont(ofSize: 15)
            textField.keyboardType = .default
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
        }))
        let createAction = UIAlertAction(title: "Create", style: .default,
                                         handler: { [weak self] _ in
            guard let textField = alert.textFields?.first else {
                return
            }
            self?.output.addChannel(name: textField.text ?? "", logoUrl: nil)
        })
        alert.addAction(createAction)
        alert.preferredAction = createAction
        self.present(alert, animated: true)
    }
}

// MARK: - Data source

final class ConversationListDataSource: UITableViewDiffableDataSource<Section, ChatItem> {

    weak var output: ConversationListViewOutput?

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let id = snapshot().itemIdentifiers[indexPath.row].model.id
            output?.deleteChannel(by: id)
            var snapshot = self.snapshot()
            snapshot.deleteItems([snapshot.itemIdentifiers[indexPath.row]])
            apply(snapshot)
            tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        44
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        76
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        output.didTapChannel(at: indexPath.row)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
