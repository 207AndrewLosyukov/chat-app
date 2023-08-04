//
//  ConversationListPresenter.swift
//  Messenger
//
//  Created by Андрей Лосюков on 18.04.2023.
//

import UIKit
import TFSChatTransport
import Combine

final class ConversationListViewPresenter {

    private let chatService: ChatServiceProtocol?

    private var cancellables = Set<AnyCancellable>()

    private var theme: Theme?

    private var themeService: GetThemeServiceProtocol?

    private let channelDataSourceService: ChannelDataSourceProtocol?

    weak var viewInput: ConversationListViewInput?

    private let imageLoaderService: ImageLoaderServiceProtocol?

    private let sseService: SSEServiceProtocol?

    private var data = [ChatItem]()

    private var moduleOutput: ConversationListModuleOutput?

    init(serviceAssembly: ConversationListServiceAssembly,
         moduleOutput: ConversationListModuleOutput) {

        self.chatService = serviceAssembly.chatService
        self.channelDataSourceService = serviceAssembly.channelDataSourceService
        self.imageLoaderService = serviceAssembly.imageLoaderService
        self.themeService = serviceAssembly.themeService
        self.sseService = serviceAssembly.sseService
        self.moduleOutput = moduleOutput
    }
}

extension ConversationListViewPresenter: ConversationListViewOutput {

    func handleEvents() {
        sseService?.subscribeOnEvents()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure:
                    self?.viewInput?.showErrorAlert(title: "SSE Service error", message: "")
                }}, receiveValue: { [weak self] event in
                    switch event.eventType {
                    case .update:
                        self?.refreshChannels()
                    case .add:
                        self?.refreshChannels()
                    case .delete:
                        self?.data.removeAll(where: { chatItem in
                            chatItem.model.id == event.resourceID
                        })
                        self?.channelDataSourceService?.deleteChannelModel(with: event.resourceID)
                        self?.viewInput?.showData(data: self?.data ?? [])
                    }
            })
            .store(in: &cancellables)
    }

    func loadTheme() {
        self.theme = themeService?.getTheme()
        viewInput?.setupTheme(theme: theme ?? .day)
        viewInput?.showData(data: data)
    }

    func loadImage(logoURL: String?, handler: @escaping ((Result<Data, Error>) -> Void)) {
        if let logoURL = logoURL {
            imageLoaderService?.loadImageByURL(url: logoURL, handler: handler)
        }
    }

    func didTapChannel(at itemIndex: Int) {
        moduleOutput?.moduleWantsToOpenConversation(with: data[itemIndex].model)
    }

    @objc func addChannel(name: String?, logoUrl: String?) {
        if let name,
            name != ""
            && name.trimmingCharacters(in: .whitespaces).count != 0 {
        chatService?.createChannel(name: name,
                                  logoUrl: logoUrl)
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .failure:
                self?.viewInput?.showErrorAlert(title: "Error", message: "Can't create channel. Check your network.")
            default:
                return
            }
        }, receiveValue: { [weak self] channel in
            var snapshot = NSDiffableDataSourceSnapshot<Section, ChatItem>()
            snapshot.appendSections(Section.allCases)
            self?.data.insert(
                ChatItem(
                    model: DBChannelModel(
                        id: channel.id,
                        lastActivity: channel.lastActivity,
                        lastMessage: channel.lastMessage,
                        logoURL: channel.logoURL,
                        name: channel.name
                    ), theme: self?.theme ?? .day
                ),
                at: 0
            )

            self?.channelDataSourceService?.saveChannelsModels(with: self?.data.map { channel in
                return channel.model
            } ?? [])
            self?.viewInput?.showData(data: self?.data ?? [])
        })
        .store(in: &cancellables)
        } else {
            viewInput?.showErrorAlert(title: "Error",
            message: "You can't create channel with empty name")
        }
    }

    func deleteChannel(by id: String) {
        channelDataSourceService?.deleteChannelModel(with: id)
        chatService?.deleteChannel(id: id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure:
                    self?.viewInput?.showErrorAlert(title: "Error", message: "Error delete channel from server")
                default:
                    return
                }
            }, receiveValue: { _ in
            })
            .store(in: &cancellables)
    }

    @objc func refreshChannels() {
        viewInput?.setLoading(enabled: true)
        chatService?.loadChannels()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure:
                    self?.viewInput?.showErrorAlert(title: "Error", message: "Can't load channels")
                    self?.setupCachedChannels()
                    self?.viewInput?.setLoading(enabled: false)
                default:
                    return
                }
            }, receiveValue: { [weak self] channels in
                if channels.count > 0 {
                    self?.data = channels.map({ [weak self] channel in
                        ChatItem(model: DBChannelModel(
                            id: channel.id,
                            lastActivity: channel.lastActivity,
                            lastMessage: channel.lastMessage,
                            logoURL: channel.logoURL, name: channel.name),
                            theme: self?.theme ?? .day
                        )
                    })
                    .filter { channel in
                        return channel.model.name != ""
                        && channel.model.name.trimmingCharacters(in: .whitespaces).count != 0
                    }
                    self?.resaveCoreData()
                    self?.data = self?.data.sorted(by: {(leftChatModel, rightChatModel) in
                        leftChatModel.model.lastActivity ??
                        Date(timeIntervalSince1970: 0) >
                        rightChatModel.model.lastActivity ??
                        Date(timeIntervalSince1970: 0)
                    }) ?? []
                    self?.viewInput?.showData(data: self?.data ?? [])
                    self?.viewInput?.setLoading(enabled: false)
                }
            })
            .store(in: &cancellables)
    }

    func setupCachedChannels() {
        let dbChannels = channelDataSourceService?.getChannelsModels() ?? []
        data = dbChannels.map({ channel in
            ChatItem(model: channel, theme: theme ?? .day)
        })
        .filter { channel in
            return channel.model.name != ""
            && channel.model.name.trimmingCharacters(in: .whitespaces).count != 0
        }

        data = data.sorted(by: { (leftChatModel, rightChatModel) in
            leftChatModel.model.lastActivity ??
            Date(timeIntervalSince1970: 0) >
            rightChatModel.model.lastActivity ??
            Date(timeIntervalSince1970: 0)
        })

        viewInput?.showData(data: data)
    }

    func resaveCoreData() {
        channelDataSourceService?.deleteChannelsModels()
        channelDataSourceService?.saveChannelsModels(with: data.map { channel in
            return channel.model
        })
    }
}
