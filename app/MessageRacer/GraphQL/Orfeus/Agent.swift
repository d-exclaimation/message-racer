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
    var data: Self.Data { get }
    var isLoading: Bool { get }
    var cancellable: Cancellable? { get }
    
    associatedtype Data
}

/// Invalidatable Agent that can peform invalidation of its own data from the outside
public protocol OrfeusInvalidatableAgent {
    func invalidate() -> Void
}

extension Orfeus {
    public enum AgentState<Data> {
        case idle
        case loading
        case succeed(Data)
        case failed(Fault)
        
        public var value: Data? {
            if case let .succeed(val) = self {
                return val
            }
            return nil
        }
        
        public var error: Fault? {
            if case let .failed(fault) = self {
                return fault
            }
            return nil
        }
        
        public var isLoading: Bool {
            if case .loading = self {
                return true
            }
            return false
        }
    }
}
extension Orfeus.AgentState: Equatable where Data: Equatable {
    public static func == (lhs: Orfeus.AgentState<Data>, rhs: Orfeus.AgentState<Data>) -> Bool {
        switch lhs {
        case .idle:
            return rhs == .idle
        case .loading:
            return rhs == .loading
        case .succeed(let lval):
            if case let .succeed(rval) = rhs {
                return lval == rval
            }
            return false
        case .failed(let lerr):
            if case let .failed(rerr) = rhs {
                return rerr.message == lerr.message
            }
            return false
        }
    }
    
}
