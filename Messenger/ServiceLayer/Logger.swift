//
//  Logger.swift
//  Messenger
//
//  Created by Андрей Лосюков on 13.04.2023.
//

import Foundation

class Logger {
    static func log(text: String) {
        if CommandLine.arguments.contains("-logs-enabled") {
            print("\(text)")
        }
    }
}
