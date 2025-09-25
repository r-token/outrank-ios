//
//  String+Identifiable.swift
//  Outrank
//
//  Created by Ryan Token on 10/5/21.
//

import Foundation

extension String: @retroactive Identifiable {
    public var id: String { self }
}
