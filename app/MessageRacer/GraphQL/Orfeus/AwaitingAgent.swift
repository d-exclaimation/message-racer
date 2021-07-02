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
    public class AwaitingAgent<TQuery: GraphQLQuery>: ObservableObject, OrfeusInvalidatableAgent, OrfeusAgent {
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
            return Orfeus.shared.watch(
                query: query,
                onSuccess: assignData(datum:),
                onError: handleError(err:)
            )
        }
    }

    
    /// Use GraphQL Query Awaiting Agent
    public static func use<TQuery: GraphQLQuery>(
        awaiting gql: TQuery,
        fallback fn: Optional<TQuery.Data> = nil,
        pause: Bool = false,
        autoCancel: Bool = true
    ) -> AwaitingAgent<TQuery> {
        pause
        ? AwaitingAgent<TQuery>(query: gql, fallback: fn, autoCancel: autoCancel)
        : AwaitingAgent<TQuery>(query: gql, fallback: fn, autoCancel: autoCancel).watch()
    }
}

