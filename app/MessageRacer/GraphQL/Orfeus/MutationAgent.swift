//
//  MutationAgent.swift
//  MessageRacer
//
//  Created by Vincent on 7/2/21.
//

import Foundation
import Apollo
import SwiftUI

extension Orfeus {
    /// GraphQL Mutation Observable to manage Mutation State
    ///
    /// Usage: Instansiate agent
    /// ```swift
    /// @StateObject
    /// var someMutation = MutationAgent(
    ///     mutation: SomeGraphQLMutation.Type,
    /// )
    ///
    /// var body: some View {
    ///     Button {
    ///        someMutation.mutate(
    ///            variables: SomeGraphQLMutation(...params)
    ///        )
    ///     } label: {
    ///         Text("Mutate!")
    ///     }
    /// }
    /// ```
    /// Handling invalidate of data from QueryAgent
    /// ```swift
    /// someMutation.mutate(
    ///     variables: SomeGraphQLMutation,
    ///     onCompleted: { data in
    ///          someQuery.invalidate()
    ///     },
    ///     onError: { err in ... }
    /// )
    /// ```
    ///
    /// Orfeus have a wrapping enum for Error instead of raw Error or GraphQL. This is for being able to respond to any type failure
    /// Handling errors
    /// ```swift
    /// // Orfeus.Fault can network be failure, graphql errors from the server, or nothing happened (no data yet no errors)
    /// someMutation.mutate(
    ///     variables: SomeGraphQLMutation,
    ///     onCompleted: { data in ... },
    ///     onError: { err in
    ///         switch err {
    ///         case .requestFailed(let reason):
    ///             show(reason)
    ///         case .graphqlErrors(errors: let errors):
    ///             errors.map { $0.message }.forEach { show($0) }
    ///         case .nothingHappened:
    ///             show("Please wait while issues are being resolve!")
    ///     }
    /// )
    /// ```
    /// Highly recommend taking advatage of `state` property as it allow for type safe, clear declarative workflo
    ///
    public class MutationAgent<TMutation: GraphQLMutation>: ObservableObject, OrfeusAgent {
        
        // MARK: - States
        
        /// State of the Mutations for better clarify over current situtation of data
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
        public var state: AgentState<TMutation.Data> = .idle
        
        /// Data from the Mutation managed by the Agent
        public var data: TMutation.Data? {
            state.value
        }
        
        /// isLoading state to notify where the operation has been resolved
        public var isLoading: Bool {
            state.isLoading
        }
        
        /// Network request cancellable request
        ///
        /// Use this for cancelliing the request
        @Published
        public var cancellable: Cancellable? = nil
        
        // MARK: - Public methods / actions
        
        /// Perform the mutation
        ///
        /// Handling invalidate of data from QueryAgent
        /// ```swift
        /// someMutation.mutate(
        ///     variables: SomeGraphQLMutation,
        ///     onCompleted: { data in
        ///          someQuery.invalidate()
        ///     },
        ///     onError: { err in ... }
        /// )
        /// ```
        ///
        /// Handling invalidation of mutliple QueryAgent
        /// ```swift
        /// let queryAgents: [OrfeusInvalidatableAgent] = [...]
        /// someMutation.mutate(
        ///     variables: SomeGraphQLMutation,
        ///     onCompleted: { data in
        ///          queryAgents.forEach { $0.invalidate() }
        ///     }
        /// )
        /// ```
        /// Orfeus have a wrapping enum for Error instead of raw Error or GraphQL. This is for being able to respond to any type failure
        /// Handling errors
        /// ```swift
        /// // Orfeus.Fault can be network failure, graphql errors from the server, or nothing happened (no data yet no errors)
        /// someMutation.mutate(
        ///     variables: SomeGraphQLMutation,
        ///     onCompleted: { data in ... },
        ///     onError: { err in
        ///         switch err {
        ///         case .requestFailed(let reason):
        ///             show(reason)
        ///         case .graphqlErrors(errors: let errors):
        ///             errors.map { $0.message }.forEach { show($0) }
        ///         case .nothingHappened:
        ///             show("Please wait while issues are being resolve!")
        ///     }
        /// )
        /// ```
        public func mutate(
            variables gql: TMutation,
            onCompleted: @escaping (TMutation.Data) -> Void = log,
            onFailure: @escaping (Fault) -> Void = log
        ) -> Void {
            cancellable = request(
                gql,
                onSuccess: onCompleted,
                onFailure: onFailure
            )
        }
        
        // MARK: - Internal
        
        /// GraphQL Mutation Type
        private let mutation: TMutation.Type

        /// Full initializer, does not automatically load the query
        public init(mutation gql: TMutation.Type) {
            mutation = gql
        }
        
        /// Manage data callback
        fileprivate func assignData(datum: TMutation.Data, onSuccess: @escaping (TMutation.Data) -> Void) {
            withAnimation {
                state = .succeed(datum)
                Orfeus.shared.apollo.clearCache()
                onSuccess(datum)
            }
        }
        
        /// Handle error
        fileprivate func handleError(_ err: Fault, onFailure: @escaping (Fault) -> Void) {
            withAnimation {
                state = .failed(err)
                onFailure(err)
            }
        }
        
        /// GraphQL Network Request
        fileprivate func request(
            _ gql: TMutation,
            onSuccess: @escaping (TMutation.Data) -> Void,
            onFailure: @escaping (Fault) -> Void
        ) -> Cancellable {
            state = .loading
            return Orfeus.shared.perform(
                mutation: gql,
                onSuccess: { [weak self] data in self?.assignData(datum: data, onSuccess: onSuccess) },
                onError: { [weak self] err in self?.handleError(err, onFailure: onFailure) }
            )
        }
    }

    
    
    /// Use GraphQL Mutation Agent with a default mutation
    public static func agent<TMutation: GraphQLMutation>(
        mutation gql: TMutation.Type
    ) -> MutationAgent<TMutation> {
        MutationAgent(mutation: gql)
    }

    /// Use Wrapped GraphQL Mutation Agent with a default mutation
    public static func wrapped<TMutation: GraphQLMutation>(
         mutation gql: TMutation.Type
    ) -> StateObject<MutationAgent<TMutation>> {
        StateObject(wrappedValue: MutationAgent(mutation: gql))
    }
     
}

public func log<T>(_ val: T) -> Void {
    print("\(val)")
}
