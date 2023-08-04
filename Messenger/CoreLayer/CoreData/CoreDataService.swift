import CoreData
import Foundation

protocol CoreDataMessageServiceProtocol: AnyObject {
    func fetchMessages(for channelID: String) -> [DBMessage]
    func save(block: @escaping (NSManagedObjectContext) throws -> Void)
}

protocol CoreDataChannelServiceProtocol: AnyObject {
    func fetchChannels() -> [DBChannel]
    func save(block: @escaping (NSManagedObjectContext) throws -> Void)
    func deleteChannelsModels()
    func deleteChannelModel(with channelID: String)
}

final class CoreDataService {

    private lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "Chat")
        persistentContainer.loadPersistentStores { _, error in
            guard let error else { return }
            print(error)
        }
        backgroundContext = persistentContainer.newBackgroundContext()
        return persistentContainer
    }()

    private var backgroundContext: NSManagedObjectContext?

    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
}

extension CoreDataService: CoreDataMessageServiceProtocol {

    func fetchMessages(for channelID: String) -> [DBMessage] {
        Logger.log(text: "CoreDataService function: \(#function)")
        let fetchRequest = DBChannel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", channelID as CVarArg)
        do {
            let channel = try viewContext.fetch(fetchRequest).first
            guard let channel,
                  let messages = channel.messages?.array as? [DBMessage] else {
                return []
            }
            Logger.log(text:
            "Fetching messages from CoreData: \(messages) from channel with channelID \(channelID) done succesfully\n"
            )
            return messages
        } catch {
            Logger.log(text:
            "Fetching messages to channel with channelID \(channelID) from CoreData got error: \(error)\n"
            )
            return []
        }
    }
}

extension CoreDataService: CoreDataChannelServiceProtocol {

    func deleteChannelModel(with channelID: String) {
        Logger.log(text: "CoreDataService function: \(#function)")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DBChannel")
        fetchRequest.predicate = NSPredicate(format: "id == %@", channelID as CVarArg)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            _ = try backgroundContext?.execute(deleteRequest)
            Logger.log(text: "Deleting channel from CoreData with channelID \(channelID) done succesfully\n")
        } catch {
            Logger.log(text: "Deleting channel from CoreData with channelID \(channelID) got error: \(error)\n")
        }
    }

    func deleteChannelsModels() {
        Logger.log(text: "CoreDataService function: \(#function)")
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DBChannel")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: viewContext)
            Logger.log(text: "Deleting all channels from CoreData done succesfully\n")
        } catch {
            Logger.log(text: "Deleting all channels from CoreData got error: \(error)\n")
        }
    }

    private func fetchChannelMessages(for channelID: String) -> [DBMessage] {
        Logger.log(text: "CoreDataService function: \(#function)")
        let fetchRequest = DBChannel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", channelID as CVarArg)
        do {
            let channel = try viewContext.fetch(fetchRequest).first
            guard let channel,
                  let messages = channel.messages?.array as? [DBMessage] else {
                Logger.log(text: "There are no messages in channel with channelID \(channelID)")
                return []
            }
            Logger.log(text:
            "Fetched messages: \(messages) from CoreData for channel with channelID \(channelID) done succesfully\n"
            )
            return messages
        } catch {
            Logger.log(text: "Fetching messages for channel with channelID \(channelID) got error: \(error)\n")
            return []
        }
    }

    func fetchChannels() -> [DBChannel] {
        Logger.log(text: "CoreDataService function: \(#function)")
        let fetchRequest = DBChannel.fetchRequest()
        do {
            let channels = try viewContext.fetch(fetchRequest)
            for channel in channels {
                if let id = channel.id {
                    let messages = fetchMessages(for: id)
                    print(messages)
                    channel.messages = NSOrderedSet(array: messages)
                    if let lastMessage = messages.last {
                        if let text = lastMessage.text {
                            channel.lastMessage = text
                        }
                        if let date = lastMessage.date {
                            channel.lastActivity = date
                        }
                    }
                }
            }
            Logger.log(text: "Fetching all channels done correctly. Channels: \(channels)\n")
            return channels
        } catch {
            Logger.log(text: "Fetching all channels got error: \(error)\n")
            return []
        }
    }

    func save(block: @escaping (NSManagedObjectContext) throws -> Void) {
        Logger.log(text: "CoreDataService function: \(#function)")
        if let backgroundContext = backgroundContext {
            backgroundContext.perform {
                do {
                    try block(backgroundContext)
                    if backgroundContext.hasChanges {
                        try backgroundContext.save()
                    }
                Logger.log(text: "Saving CoreData done without error\n")
                } catch {
                    Logger.log(text: "Saving CoreData got error: \(error)\n")
                }
            }
        }
    }
}
