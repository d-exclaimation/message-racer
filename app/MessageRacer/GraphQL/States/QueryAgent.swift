//
//  QueryAgent.swift
//  MessageRacer
//
//  Created by Vincent on 7/1/21.
//

import Foundation
import Apollo
import SwiftUI

public class QueryAgent<TQuery: GraphQLQuery>: ObservableObject {
    // MARK: - States
    
    @Published
    public var data: TQuery.Data? = nil
    
    @Published
    public var isLoading: Bool = true
    
    @Published
    public var error: Error? = nil
    
    @Published
    public var cancellable: Cancellable? = nil
    
    public var vault: TQuery.Data {
        guard let fallback = fallback else {
            return data!
        }
        
        if let data = data {
            return data
        }
        return fallback()
    }
    
    // MARK: - Public methods / actions
    public func load() -> QueryAgent {
        cancellable = request()
        return self;
    }
    
    public func invalidate() -> Void {
        cancellable = request()
    }
    
    // MARK: - Internal
    
    private let query: TQuery
    
    private let fallback: Optional<() -> TQuery.Data>
    
    public convenience init(_ gql: TQuery) {
        self.init(query: gql, fallback: nil)
    }
    
    public init(query gql: TQuery, fallback fn: Optional<() -> TQuery.Data>) {
        query = gql
        fallback = fn
    }
    
    fileprivate func assignData(datum: TQuery.Data) {
        withAnimation {
            data = datum
            isLoading = false
        }
    }
    
    fileprivate func handleError(err: Error) {
        print("Error: \(err)")
        withAnimation {
            error = err
            isLoading = true
        }
    }
    
    fileprivate func request() -> Cancellable {
        isLoading = true
        return Graph.shared.fetch(
            query: query,
            onSuccess: assignData(datum:),
            onError: handleError(err:)
        )
    }
}

extension Graph {
    public static func useQuery<TQuery: GraphQLQuery>(
        query gql: TQuery,
        fallback fn: Optional<() -> TQuery.Data> = nil,
        pause: Bool = false
    ) -> QueryAgent<TQuery> {
        pause ? QueryAgent<TQuery>(query: gql, fallback: fn) : QueryAgent<TQuery>(query: gql, fallback: fn).load()
    }
}
