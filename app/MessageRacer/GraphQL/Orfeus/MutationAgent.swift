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
    /// GraphQL Query Observable to manage Query State
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
    public class MutationAgent<TMutation: GraphQLMutation>: ObservableObject, OrfeusAgent {
        
        // MARK: - States
        
        /// Data from the Mutation managed by the Agent
        @Published
        public var data: TMutation.Data? = nil
        
        /// isLoading state to notify where the operation has been resolved
        @Published
        public var isLoading: Bool = true
        
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
        ///          queryAgents.map { $0.invalidate() }
        ///     }
        /// )
        /// ```
        public func mutate(
            variables gql: TMutation,
            onCompleted: @escaping (TMutation.Data) -> Void = log,
            onFailure: @escaping (Error) -> Void = log
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
        fileprivate func assignData(datum: TMutation.Data) {
            withAnimation {
                data = datum
                isLoading = false
            }
        }
        
        /// GraphQL Network Request
        fileprivate func request(
            _ gql: TMutation,
            onSuccess: @escaping (TMutation.Data) -> Void,
            onFailure: @escaping (Error) -> Void
        ) -> Cancellable {
            isLoading = true
            return Orfeus.shared.perform(
                mutation: gql,
                onSuccess: { datum in
                    self.assignData(datum: datum)
                    onSuccess(datum)
                },
                onError: onFailure
            )
        }
    }

    
    
    /// Use GraphQL Mutation Agent with a default mutation
    public static func use<TMutation: GraphQLMutation>(
        mutation gql: TMutation.Type
    ) -> MutationAgent<TMutation> {
        MutationAgent(mutation: gql)
    }
}

public func log<T>(_ val: T) -> Void {
    print("\(val)")
}
