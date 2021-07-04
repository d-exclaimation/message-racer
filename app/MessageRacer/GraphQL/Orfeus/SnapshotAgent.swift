//
//  SnapshotAgent.swift
//  MessageRacer
//
//  Created by Vincent on 7/4/21.
//

import Foundation
import Apollo
import SwiftUI

extension Orfeus {
    /// GraphQL Subscription Observable to manage snapshot data
    ///
    /// By default, it will not immediatelly listen, unless `subscribe` method is called
    ///
    /// Usage: initialize and subscribe
    /// ```swift
    /// @StateObject
    /// var someSubscription = SnapshotAgent(subscription: SomeGraphQLSubscription.self)
    ///
    /// func startSubscription() {
    ///     someSubscription.subscribe(
    ///         subscription: SomeGraphQLSubscription(),
    ///         onReceive: onReceive
    ///     )
    /// }
    ///
    /// func onReceive(_ res: Result<SomeGraphQLSubscription.Data, Fault>) -> SnapshotAgent<SomeGraphQLSubscription>.ReceivedPackage  {
    ///     switch res {
    ///     case .succeed(let data): return .update(data)
    ///     case .failure(_): return .halt
    ///     }
    /// }
    /// ```
    ///
    /// Highly recommend taking advatage of `state` property as it allow for type safe, clear declarative workflow
    ///
    public class SnapshotAgent<TSubscription: GraphQLSubscription>: ObservableObject, OrfeusAgent {
        // MARK: - States
        
        /// State of the Subscription for better clarify over current situtation of data
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
        public var state: AgentState<Snapshot> = .idle
        
        /// Network request cancellable request
        ///
        /// Use this for cancelliing the request
        @Published
        public var cancellable: Cancellable? = nil
        
        /// Data from the Query managed by the Agent
        public var data: Snapshot? {
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
        
        /// Return value given from receiver
        public enum ReturnedSnapshot {
            case halt
            case update(Snapshot)
            case fault(Fault)
        }
        
        /// Function to handle incoming data
        public typealias SnapshotReceiver = (Result<Snapshot, Fault>) -> ReturnedSnapshot
        public typealias Snapshot = TSubscription.Data
        
        // MARK: - Public methods / actions
        
        /// Subscribe the  agent, usually used on start
        ///
        /// **Example: **
        /// ```swift
        /// @StateObject
        /// var someSubscription = SnapshotAgent(SomeGraphQLSubscription.self)
        ///
        /// func startSubscription() {
        ///     someSubscription.subscribe(
        ///         subscription: SomeGraphQLSubscription(),
        ///         onReceive: onReceive
        ///     )
        /// }
        ///
        /// func onReceive(_ res: Result<SomeGraphQLSubscription.Data, Fault>) -> SnapshotAgent<SomeGraphQLSubscription>.ReceivedPackage  {
        ///     switch res {
        ///     case .succeed(let data): return .update(data)
        ///     case .failure(_): return .halt
        ///     }
        /// }
        /// ```
        public func subscribe(
            subscription: TSubscription,
            onReceive: @escaping SnapshotReceiver
        ) -> Void {
            cancellable = request(operation: subscription, onReceive: onReceive)
        }
        
        /// Cancel subscription agent state, refetch data, and managed new states
        public func cancel() -> Void {
            cancellable?.cancel()
        }
        
        // MARK: - Internal
        
        /// GraphQL Subscription operations
        private let operation: TSubscription.Type

        /// Full initializer, does not automatically load the subscription
        public init(subscription gql: TSubscription.Type) {
            operation = gql
        }
        
        
        /// Handle receive
        fileprivate func handleReceive(
            _ res: Result<TSubscription.Data, Fault>,
            onReceive: @escaping SnapshotReceiver
        ) {
            withAnimation {
                switch onReceive(res) {
                case .halt:
                    cancellable?.cancel()
                case .update(let data):
                    state = .succeed(data)
                case .fault(let fault):
                    state = .failed(fault)
                }
            }
        }
        
        /// GraphQL Network Request
        fileprivate func request(
            operation: TSubscription,
            onReceive: @escaping SnapshotReceiver
        ) -> Cancellable {
            state = .loading
            return Orfeus.shared.subscribe(
                subscription: operation,
                onSuccess: { [weak self] data in self?.handleReceive(.success(data), onReceive: onReceive) },
                onError: { [weak self] fault in self?.handleReceive(.failure(fault), onReceive: onReceive) }
            )
        }
    }
    
    /// Use GraphQL Subscription Agent
    public static func agent<TSubscription: GraphQLSubscription>(
        snapshot gql: TSubscription.Type
    ) -> SnapshotAgent<TSubscription> {
        SnapshotAgent(subscription: gql)
    }
}

