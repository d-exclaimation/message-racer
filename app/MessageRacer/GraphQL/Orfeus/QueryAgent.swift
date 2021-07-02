//
//  QueryAgent.swift
//  MessageRacer
//
//  Created by Vincent on 7/1/21.
//

import Foundation
import Apollo
import SwiftUI

extension Orfeus {
    /// GraphQL Query Observable to manage Query State
    ///
    /// Usage: initialize and load
    /// ```swift
    /// @StateObject
    /// var someQuery = QueryAgent(SomeGraphQLQuery()).load()
    /// ```
    ///
    /// Usage: Initialize not load
    /// ```swift
    /// @StateObject
    /// var someQuery = QueryAgent(
    ///     query: SomeGraphQLQuery(),
    ///     fallback: nil
    /// )
    /// // Data is not loaded
    /// ```
    ///
    public class QueryAgent<TQuery: GraphQLQuery>: ObservableObject, OrfeusInvalidatableAgent, OrfeusAgent {
        // MARK: - States
        
        /// Data from the Query managed by the Agent
        @Published
        public var data: TQuery.Data? = nil
        
        /// isLoading state to notify where the operation has been resolved
        @Published
        public var isLoading: Bool = true
        
        /// Returned error when network fails
        @Published
        public var error: Error? = nil
        
        /// Network request cancellable request
        ///
        /// Use this for cancelliing the request
        @Published
        public var cancellable: Cancellable? = nil
        
        /// Vaulted data are data with the fallback mechanism
        ///
        /// Note: *Avoid using this when fallback is not given / nil*
        public var vault: TQuery.Data {
            guard let fallback = fallback else {
                return data!
            }
            return data ?? fallback
        }
        
        // MARK: - Public methods / actions
        
        /// Load the query agent, usually used on start
        public func load() -> QueryAgent {
            cancellable = request()
            return self;
        }
        
        /// Invalidate query agent state, refetch data, and managed new states
        public func invalidate() -> Void {
            cancellable = request()
        }
        
        // MARK: - Internal
        
        /// GraphQL Query operations
        private let query: TQuery

        /// Fallback data mechanism
        private let fallback: Optional<TQuery.Data>
        
        /// Non-fallback convenience initializer
        public convenience init(_ gql: TQuery) {
            self.init(query: gql, fallback: nil)
        }
        
        /// Full initializer, does not automatically load the query
        public init(query gql: TQuery, fallback fn: Optional<TQuery.Data>) {
            query = gql
            fallback = fn
        }
        
        /// Manage data callback
        fileprivate func assignData(datum: TQuery.Data) {
            withAnimation {
                data = datum
                isLoading = false
            }
        }
        
        /// Handling error callback
        fileprivate func handleError(err: Error) {
            print("Error: \(err)")
            withAnimation {
                error = err
                isLoading = true
            }
        }
        
        /// GraphQL Network Request
        fileprivate func request() -> Cancellable {
            isLoading = true
            return Orfeus.shared.fetch(
                query: query,
                onSuccess: assignData(datum:),
                onError: handleError(err:)
            )
        }
    }

    
    /// Use GraphQL Query Agent
    public static func use<TQuery: GraphQLQuery>(
        query gql: TQuery,
        fallback fn: Optional<TQuery.Data> = nil,
        pause: Bool = false
    ) -> QueryAgent<TQuery> {
        pause ? QueryAgent<TQuery>(query: gql, fallback: fn) : QueryAgent<TQuery>(query: gql, fallback: fn).load()
    }
}

