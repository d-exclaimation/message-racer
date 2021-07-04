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
    /// Highly recommend taking advatage of `state` property as it allow for type safe, clear declarative workflow
    ///
    public class QueryAgent<TQuery: GraphQLQuery>: ObservableObject, OrfeusInvalidatableAgent, OrfeusAgent {
        // MARK: - States
        
        /// State of the Query for better clarify over current situtation of data
        ///
        /// ```swift
        /// switch roomAgent.state {
        /// case .idle:
        ///     EmptyView("Not loaded")
        /// case .loading:
        ///     Text("Loading...")
        /// case .succeed(let data):
        ///     LazyVStack {
        ///         ForEach(data.posts, content: Post.init(post:))
        ///     }
        /// }
        /// case .failed(_):
        ///     Text("No data")
        /// }
        /// ```
        @Published
        public var state: AgentState<TQuery.Data> = .idle
        
        /// Network request cancellable request
        ///
        /// Use this for cancelliing the request
        @Published
        public var cancellable: Cancellable? = nil
        
        /// Data from the Query managed by the Agent
        public var data: TQuery.Data? {
            state.value
        }
        
        /// isLoading state to notify where the operation has been resolved
        public var isLoading: Bool {
            state.isLoading
        }
        
        /// Returned error when network fails
        public var error: Fault? {
            state.error
        }
        
        /// Vaulted data are data with the fallback mechanism
        ///
        /// Note: *Avoid using this when fallback is not given / nil*
        public var vault: TQuery.Data {
            guard let fallback = fallback else {
                return state.value!
            }
            return state.value ?? fallback
        }
        
        // MARK: - Public methods / actions
        
        /// Load the query agent, usually used on start
        public func load() -> QueryAgent {
            cancellable = request()
            return self;
        }
        
        /// Invalidate query agent state, refetch data, and managed new states
        public func invalidate() -> Void {
            cancellable?.cancel()
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
                state = .succeed(datum)
            }
        }
        
        /// Handling error callback
        fileprivate func handleError(err: Fault) {
            print("Error: \(err)")
            withAnimation {
                state = .failed(err)
            }
        }
        
        /// GraphQL Network Request
        fileprivate func request() -> Cancellable {
            state = .loading
            return Orfeus.shared.fetch(
                query: query,
                onSuccess: assignData(datum:),
                onError: handleError(err:)
            )
        }
    }

    
    /// Use GraphQL Query Agent
    public static func agent<TQuery: GraphQLQuery>(
        query gql: TQuery,
        fallback fn: Optional<TQuery.Data> = nil,
        pause: Bool = false
    ) -> QueryAgent<TQuery> {
        pause ? QueryAgent<TQuery>(query: gql, fallback: fn) : QueryAgent<TQuery>(query: gql, fallback: fn).load()
    }
}

