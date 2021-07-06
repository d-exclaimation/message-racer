//
//  QueryAwaitingAgent.swift
//  MessageRacer
//
//  Created by Vincent on 7/2/21.
//

import Foundation
import Apollo
import SwiftUI

extension Orfeus {
    /// GraphQL Query Observable to manage Query State but await for changes in cache and automatically update
    ///
    ///
    /// Usage: initialize and load
    /// ```swift
    /// @StateObject
    /// var someQuery = QueryAwaitingAgent(SomeGraphQLQuery()).watch()
    /// ```
    ///
    /// Usage: Initialize not load
    /// ```swift
    /// @StateObject
    /// var someQuery = QueryAwaitingAgent(
    ///     query: SomeGraphQLQuery(),
    ///     fallback: nil
    /// )
    /// // Data is not loaded nor watched
    /// ```
    ///
    /// **Note**: To prevent memory leak, by default when object is destoyed, any network request will be cancelled.
    /// To change this set `autoCancel` to false
    /// ```swift
    /// @StateObject
    /// var someQuery = QueryAwaitingAgent(
    ///     query: SomeGraphQLQuery(),
    ///     fallback: nil,
    ///     autoCancel: false
    /// )
    /// ```
    ///
    /// Highly recommend taking advatage of `state` property as it allow for type safe, clear declarative workflow
    ///
    public class AwaitingAgent<TQuery: GraphQLQuery>: ObservableObject, OrfeusInvalidatableAgent, OrfeusAgent {
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
        public func watch() -> AwaitingAgent {
            cancellable = request()
            return self;
        }
        
        /// Invalidate query agent state, refetch data, and managed new states
        public func invalidate() -> Void {
            cancel()
            cancellable = request()
        }
        
        /// Cancel all request from the watching mechanism
        public func cancel() -> Void {
            cancellable?.cancel()
        }
        
        // MARK: - Internal
        
        /// GraphQL Query operations
        private let query: TQuery

        /// Fallback data mechanism
        private let fallback: Optional<TQuery.Data>
        
        /// Notifier when to autocancel watch request
        private let cancelOnDestroy: Bool
        
        /// Non-fallback convenience initializer
        public convenience init(_ gql: TQuery) {
            self.init(query: gql, fallback: nil)
        }
        
        /// Full initializer, does not automatically load the query
        public init(query gql: TQuery, fallback fn: Optional<TQuery.Data>, autoCancel: Bool = true) {
            query = gql
            fallback = fn
            cancelOnDestroy = autoCancel
        }
        
        /// Prevent memory leaked
        deinit {
            if !cancelOnDestroy { return }
            cancel()
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
            return Orfeus.shared.watch(
                query: query,
                onSuccess: assignData(datum:),
                onError: handleError(err:)
            )
        }
    }

    
    /// Use GraphQL Query Awaiting Agent
    public static func agent<TQuery: GraphQLQuery>(
        awaiting gql: TQuery,
        fallback fn: Optional<TQuery.Data> = nil,
        pause: Bool = false,
        autoCancel: Bool = true
    ) -> AwaitingAgent<TQuery> {
        pause
        ? AwaitingAgent<TQuery>(query: gql, fallback: fn, autoCancel: autoCancel)
        : AwaitingAgent<TQuery>(query: gql, fallback: fn, autoCancel: autoCancel).watch()
    }

    /// Use Wrapped GraphQL Query Awaiting Agent
    public static func wrapped<TQuery: GraphQLQuery>(
        awaiting gql: TQuery,
        fallback fn: Optional<TQuery.Data> = nil,
        pause: Bool = false,
        autoCancel: Bool = true
    ) -> StateObject<AwaitingAgent<TQuery>> {
        StateObject(wrappedValue: pause
            ? AwaitingAgent<TQuery>(query: gql, fallback: fn, autoCancel: autoCancel)
            : AwaitingAgent<TQuery>(query: gql, fallback: fn, autoCancel: autoCancel).watch()
        )
    }
     
}

