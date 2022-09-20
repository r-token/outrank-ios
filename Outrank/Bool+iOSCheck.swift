//
//  Bool+iOSCheck.swift
//  Outrank
//
//  Created by Ryan Token on 9/19/22.
//

import Foundation

extension Bool {
     static var iOS16: Bool {
         guard #available(iOS 16, *) else {
             // iOS 16 is not available, return false
             return false
         }
         // iOS 16 is available, return true
         return true
     }
 }
