//
//  Resources.swift
//  Messenger
//
//  Created by Андрей Лосюков on 27.02.2023.
//

import UIKit

enum Resources {
    enum Colors {
        static var active = UIColor(hexString: "#007AFF")
        static var inactive = UIColor(hexString: "#929DA5")
        static var separator = UIColor.systemGray
    }
    enum Images {
        static var noNameImage = UIImage(named: "noname")
        static var channel = UIImage(systemName: "bubble.left.and.bubble.right")
        static var settings = UIImage(systemName: "gear")
        static var profile = UIImage(systemName: "person.crop.circle")
        static var placeholder = UIImage(named: "placeholder")
    }
    enum Strings {
        static var channel = "Channel"
        static var settings = "Settings"
        static var profile = "Profile"
        static var pathToUniqueId = "uniqueId84319845/"
    }
}
