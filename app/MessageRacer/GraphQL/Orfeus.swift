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
        onError: @escaping (Error) -> Void
    ) -> Cancellable  {
        
        apollo.fetch(
            query: query,
            contextIdentifier: contextIdentifier,
            queue: queue
        ) { res in
            switch res {
            case.success(let resp):
                DispatchQueue.main.async {
                    if let data = resp.data {
                        onSuccess(data)
                    }
                }
            case .failure(let err):
                onError(err)
            }
        }
    }
    
    /// Fetch request and perform action according for each time cache is changed
    public func watch<TQuery: GraphQLQuery>(
        query: TQuery,
        queue: DispatchQueue = .main,
        onSuccess: @escaping (TQuery.Data) -> Void,
        onError: @escaping (Error) -> Void
    ) -> Cancellable  {
        
        apollo.watch(
            query: query,
            callbackQueue: queue
        ) { res in
            switch res {
            case.success(let resp):
                DispatchQueue.main.async {
                    if let data = resp.data {
                        onSuccess(data)
                    }
                }
            case .failure(let err):
                onError(err)
            }
        }
    }
    
    /// Perform request and handle result accordingly
    public func perform<TMutation: GraphQLMutation>(
        mutation: TMutation,
        storeResult: Bool = true,
        queue: DispatchQueue = .main,
        onSuccess: @escaping (TMutation.Data) -> Void,
        onError: @escaping (Error) -> Void
    ) -> Cancellable {
        
        apollo.perform(
            mutation: mutation,
            publishResultToStore: storeResult,
            queue: queue
        ) { res in
            switch res {
            case .success(let resp):
                DispatchQueue.main.async {
                    if let data = resp.data {
                        onSuccess(data)
                    }
                }
            case .failure(let err):
                onError(err)
            }
        }
    }
    
}
