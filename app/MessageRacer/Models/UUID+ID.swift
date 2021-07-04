//
//  UUID+ID.swift
//  MessageRacer
//
//  Created by Vincent on 7/5/21.
//

import Foundation
extension UUID {
    var id: String {
        uuidString.lowercased()
    }
}
