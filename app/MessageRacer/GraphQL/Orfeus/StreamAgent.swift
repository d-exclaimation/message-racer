//
//  StreamAgent.swift
//  MessageRacer
//
//  Created by Vincent on 7/4/21.
//

import Foundation
import Apollo
import SwiftUI

extension Orfeus {
    /// GraphQL Subscription Observable to manage incoming data stream
    ///
    ///
    /// Usage: initialize and subscribe
    /// ```swift
    /// @StateObject
    /// var someSubscription = StreamAgent(
    ///     subscription: SomeGraphQLSubscription(),
    ///     initial: [SomeGraphQLSubscription.Data](),
    ///     reducer: { acc, curr in acc + [curr] }
    /// ).load()
    ///
    /// var body: some View {
    ///     Group {
    ///         switch roomAgent.state {
    ///         case .idle:
    ///             EmptyView("Not loaded")
    ///         case .loading:
    ///             Text("Loading...")
    ///         case .succeed(let data):
    ///             LazyVStack {
    ///                 ForEach(data, id: \.someGraphQL.id, content: DataView.init(data:))
    ///             }
    ///         }
    ///         case .failed(_):
    ///             Text("No data")
    ///         }
    ///     }
    ///     .onChange(someSubscription.state) { state in
    ///         // ... do something
    ///     }
    /// }
    /// ```
    ///
    /// Highly recommend taking advatage of `state` property as it allow for type safe, clear declarative workflow
    ///
    public class StreamAgent<TSubscription: GraphQLSubscription, StreamPayload>: ObservableObject, OrfeusAgent {
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
        public var state: AgentState<StreamPayload> = .idle
        
        /// Network request cancellable request
        ///
        /// Use this for cancelliing the request
        @Published
        public var cancellable: Cancellable? = nil
        
        /// Data from the Query managed by the Agent
        public var data: StreamPayload? {
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
        
        
        // MARK: - Public methods / actions
        
        /// Cancel subscription agent state, refetch data, and managed new states
        public func cancel() -> Void {
            cancellable?.cancel()
        }
        
        /// State subscription agent state, refetch data, and managed new states
        public func start() -> Void {
            cancellable = request()
        }
        
        /// State subscription agent state, refetch data, and managed new states
        public func load() -> StreamAgent {
            cancellable = request()
            return self
        }
        
        /// Register listener to perform side effects after data is given
        public func register(listener: @escaping (StreamPayload) -> Void) -> Void {
            listeners.append(listener)
        }
        
        /// Process incoming data and current data into one reduced payload
        public typealias StreamReducer = (StreamPayload, TSubscription.Data) -> StreamPayload
        
        /// Process incoming fault and current data into either payload or nil (fault will be placed aka shortcircuit)
        public typealias ErrorReducer = (StreamPayload, Fault) -> StreamPayload?
 
        /// Trigger to cancel subscription
        public enum CancelTrigger {
            case destroyAndFault, destroy, fault, never
        }
        
        // MARK: - Internal
        
        /// GraphQL Subscription operations
        private let subscription: TSubscription

        /// Reducer function to take in stream
        private let reducer: StreamReducer
        
        /// First initial payload
        private let initialPayload: StreamPayload
        
        /// Cancel trigger
        private let cancelOn: CancelTrigger
        
        /// Latest snapshot of stream payload
        private let errorHandler: ErrorReducer
    
        private var listeners = [(StreamPayload) -> Void]()
        
        /// Gettting the current payload
        private var payload: StreamPayload {
            data ?? initialPayload
        }
        
        /// Full initializer, does not automatically load the subscription
        public init(
            subscription gql: TSubscription,
            initial: StreamPayload,
            reducer fn: @escaping StreamReducer,
            cancelOn cancelTrigger: CancelTrigger,
            onError: @escaping ErrorReducer
        ) {
            subscription = gql
            initialPayload = initial
            errorHandler = onError
            reducer = fn
            cancelOn = cancelTrigger
        }
        
        /// Prevent memory leaked
        deinit {
            switch cancelOn {
            case .destroyAndFault, .destroy:
                cancellable?.cancel()
            default:
                return
            }
        }
        
        fileprivate func handleError(_ err: Fault) -> Void {
            if [CancelTrigger.fault, CancelTrigger.destroyAndFault].contains(cancelOn) {
                cancellable?.cancel()
            }
            withAnimation {
                switch errorHandler(payload, err) {
                case .some(let payload):
                    state = .succeed(payload)
                case .none:
                    state = .failed(err)
                }
            }
        }
        
        fileprivate func handleSuccess(data: TSubscription.Data) -> Void {
            withAnimation {
                let newPayload = reducer(payload, data)
                state = .succeed(newPayload)
                for listener in listeners {
                    listener(newPayload)
                }
            }
        }
        
        /// GraphQL Network Request
        fileprivate func request() -> Cancellable {
            state = .succeed(initialPayload)
            print("a")
            return Orfeus.shared.subscribe(
                subscription: subscription,
                onSuccess: handleSuccess(data:),
                onError: handleError(_:)
            )
        }
    }
    
    /// Use GraphQL Subscription Agent
    public static func agent<TSubscription: GraphQLSubscription, Payload>(
        stream gql: TSubscription,
        initial: Payload,
        reducer: @escaping StreamAgent<TSubscription, Payload>.StreamReducer,
        cancelOn: StreamAgent<TSubscription, Payload>.CancelTrigger = .destroy,
        pause: Bool = false,
        onError: @escaping StreamAgent<TSubscription, Payload>.ErrorReducer = { res, _ in res }
    ) -> StreamAgent<TSubscription, Payload> {
        pause ? StreamAgent(
            subscription: gql,
            initial: initial,
            reducer: reducer,
            cancelOn: cancelOn,
            onError: onError
        ) : StreamAgent(
            subscription: gql,
            initial: initial,
            reducer: reducer,
            cancelOn: cancelOn,
            onError: onError
        ).load()
    }
}

