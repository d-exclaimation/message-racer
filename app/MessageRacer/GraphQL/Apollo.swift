//
//  Apollo.swift
//  MessageRacer
//
//  Created by Vincent on 7/1/21.
//

import Foundation
import Apollo

public class Network {
    public static let shared = Network()
    public lazy var apollo = ApolloClient(url: URL(string: Preferences.shared.api)!)
    
    /// Fecth request and perform action according
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
}

