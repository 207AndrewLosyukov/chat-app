//
//  DateExtension.swift
//  Messenger
//
//  Created by Андрей Лосюков on 07.03.2023.
//

import Foundation

extension Date {
    func get(_ type: Calendar.Component) -> Int {
        let calendar = Calendar.current
        let count = calendar.component(type, from: self)
        return count
    }
    func daysBetween(date: Date) -> Int {
         return Date.daysBetween(start: self, end: date)
    }
    static func daysBetween(start: Date, end: Date) -> Int {
         let calendar = Calendar.current
         let firstDate = calendar.startOfDay(for: start)
         let secondDate = calendar.startOfDay(for: end)
         let difference = calendar.dateComponents([.day], from: firstDate, to: secondDate)
         return difference.value(for: .day) ?? 0
     }
}
