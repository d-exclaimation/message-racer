//
//  Agent.swift
//  MessageRacer
//
//  Created by Vincent on 7/2/21.
//

import Foundation
import Apollo

/// Orfues Agent that manage state data and loading indication
public protocol OrfeusAgent {
    var data: Self.Data? { get }
    var isLoading: Bool { get }
    var cancellable: Cancellable? { get }
    
    associatedtype Data: GraphQLSelectionSet
}

/// Invalidatable Agent that can peform invalidation of its own data from the outside
public protocol OrfeusInvalidatableAgent {
    func invalidate() -> Void
}
