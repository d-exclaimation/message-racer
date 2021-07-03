//
//  Orfeus.swift
//  MessageRacer
//
//  Created by Vincent on 7/1/21.
//

import Foundation
import Apollo

public class Orfeus {
    /// Shared singleton instance of Orfeus
    public static let shared = Orfeus()
    
    /// Apollo client wrapper
    public lazy var apollo = ApolloClient(url: URL(string: Preferences.shared.api)!)
    
    /// Fetch request and perform action according
    public func fetch<TQuery: GraphQLQuery>(
        query: TQuery,
        contextIdentifier: UUID? = nil,
        queue: DispatchQueue = .main,
        onSuccess: @escaping (TQuery.Data) -> Void,
        onError: @escaping (Fault) -> Void
    ) -> Cancellable  {
        
        apollo.fetch(
            query: query,
            contextIdentifier: contextIdentifier,
            queue: queue
        ) { self.resultHandler(res: $0, onSuccess: onSuccess, onError: onError) }
    }
    
    /// Fetch request and perform action according for each time cache is changed
    public func watch<TQuery: GraphQLQuery>(
        query: TQuery,
        queue: DispatchQueue = .main,
        onSuccess: @escaping (TQuery.Data) -> Void,
        onError: @escaping (Fault) -> Void
    ) -> Cancellable  {
        
        apollo.watch(
            query: query,
            callbackQueue: queue
        ) { self.resultHandler(res: $0, onSuccess: onSuccess, onError: onError) }
    }
    
    /// Perform request and handle result accordingly
    public func perform<TMutation: GraphQLMutation>(
        mutation: TMutation,
        storeResult: Bool = true,
        queue: DispatchQueue = .main,
        onSuccess: @escaping (TMutation.Data) -> Void,
        onError: @escaping (Fault) -> Void
    ) -> Cancellable {
        
        apollo.perform(
            mutation: mutation,
            publishResultToStore: storeResult,
            queue: queue
        ) { self.resultHandler(res: $0, onSuccess: onSuccess, onError: onError) }
    }
        
    private func resultHandler<Data>(
        res: Result<GraphQLResult<Data>, Error>,
        onSuccess: @escaping (Data) -> Void,
        onError: @escaping (Fault) -> Void
    ) -> Void {
        switch res {
        case.success(let resp):
            if let errors = resp.errors {
                return onError(Fault.graphqlErrors(errors: errors))
            }
            
            if let data = resp.data {
                DispatchQueue.main.async {
                    onSuccess(data)
                }
                return
            }
            
            return onError(Fault.nothingHappened)
        case .failure(let err):
            onError(Fault.requestFailed(reason: err.localizedDescription))
        }
    }
    
    /// Fault in the request or response
    public enum Fault: Error {
        case requestFailed(reason: String)
        case graphqlErrors(errors: [GraphQLError])
        case nothingHappened
        
        /// Message shorthand
        public var message: String {
            switch self {
            case .requestFailed(reason: let reason):
                return reason
            case .graphqlErrors(errors: let errors):
                return errors.map { $0.message }.compactMap { $0 }.joined(separator: ", ")
            case .nothingHappened:
                return "Nothing happened"
            }
        }
    }
}


