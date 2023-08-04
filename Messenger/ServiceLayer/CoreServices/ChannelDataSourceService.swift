import Foundation

protocol ChannelDataSourceProtocol: AnyObject {

    func saveChannelModel(with channelModel: DBChannelModel)

    func saveChannelsModels(with channelsModels: [DBChannelModel])

    func getChannelsModels() -> [DBChannelModel]

    func deleteChannelModel(with channelID: String)

    func deleteChannelsModels()
}

final class ChannelDataSourceService: ChannelDataSourceProtocol {

    let coreDataChannelService: CoreDataChannelServiceProtocol

    init(coreDataChannelService: CoreDataChannelServiceProtocol) {
        self.coreDataChannelService = coreDataChannelService
    }

    func deleteChannelModel(with channelID: String) {
        coreDataChannelService.deleteChannelModel(with: channelID)
    }

    func deleteChannelsModels() {
        coreDataChannelService.deleteChannelsModels()
    }

    func getChannelsModels() -> [DBChannelModel] {
        let channels = coreDataChannelService.fetchChannels()
        let channelsModels: [DBChannelModel] = channels.compactMap { channel in
            guard
                let id = channel.id,
                let name = channel.name
            else {
                return nil
            }
            return DBChannelModel(
                id: id,
                lastActivity: channel.lastActivity,
                lastMessage: channel.lastMessage,
                logoURL: channel.logoURL,
                name: name
            )
        }
        return channelsModels
    }

    func saveChannelsModels(with channelsModels: [DBChannelModel]) {
        for channelModel in channelsModels {
            saveChannelModel(with: channelModel)
        }
    }

    func saveChannelModel(with channelModel: DBChannelModel) {
        coreDataChannelService.save { context in
            let channel = DBChannel(context: context)
            channel.id = channelModel.id
            channel.name = channelModel.name
            channel.lastActivity = channelModel.lastActivity
            channel.lastMessage = channelModel.lastMessage
            channel.logoURL = channelModel.logoURL
            if channel.messages == nil {
                channel.messages = NSOrderedSet()
            }
            Logger.log(
            text: "Save channel: \(channelModel) in channel with channelID: \(channelModel.id) done succesfully\n"
            )
        }
    }
}
