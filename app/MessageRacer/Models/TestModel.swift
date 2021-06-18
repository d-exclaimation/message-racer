//
//  TestModel.swift
//  MessageRacer
//
//  Created by Vincent on 6/18/21.
//

import Foundation

public class PseudoData {
    public var value = 0
    func sideEffect() -> Int {
        print("Called \(value)")
        value += 1
        return value
    }
}
