//
//  LoopableStruct.swift
//  TeamRankings
//
//  Created by Ryan Token on 10/2/21.
//

import Foundation

protocol Loopable {
    func allProperties() throws -> [String: String]
}

extension Loopable {
    func allProperties() throws -> [String: String] {
        var result: [String: String] = [:]

        let mirror = Mirror(reflecting: self)

        // Optional check to make sure we're iterating over a struct or class
        guard let style = mirror.displayStyle, style == .struct || style == .class else {
            throw NSError()
        }

        for (property, value) in mirror.children {
            guard let property = property else {
                continue
            }

            if let valueString = value as? String {
                result[property] = valueString
            } else {
                result[property] = ""
            }
        }

        return result
    }
}
