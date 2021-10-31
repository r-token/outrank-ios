//
//  Date+DayBefore.swift
//  Outrank
//
//  Created by Ryan Token on 10/31/21.
//

import Foundation

extension Date {
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .hour, value: -15, to: self)!
    }
}
