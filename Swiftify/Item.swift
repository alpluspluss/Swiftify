//
//  Item.swift
//  Swiftify
//
//  Created by Schnond Chansuk on 26/2/2568 BE.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
