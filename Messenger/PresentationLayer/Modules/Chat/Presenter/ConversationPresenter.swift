//
//  ConversationViewOutput.swift
//  Messenger
//
//  Created by Андрей Лосюков on 19.04.2023.
//

import UIKit
import TFSChatTransport
import Combine

final class ConversationPresenter {

    private let chatService: ChatServiceProtocol?

    private let sseService: SSEServiceProtocol?

    private let messageDataSourceService: MessageDataSourceProtocol?

    private let themeService: GetThemeServiceProtocol?

    private let imageLoaderService: ImageLoaderServiceProtocol?

    private var cancellables = Set<AnyCancellable>()

    private var channelId: String?

    private var theme: Theme?

    weak var viewInput: ConversationViewInput?

    private var dataMessages: [[MessageItem]] = []

    private var sections: [MessageSection] = [MessageSection]()

    private lazy var uniqueId = getUniqueId()

    init(serviceAssembly: ConversationServiceAssembly, channelId: String) {
        self.chatService = serviceAssembly.chatService
        self.messageDataSourceService = serviceAssembly.messageDataSourceService
        self.imageLoaderService = serviceAssembly.imageLoaderService
        self.channelId = channelId
        self.themeService = serviceAssembly.themeService
        self.sseService = serviceAssembly.sseService
    }

    func checkIfUrlAndLoadData(string: String) -> Data? {
        var data: Data?
        imageLoaderService?.loadImageByURL(url: string, handler: { result in
                switch result {
                case .success(let imageData):
                    data = imageData
                case .failure:
                    break
                }
        })
        return data
    }

    func handleData(messages: [DBMessageModel]) {
        dataMessages.append([MessageItem]())
        dataMessages.append([MessageItem]())
        dataMessages[1].append(MessageItem(
            model: MessageCellModel(
                text: messages[0].text,
                date: messages[0].date,
                isIncoming: messages[0].userID != uniqueId,
                userId: messages[0].userID,
                theme: theme ?? .day
        )))
        sections.append(MessageSection(label:
        parseDateToString(date: messages[0].date), isDate: true))
        var firstLabel = ""
        if messages[0].userID != uniqueId {
            firstLabel = messages[0].userID
        }
        sections.append(MessageSection(label: firstLabel, isDate: false))
        var index = 1
        for iter in 1..<messages.count {
            if messages[iter].userID != messages[iter - 1].userID {
                var label = ""
                if messages[iter].userID != uniqueId {
                    label = messages[iter].userID
                }
                sections.append(MessageSection(label: label, isDate: false))
                dataMessages.append([MessageItem]())
                index += 1
            } else if messages[iter].date.daysBetween(date: messages[iter - 1].date) > 0 {
                sections.append(MessageSection(label:
                parseDateToString(date: messages[iter].date), isDate: true))
            }
            dataMessages[index].append(MessageItem(
                model: MessageCellModel(
                    text: messages[iter].text,
                    date: messages[iter].date,
                    isIncoming: messages[iter].userID != uniqueId,
                    userId: messages[iter].userID,
                    theme: theme ?? .day
                )))
        }
        sections.reverse()
        dataMessages.reverse()
    }

    func handlingSSE() {
        sseService?.subscribeOnEvents()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure:
                    self?.viewInput?.showErrorAlert(title: "SSE Service error", message: "")
                }}, receiveValue: { [weak self] event in
                    if event.eventType == .update &&
                        event.resourceID == self?.channelId {
                        print(event.resourceID)
                        DispatchQueue.global(qos: .background).sync {
                            self?.loadMessages()
                        }
                }
            })
            .store(in: &cancellables)
    }
}

extension ConversationPresenter: ConversationViewOutput {

    func loadTheme() {
        self.theme = themeService?.getTheme()
        viewInput?.setupTheme(theme: theme ?? .day)
    }

    func loadImage(with imageURL: String?) {
        if let imageURL = imageURL {
            imageLoaderService?.loadImageByURL(url: imageURL, handler: { [weak self] result in
                switch result {
                case .success(let imageData):
                    DispatchQueue.main.async {
                        self?.viewInput?.setImage(data: imageData)
                    }
                case .failure:
                    break
                }
            })
        }
    }

    func loadMessageImage(with imageURL: String?, completion: @escaping ((Data) -> Void)) {
        if let imageURL = imageURL {
            imageLoaderService?.loadImageByURL(url: imageURL, handler: { result in
                switch result {
                case .success(let imageData):
                    DispatchQueue.main.async {
                        completion(imageData)
                    }
                case .failure:
                    break
                }
            })
        }
    }

    func sendTapped(text: String?) {
        if let text = text {
            if text != "" && text.trimmingCharacters(in: .whitespaces).count != 0 {
                chatService?.sendMessage(text: text, channelId: channelId ?? "", userId: uniqueId, userName: "Андрей")
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { [weak self] completion in
                        switch completion {
                        case .failure:
                            self?.viewInput?.showErrorAlert(
                            title: "Error",
                            message: "Can't send messages. Check your network")
                        case .finished:
                            self?.viewInput?.eraseText()
                        }
                    }, receiveValue: { _ in
                    })
                    .store(in: &cancellables)
                return
            }
        }
        viewInput?.showErrorAlert(title: "Error", message: "Can't send empty messages.")
    }

    func setupCache() {
        let messages = messageDataSourceService?.getMessages(for: channelId ?? "")
        if let messages = messages {
            if messages.count > 0 {
                handleData(messages: messages)
                viewInput?.showData(dataMessages: dataMessages, sections: sections)
                viewInput?.setSections(sections: sections)
            }
        }
    }

    private func parseDateToString(date: Date) -> String {
        if Date().daysBetween(date: date) == 0 {
            return "Today"
        } else if Date().get(.year) != date.get(.year) {
        return "\(DateFormatter().monthSymbols[date.get(.month) - 1].prefix(3)), \(date.get(.day)), \(date.get(.year))"
        } else {
            return "\(DateFormatter().monthSymbols[date.get(.month) - 1].prefix(3)), \(date.get(.day))"
        }
    }

    func loadMessages() {
        dataMessages = []
        sections = [MessageSection]()
        chatService?.loadMessages(channelId: channelId ?? "")
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure:
                    DispatchQueue.main.async {
                        self?.viewInput?.showNilTextAlert(title: "Error", message: "Can't load messages")
                    }
                case .finished:
                    return
                }
            }, receiveValue: { [weak self] messages in
                if messages.count > 0 {
                    self?.handleData(messages: messages.map { [weak self] model in
                DBMessageModel(uuid: UUID(),
                userID: model.userID,
                text: model.text,
                date: model.date,
                channelID: self?.channelId ?? "")
                    })
                    if let channelId = self?.channelId {
                        DispatchQueue.global(qos: .background).async {
                            self?.messageDataSourceService?.saveMessagesModels(with: messages.map { message in
                                return DBMessageModel(uuid: UUID(),
                                                      userID: message.userID,
                                                      text: message.text,
                                                      date: message.date,
                                                      channelID: channelId)
                            }, in: channelId)
                        }
                        self?.viewInput?.setSections(sections: self?.sections ?? [])
                        self?.viewInput?.showData(
                            dataMessages: self?.dataMessages ?? [],
                            sections: self?.sections ?? []
                        )
                    }
                }
            }
            )
            .store(in: &cancellables)
        }

    func getUniqueId () -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
    }
}
