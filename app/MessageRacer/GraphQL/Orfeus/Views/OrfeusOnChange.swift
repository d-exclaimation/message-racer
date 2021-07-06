//
//  OrfeusOnChange.swift
//  MessageRacer
//
//  Created by Vincent on 7/4/21.
//

import SwiftUI
import Apollo

struct OrfeusOnChange<TSubscription: GraphQLSubscription, StreamPayload>: ViewModifier {
    @ObservedObject
    var agent: Orfeus.StreamAgent<TSubscription, StreamPayload>
    
    let listener: (StreamPayload) -> Void
    
    public func body(content: Content) -> some View {
        content
            .onAppear {
                agent.sink(listener: listener)
            }
    }
}

extension View {
    /// Handle incoming data from stream, in case onChange does not cut it 
    ///
    /// Try `onReceive` as well to check for published value
    public func onDataChange<TSubscription: GraphQLSubscription, StreamPayload>(
        agent: Orfeus.StreamAgent<TSubscription, StreamPayload>,
        perform listener: @escaping (StreamPayload) -> Void
    ) -> some View {
        modifier(OrfeusOnChange<TSubscription, StreamPayload>(agent: agent, listener: listener))
    }

    // TODO: Test using changeRef
    /// Handle data changes in state
    @available(*, unavailable, message: "Experimental feature, has not been checked, tested nor used at all")
    public func onChange<TSubscription: GraphQLSubscription, StreamPayload>(
        for agent: Orfeus.StreamAgent<TSubscription, StreamPayload>, 
        perform effect: @escaping (StreamPayload) -> Void
    ) -> some View {
        onChange(of: agent.changeRef) { _ in 
            if case let .succeed(data) = agent.state {
                effect(data)
            }
        }
    }
}
