import Foundation

protocol MessageDataSourceProtocol: AnyObject {
    func saveMessagesModels(with messagesModels: [DBMessageModel], in channelID: String)
    func saveMessageModel(with messageModel: DBMessageModel, in channelID: String)
    func getMessages(for channelID: String) -> [DBMessageModel]
}

final class MessageDataSourceService: MessageDataSourceProtocol {

    private let coreDataMessageService: CoreDataMessageServiceProtocol

    init(coreDataMessageService: CoreDataMessageServiceProtocol) {
        self.coreDataMessageService = coreDataMessageService
    }

    func getMessages(for channelID: String) -> [DBMessageModel] {
        let messages = coreDataMessageService.fetchMessages(for: channelID).compactMap({ message in
            if let uuid = message.uuid,

                let userID = message.userID,
                let text = message.text,
                let date = message.date {

                return DBMessageModel(uuid: uuid, userID: userID, text: text, date: date, channelID: channelID)

            } else {
                return nil
            }
        })
        return messages
    }

    func saveMessagesModels(with messagesModels: [DBMessageModel], in channelID: String) {
        Logger.log(text: "MessageCoreDataSource func: \(#function)")
        coreDataMessageService.save { context in
            let fetchRequest = DBChannel.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", channelID as CVarArg)
            do {
                let channel = try context.fetch(fetchRequest).first
                var array = []
                for messageModel in messagesModels {
                    let dbMessage = DBMessage(context: context)
                    dbMessage.text = messageModel.text
                    dbMessage.channel = channel
                    dbMessage.userID = messageModel.userID
                    dbMessage.date = messageModel.date
                    dbMessage.uuid = messageModel.uuid
                    array.append(dbMessage)
                }
                channel?.messages = NSOrderedSet(array: array)
                channel?.lastMessage = messagesModels.last?.text
                channel?.lastActivity = messagesModels.last?.date
                Logger.log(text: "Messages correctly saved in \(channelID)")
            } catch {
                Logger.log(text: "Error saving messages in \(channelID)")
            }
        }
    }

    func saveMessageModel(with messageModel: DBMessageModel, in channelID: String) {
        Logger.log(text: "MessageCoreDataSource func: \(#function)")
        coreDataMessageService.save { context in
            let fetchRequest = DBChannel.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", channelID as CVarArg)
            do {
                let channel = try context.fetch(fetchRequest).first
                let dbMessage = DBMessage(context: context)
                dbMessage.text = messageModel.text
                dbMessage.channel = channel
                dbMessage.userID = messageModel.userID
                dbMessage.date = messageModel.date
                dbMessage.uuid = messageModel.uuid
                channel?.addToMessages(dbMessage)
                Logger.log(
                text: "Save message: \(messageModel) in channel with channelID: \(channelID) done succesfully\n"
                )
            } catch {
                Logger.log(
                text: "Save message: \(messageModel) in channel with channelID: \(channelID) got error: \(error)\n"
                )
            }
        }
    }
}
