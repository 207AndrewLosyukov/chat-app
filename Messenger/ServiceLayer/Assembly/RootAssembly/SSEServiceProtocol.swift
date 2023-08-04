//
//  SSEServiceProtocol.swift
//  Messenger
//
//  Created by Андрей Лосюков on 27.04.2023.
//

import Combine
import TFSChatTransport

protocol SSEServiceProtocol {
    func subscribeOnEvents() -> AnyPublisher<ChatEvent, Error>
    func cancelSubscription()
}

extension SSEService: SSEServiceProtocol {}
